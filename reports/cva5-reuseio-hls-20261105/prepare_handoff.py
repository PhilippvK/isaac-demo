from pathlib import Path
import copy,hashlib,json,pickle,shutil,yaml
from collections import Counter
from m2isar.metamodel import M2Model,M2_METAMODEL_VERSION,behav
from m2isar.backends.coredsl2.writer import gen_cdsl_code
root=Path(__file__).resolve().parent;repo=root.parents[1];run=root/'runs/crc32/20261105T120000';gen=run/'work/gen'
def refs(instruction):
 result=[];pending=[instruction.operation]
 while pending:
  n=pending.pop()
  if isinstance(n,(behav.NamedReference,behav.IndexedReference)):result.append(n)
  if isinstance(n,behav.BaseNode):
   for v in vars(n).values():
    if isinstance(v,behav.BaseNode):pending.append(v)
    elif isinstance(v,(list,tuple)):pending.extend(x for x in v if isinstance(x,behav.BaseNode))
 return result
model=pickle.load((gen/'gen_model/XIsaac.hls.m2isarmodel').open('rb'));full=model.sets['XIsaac']
source=pickle.load((gen/'XIsaac.m2isarmodel').open('rb')).sets['XIsaac']
assert len(full.instructions)==len(source.instructions)==116
memory={k:i for k,i in full.instructions.items() if any(getattr(n.reference,'name',None)=='MEM' for n in refs(i))}
assert len(memory)==5
for i in memory.values():
 accesses=[n for n in refs(i) if getattr(n.reference,'name',None)=='MEM']
 assert len(accesses)==1 and isinstance(accesses[0],behav.IndexedReference) and accesses[0].right is not None
for k,i in full.instructions.items():
 assert (i.code,i.mask)==(source.instructions[k].code,source.instructions[k].mask)
inputs=root/'hls-inputs';(inputs/'crc32').mkdir(parents=True,exist_ok=True)
shutil.copy2(gen/'XIsaac.hls.core_desc',inputs/'crc32/XIsaac.hls.core_desc')
focused=copy.deepcopy(full);focused.name='XMemoryCRC32';focused.instructions=memory
(inputs/'crc32/XMemoryCRC32.hls.core_desc').write_text(gen_cdsl_code(M2Model(M2_METAMODEL_VERSION,{}, {'XMemoryCRC32':focused},{}),with_includes=False,legacy=True))
branch=pickle.load((inputs/'branch-probes/gen_model/XBranch.hls.m2isarmodel').open('rb')).sets['XBranch']
assert len(branch.instructions)==6 and 'PC' in branch.register_banks
assert all(any(getattr(n.reference,'name',None)=='PC' for n in refs(i)) for i in branch.instructions.values())
index=yaml.safe_load((run/'work/combined_index.yml').read_text());kinds=Counter('branch' if c['properties']['#Branches'] else 'memory' if c['properties']['#Mems'] else 'arithmetic' for c in index['candidates'])
files={str(p.relative_to(root)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in inputs.rglob('*.hls.core_desc')}
config=root/'config';config.mkdir(exist_ok=True)
for path in ('cfg/flow/paper/cva5_reuseio.env','cfg/isaac/query/paper/cva5_reuseio.yml','cfg/isaac_toolkit/cva5_reuseio.yml'):shutil.copy2(repo/path,config/Path(path).name)
manifest={'status':'ready_for_external_hls_backend','workload':'crc32','preset':'cva5_reuseio','core':'CVA5','requested_interface':'SCAIE-V 2.0','interface_verified':False,'hls_executed':False,'asip_synthesis_enabled':False,'fpga_synthesis_enabled':False,'run_directory':str(run),'discovered_candidates':dict(kinds),'supplemental_branch_probes':6,'checks':{'baseline_validation_passed':True,'selected_bb_validation_passed':True,'cold_bb_frame_count_mismatches':2,'full_hls_parsed_instructions':116,'memory_slices_preserved':5,'encoding_roundtrip_matches':True},'inputs':files,'limitation':'CRC32 decrement/branch has a live register result; current effect-only branch generation rejects it. Six known branch probes are separate supplemental inputs.'}
(root/'handoff.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps(manifest,indent=2))
