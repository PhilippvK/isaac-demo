"""Live Toolkit import/receipt checks, restricted to this experiment's labels."""
from pathlib import Path
import json, os, shlex, subprocess, uuid
from elftools.elf.elffile import ELFFile
import pandas as pd
from neo4j import GraphDatabase
from isaac_toolkit.session import Session
from isaac_toolkit.session.artifact import ElfArtifact, TableArtifact
from isaac_toolkit.analysis.static.llvm_bbs import parse_elf
from isaac_toolkit.generate.cdfg.memgraph import generate_memgraph_cdfg_via_compile_commands
from isaac_toolkit.utils.bb_identity import (
    BBIdentityError, file_digest, verified_imports, context_for_choice,
    verify_graph_receipts, resolve_block,
)
root=Path(__file__).resolve().parent
repo=root.parents[1]
port=os.environ.get('MEMGRAPH_PORT', '28764')
os.environ.update(MEMGRAPH_HOST='127.0.0.1', MEMGRAPH_PORT=port)
source=root/'identity-cases.c'
source.write_text((repo/'reports/bb-identities/cases.c').read_text())
compiler=repo/'llvm-project-22/build/bin/clang'
obj=root/'identity.o';elf=root/'identity.elf'
mode=os.environ.get('ISEL_MODE','gisel')
assert mode in ('dag','gisel')
args=[str(compiler),'--target=riscv32','-march=rv32im','-mabi=ilp32','-O2','-g',
      '-fbasic-block-sections=labels']
if mode=='gisel':
    args += ['-fglobal-isel','-mllvm','-global-isel-abort=1']
args += ['-c',str(source),'-o',str(obj)]
subprocess.run(args,check=True)
subprocess.run([str(repo/'llvm-project-22/build/bin/ld.lld'),'-m','elf32lriscv',
                '--unresolved-symbols=ignore-all','-e','choose','-Ttext=0x10000',str(obj),'-o',str(elf)],check=True)
label='isaac-llvm22-port-'+uuid.uuid4().hex
sess=Session.create(root/('identity-session-'+label.rsplit('-',1)[1]))
sess.add_artifact(ElfArtifact('identity.elf',elf))
attrs=dict(elf_sha256=file_digest(elf),bb_map_decoder=2)
blocks=parse_elf(elf)
df=pd.DataFrame([dict(func_name=f,bb_name=f'%bb.{i}',bb_id=int(i),num_instrs=v[3],file=str(source),freq=10+int(i),rel_weight=.1)
                 for f,bs in blocks.items() for i,v in bs.items()])
for name in ('llvm_bbs','llvm_bbs_new'):
    sess.add_artifact(TableArtifact(name,df.copy(),attrs=attrs.copy()))
sess.add_artifact(TableArtifact('choices',df[(df.func_name=='choose') & (df.num_instrs>0)].copy(),attrs=attrs.copy()))
sess.add_artifact(TableArtifact('compile_commands',pd.DataFrame([dict(file=str(source),directory=str(root),command=shlex.join(args))]),attrs={'kind':'compile_commands'}))
generate_memgraph_cdfg_via_compile_commands(sess,label,stage=32)
imports=verified_imports(sess,label,32)
context=context_for_choice(imports,{'func_name':'choose','file':str(source)})
checks={'fresh_receipts':True};mapping=[]
def rejects(name,fn):
    try:
        fn()
    except BBIdentityError:
        checks[name]=True
    else:
        checks[name]=False
with GraphDatabase.driver(f'bolt://127.0.0.1:{port}',auth=('','')) as driver:
    verify_graph_receipts(driver,imports,label)
    with driver.session() as db:
        inventory=[dict(row) for row in db.run('MATCH (b:BB) WHERE b.session=$label AND b.func_name="choose" RETURN b.bb_id AS fixed,b.name AS mir',label=label)]
    graph_ids={row['fixed'] for row in inventory}
    elf_ids={int(i) for i,v in blocks['choose'].items() if v[3]>0}
    for fixed in sorted(elf_ids & graph_ids):
        actual=resolve_block(driver,label,'choose',fixed,context)
        mapping.append(dict(fixed_id=fixed,mir=actual['mir_name']))
    assert mapping, 'No shared fixed BB IDs between ELF and stage32'
    for fixed in sorted(elf_ids - graph_ids):
        rejects(f'late_bb_{fixed}_rejected',lambda fixed=fixed:resolve_block(driver,label,'choose',fixed,context))
    # Verify the exporting observer leaves generated machine code unchanged.
    exported=root/'identity-export.o'
    export_args=args[:-1]+[str(exported)]
    for option in ['-cdfg-enable=1', '-cdfg-stage-mask=32', '-cdfg-memgraph-purge=0',
                   '-cdfg-memgraph-host=127.0.0.1', f'-cdfg-memgraph-port={port}',
                   '-cdfg-memgraph-session='+label+'-neutral']:
        export_args += ['-mllvm', option]
    subprocess.run(export_args,check=True)
    with obj.open('rb') as a, exported.open('rb') as b:
        assert ELFFile(a).get_section_by_name('.text').data()==ELFFile(b).get_section_by_name('.text').data()
    checks['export_preserves_machine_code']=True
    fixed=mapping[0]['fixed_id']
    rejects('wrong_compilation_rejected',lambda:resolve_block(driver,label,'choose',fixed,dict(context,compilation_id='wrong')))
    original=source.read_bytes()
    try:
        source.write_bytes(original+b'\n/* changed */\n')
        rejects('changed_source_rejected',lambda:verified_imports(sess,label,32))
    finally:
        source.write_bytes(original)
    with driver.session() as db:
        db.run('MATCH (b:BB) WHERE b.session=$label AND b.func_name="choose" AND b.bb_id=$fixed CREATE (d:BB) SET d=properties(b)',label=label,fixed=fixed).consume()
    rejects('duplicate_block_rejected',lambda:resolve_block(driver,label,'choose',fixed,context))
    rejects('modified_graph_receipt_rejected',lambda:verify_graph_receipts(driver,imports,label))
    with driver.session() as db:
        db.run('MATCH (b:BB) WHERE b.session=$label AND b.func_name="choose" AND b.bb_id=$fixed WITH b ORDER BY id(b) DESC LIMIT 1 DETACH DELETE b',label=label,fixed=fixed).consume()
    verify_graph_receipts(driver,imports,label)
(root/f'identity-results-{mode}.json').write_text(json.dumps(dict(label=label,checks=checks,mapping=mapping,inventory=inventory,late_elf_ids=sorted(elf_ids-graph_ids)),indent=2))
print(json.dumps(dict(checks=checks,mapping=mapping),indent=2))
assert all(checks.values()),checks
