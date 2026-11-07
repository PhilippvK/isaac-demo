"""Compare old/new decoder on identical ELFs against llvm-readobj ranges."""
from pathlib import Path
import json,re,subprocess,types,time
from isaac_toolkit.analysis.static.llvm_bbs import parse_elf
root=Path(__file__).resolve().parent
repo=root.parent.parent
old=types.ModuleType('old_decoder')
exec(subprocess.check_output(['git','-C',str(repo/'isaac-toolkit'),'show','HEAD:isaac_toolkit/analysis/static/llvm_bbs.py'],text=True),old.__dict__)
fixtures=root/'decoder-fixtures';fixtures.mkdir(exist_ok=True)
source=fixtures/'cases.c';source.write_text((repo/'reports/bb-identities/cases.c').read_text())
files=[];commands=[]
for selector,opt,aligned in [(selector,opt,False) for selector in ('dag','gisel') for opt in range(4)]+[('gisel',2,True)]:
 name='aligned' if aligned else f'{selector}-O{opt}'
 obj=fixtures/(name+'.o');elf=fixtures/(name+'.elf')
 flags=['-fglobal-isel','-mllvm','-global-isel-abort=0'] if selector=='gisel' else ['-fno-global-isel']
 if aligned:flags+=['-mllvm','-align-all-blocks=4']
 command=[str(repo/'llvm-project/build/bin/clang'),'--target=riscv32','-march=rv32im','-mabi=ilp32',f'-O{opt}','-g','-fbasic-block-sections=labels',*flags,'-c',str(source),'-o',str(obj)]
 subprocess.run(command,check=True);commands.append(command)
 command=[str(repo/'llvm-project/build/bin/ld.lld'),'-m','elf32lriscv','--unresolved-symbols=ignore-all','-e','choose','-Ttext=0x10000',str(obj),'-o',str(elf)]
 subprocess.run(command,check=True);commands.append(command);files.append(elf)
(root/'decoder-commands.json').write_text(json.dumps(commands,indent=2))
files+=list((repo/'out/embench_iot').glob('**/sess/elf/*'))
files+=list((root/'runs').glob('**/sess/elf/*'))
rows=[]
for path in files:
 text=subprocess.check_output([str(repo/'llvm-project/build/bin/llvm-readobj'),'--bb-addr-map',str(path)],text=True)
 oracle={}
 for fn in text.split('  Function {')[1:]:
  name=re.search(r'Name: (\S+)',fn)
  if not name:continue
  base=int(re.search(r'At: (0x[0-9A-Fa-f]+)',fn)[1],16)
  oracle[name[1]]={i:(base+int(o,16),base+int(o,16)+int(s,16),int(s,16)) for i,o,s in re.findall(r'ID: (\d+)\s+Offset: (0x[0-9A-Fa-f]+)\s+Size: (0x[0-9A-Fa-f]+)',fn)}
 row=dict(elf=str(path),blocks=sum(map(len,oracle.values())))
 for arm,fn in [('old',old.parse_elf),('new',parse_elf)]:
  start=time.perf_counter()
  try:
   parsed=fn(path)
   errors=[(f,i) for f,bs in oracle.items() for i,v in bs.items() if tuple(parsed.get(f,{}).get(i,())[:3])!=v]
   row[arm]=dict(ok=not errors,wrong_ranges=len(errors),decoded_blocks=sum(map(len,parsed.values())))
  except Exception as e:row[arm]=dict(ok=False,error=type(e).__name__+': '+str(e))
  row[arm]['seconds']=time.perf_counter()-start
 rows.append(row)
 print(path, row['old'],row['new'],flush=True)
(root/'decoder-results.json').write_text(json.dumps(rows,indent=2))
assert all(r['new']['ok'] for r in rows)
