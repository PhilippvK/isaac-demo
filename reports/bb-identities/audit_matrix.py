from pathlib import Path
import re,json
root=Path('/tmp/isaac-bbid-investigation')
rows=[]
for log in sorted(root.glob('*-O*.log')):
 name=log.stem;is_gisel=name.startswith('gisel');opt=int(name[-1]);byfn={};snapshots=[]
 for part in re.split(r'^# \*\*\* IR Dump After ',log.read_text(),flags=re.M)[1:]:
  f=re.search(r'^# Machine code for function ([^:]+):',part,re.M)
  if not f:continue
  blocks=[tuple(map(int,m.groups())) for m in re.finditer(r'^\s*(?:\d+B\s+)?bb\.(\d+).*?bb_id (\d+)',part,re.M)]
  if not blocks:continue
  header=part.splitlines()[0]
  snapshots.append(dict(function=f[1],pass_name=header,blocks=blocks))
  if header.startswith('CDFGPass'):byfn.setdefault(f[1],[]).append(blocks)
 maps={}
 for entry in (root/(name+'-map.txt')).read_text().split('  Function {')[1:]:
  fn=re.search(r'Name: (\S+)',entry)[1]
  maps[fn]=list(map(int,re.findall(r'^\s+ID: (\d+)',entry,re.M)))
 for fn,visits in byfn.items():
  stage32=visits[5 if is_gisel else 1]
  early={base for mbb,base in stage32};final=set(maps[fn])
  row=dict(case=name,function=fn,stage32=stage32,stage32_wrong_name=sum(mbb!=base for mbb,base in stage32),final_ids=maps[fn],removed=sorted(early-final),new=sorted(final-early))
  rows.append(row)
  print(name,fn,'stage32',stage32,'finalIDs',maps[fn],'lost',row['removed'],'new',row['new'])
 (root/(name+'-snapshots.json')).write_text(json.dumps(snapshots,indent=2))
(root/'matrix-audit.json').write_text(json.dumps(rows,indent=2))
