"""Compile the real profiled sources with the recovered retargeted compiler."""
from pathlib import Path
import json,shlex,subprocess,re
from isaac_toolkit.session import Session
root=Path(__file__).resolve().parent
repo=root.parent.parent
session=Session.from_dir(repo/'reports/bb-quality-20261102/runs/crc32/20261102T160334/sess')
commands=next(a.df for a in session.artifacts if a.attrs.get('kind')=='compile_commands')
compiler=root/'crc32/llvm_install/bin/clang'
out=root/'compile-smoke';out.mkdir(exist_ok=True)
results=[]
for row in commands.to_dict('records'):
 if Path(row['file']).name not in ['beebsc.c','crc_32.c']:continue
 for arm in ['baseline','extended']:
  args=shlex.split(row['command']);args[0]=str(compiler)
  cleaned=[];i=0
  while i<len(args):
   if args[i]=='-o':i+=2;continue
   arg=args[i]
   if arg=='-c':arg='-S'
   if arm=='extended' and arg.startswith('-march='):arg+='_xisaac'
   cleaned.append(arg);i+=1
  output=out/(Path(row['file']).stem+'-'+arm+'.s')
  cleaned+=['-o',str(output)]
  process=subprocess.run(cleaned,cwd=row['directory'],capture_output=True,text=True)
  text=output.read_text() if process.returncode==0 else ''
  custom=re.findall(r'^\s+(custom\d+)\s',text,re.M|re.I)
  results.append(dict(source=row['file'],arm=arm,command=cleaned,returncode=process.returncode,stderr=process.stderr,custom_instruction_occurrences=len(custom),custom_instruction_names=sorted(set(custom))))
(root/'compile-smoke.json').write_text(json.dumps(results,indent=2))
print(json.dumps([{k:v for k,v in r.items() if k not in ['command','stderr']} for r in results],indent=2))
assert len(results)==4 and all(r['returncode']==0 for r in results)
assert any(r['custom_instruction_occurrences'] for r in results if r['arm']=='extended')
