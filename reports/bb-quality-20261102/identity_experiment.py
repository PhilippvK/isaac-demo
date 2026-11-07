"""Live fixed-ID regression checks, using only an isolated Memgraph endpoint."""
from pathlib import Path
import json,os,shlex,subprocess
import pandas as pd
from neo4j import GraphDatabase
from isaac_toolkit.session import Session
from isaac_toolkit.session.artifact import ElfArtifact,TableArtifact
from isaac_toolkit.analysis.static.llvm_bbs import parse_elf
from isaac_toolkit.generate.cdfg.memgraph import generate_memgraph_cdfg_via_compile_commands
from isaac_toolkit.utils.bb_identity import *
root=Path(__file__).resolve().parent; repo=root.parent.parent
os.environ.update(MEMGRAPH_HOST='127.0.0.1',MEMGRAPH_PORT='28763')
source=root/'identity-cases.c';source.write_text((repo/'reports/bb-identities/cases.c').read_text())
compiler=repo/'llvm-project/build/bin/clang';obj=root/'identity.o';elf=root/'identity.elf'
args=[str(compiler),'--target=riscv32','-march=rv32im','-mabi=ilp32','-O2','-g','-fbasic-block-sections=labels','-fglobal-isel','-mllvm','-global-isel-abort=0','-c',str(source),'-o',str(obj)]
subprocess.run(args,check=True)
subprocess.run([str(repo/'llvm-project/build/bin/ld.lld'),'-m','elf32lriscv','--unresolved-symbols=ignore-all','-e','choose','-Ttext=0x10000',str(obj),'-o',str(elf)],check=True)
sess=Session.create(root/'identity-session-v2')
sess.add_artifact(ElfArtifact('identity.elf',elf))
attrs=dict(elf_sha256=file_digest(elf),bb_map_decoder=2)
blocks=parse_elf(elf)
df=pd.DataFrame([dict(func_name=f,bb_name=f'%bb.{i}',bb_id=int(i),num_instrs=v[3],file=str(source),freq=10+int(i),rel_weight=.1) for f,bs in blocks.items() for i,v in bs.items()])
for name in ('llvm_bbs','llvm_bbs_new'):sess.add_artifact(TableArtifact(name,df.copy(),attrs=attrs.copy()))
sess.add_artifact(TableArtifact('choices',df[(df.func_name=='choose') & df.bb_id.isin([1,3])].copy(),attrs=attrs.copy()))
sess.add_artifact(TableArtifact('compile_commands',pd.DataFrame([dict(file=str(source),directory=str(root),command=shlex.join(args))]),attrs={'kind':'compile_commands'}))
label='bb-quality-identity'
generate_memgraph_cdfg_via_compile_commands(sess,label,stage=32)
imports=verified_imports(sess,label,32);context=context_for_choice(imports,{'func_name':'choose','file':str(source)})
checks={};mapping=[]
with GraphDatabase.driver('bolt://127.0.0.1:28763',auth=('','')) as driver:
 verify_graph_receipts(driver,imports,label);checks['fresh_receipts']=True
 with driver.session() as db:
  inventory=[dict(r) for r in db.run('MATCH (b:BB) WHERE b.session=$label RETURN b.func_name AS func,b.bb_id AS fixed,b.name AS mir',label=label)]
 for fixed in [1,3]:
  actual=resolve_block(driver,label,'choose',fixed,context)
  old=[b['fixed'] for b in inventory if b['func']=='choose' and b['mir']==f'%bb.{fixed}']
  mapping.append(dict(requested_fixed_id=fixed,new_mir=actual['mir_name'],old_name_join_fixed_ids=old,new_correct=True,old_correct=old==[fixed]))
 def rejects(name,fn):
  try:fn()
  except BBIdentityError:checks[name]=True
  else:checks[name]=False
 rejects('late_created_block_not_silently_substituted',lambda:resolve_block(driver,label,'choose',4,context))
 rejects('wrong_compilation_rejected',lambda:resolve_block(driver,label,'choose',1,dict(context,compilation_id='wrong')))
 original=source.read_bytes()
 try:
  source.write_bytes(original+b'\n/* changed */\n')
  rejects('changed_source_rejected',lambda:verified_imports(sess,label,32))
 finally:source.write_bytes(original)
 artifact_elf=next(a.path for a in sess.artifacts if a.flags & __import__('isaac_toolkit.session.artifact',fromlist=['ArtifactFlag']).ArtifactFlag.ELF)
 raw=artifact_elf.read_bytes()
 try:
  artifact_elf.write_bytes(raw+b'x')
  rejects('changed_elf_rejected',lambda:verified_imports(sess,label,32))
 finally:artifact_elf.write_bytes(raw)
 with driver.session() as db:
  with db.begin_transaction() as tx:
   tx.run('MATCH (b:BB) WHERE b.session=$label AND b.func_name="choose" AND b.bb_id=1 CREATE (d:BB) SET d=properties(b)',label=label).consume()
   # Separate sessions cannot observe an uncommitted duplicate; test the receipt
   # mutation after commit, then remove the duplicate in finally.
   tx.commit()
 try:
  rejects('duplicate_block_rejected',lambda:resolve_block(driver,label,'choose',1,context))
  rejects('modified_graph_receipt_rejected',lambda:verify_graph_receipts(driver,imports,label))
 finally:
  with driver.session() as db:
   db.run('MATCH (b:BB) WHERE b.session=$label AND b.func_name="choose" AND b.bb_id=1 WITH b ORDER BY id(b) DESC LIMIT 1 DETACH DELETE b',label=label).consume()
 verify_graph_receipts(driver,imports,label)
checks['all']=all(checks.values())
(root/'identity-results.json').write_text(json.dumps(dict(checks=checks,mapping=mapping,inventory=inventory),indent=2))
print(json.dumps(dict(checks=checks,mapping=mapping),indent=2))
assert checks['all']
