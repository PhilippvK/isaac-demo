import re,json
from pathlib import Path
root=Path('/tmp/isaac-bbid-investigation')
text=(root/'passes.log').read_text()
snapshots=[]
for part in re.split(r'^# \*\*\* IR Dump After ',text,flags=re.M)[1:]:
 header=part.splitlines()[0]
 fn=re.search(r'^# Machine code for function ([^:]+):',part,re.M)
 if not fn:continue
 blocks=[]
 for line in part.splitlines():
  match=re.search(r'^\s*(?:\d+B\s+)?bb\.(\d+).*?bb_id (\d+)',line)
  if match:blocks.append(tuple(map(int,match.groups())))
 if blocks:snapshots.append({'function':fn[1],'pass':header,'blocks':blocks})
(root/'snapshots.json').write_text(json.dumps(snapshots,indent=2))
for fn in sorted(set(x['function'] for x in snapshots)):
 rows=[x for x in snapshots if x['function']==fn]
 print('\nFUNCTION',fn)
 stage=0
 for row in rows:
  if row['pass'].startswith('CDFGPass'):
   print(' CDFG visit',stage,'stage bit',[1,2,4,8,16,32,128,256,64][stage],'(MBB,BaseID)',row['blocks']);stage+=1
 prev=None
 for row in rows:
  if row['blocks']!=prev:
   print(' CHANGE AFTER',row['pass'],'mapping',row['blocks']);prev=row['blocks']
