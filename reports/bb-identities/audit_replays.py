from pathlib import Path
import re,json
import pandas as pd
root=Path('/tmp/isaac-bbid-investigation')
results={}
for name,graph,run,logs in [
 ('sha',0,'out/embench_iot/nettle-sha256/20261021T203457',['replay-sha-nettle-sha256.log']),
 ('crc',2,'out/embench_iot/crc32/20261021T203031',['replay-crc-beebsc.log','replay-crc-crc_32.log'])]:
 visits={};records={};late={}
 for log in logs:
  for part in re.split(r'^# \*\*\* IR Dump After ',(root/log).read_text(),flags=re.M)[1:]:
   f=re.search(r'^# Machine code for function ([^:]+):',part,re.M)
   if not f:continue
   blocks=[tuple(map(int,m.groups())) for m in re.finditer(r'^\s*(?:\d+B\s+)?bb\.(\d+).*?bb_id (\d+)',part,re.M)]
   if not blocks:continue
   if part.startswith('CDFGPass'):
    n=visits.get(f[1],0);visits[f[1]]=n+1
    if n==1:records[f[1]]=blocks
   late[f[1]]=blocks
 saved=json.loads((Path('/tmp/isaac-query-pushdown-20261030')/f'graph-{graph}.json').read_text())
 pairs={(v['props']['func_name'],v['props']['basic_block'],v['props']['bb_id']) for v in saved['nodes']}
 lookup={(fn,f'%bb.{n}'):base for fn,bs in records.items() for n,base in bs}
 disagreements=[(f,n,b,lookup.get((f,n))) for f,n,b in pairs if lookup.get((f,n))!=b]
 llvm=pd.read_pickle(Path(run)/'sess/table/llvm_bbs.pkl')
 actual={fn:{int(str(n).split('.')[1]) for n in g.bb_name} for fn,g in llvm.groupby('func_name')}
 changes=[]
 for fn,bs in records.items():
  if fn not in actual:continue
  early={base for n,base in bs}
  created=sorted(actual[fn]-early);removed=sorted(early-actual[fn])
  if created or removed:changes.append(dict(function=fn,late_ids=created,missing_ids=removed))
 result={'saved_cdfg_blocks':len(pairs),'replay_stage32_blocks':sum(map(len,records.values())),'saved_vs_replay_disagreements':disagreements,'stage32_vs_saved_elf_changes':changes,'replay_stage32':records,'replay_final':late}
 results[name]=result
 print(name,'saved CDFG blocks',len(pairs),'disagreements with replay',len(disagreements),'functions with later new/deleted IDs',len(changes))
 print('changes',changes[:12])
(root/'replay-audit.json').write_text(json.dumps(results,indent=2))
