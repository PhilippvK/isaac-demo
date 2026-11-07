from pathlib import Path
import subprocess,json
root=Path('/tmp/isaac-bbid-investigation')
bin=Path('/var/tmp/ga87puy/isaac-demo-new/llvm-project/build/bin')
rows=[]
for selector in ('gisel','dag'):
 for opt in (0,1,2,3):
  name=f'{selector}-O{opt}';flags=['-fglobal-isel','-mllvm','-global-isel-abort=0'] if selector=='gisel' else ['-fno-global-isel']
  cmd=[str(bin/'clang'),'--target=riscv32','-march=rv32im','-mabi=ilp32',f'-O{opt}','-g','-fbasic-block-sections=labels',*flags,'-mllvm','-print-after-all','-c',str(root/'cases.c'),'-o',str(root/(name+'.o'))]
  with (root/(name+'.log')).open('w') as err:subprocess.run(cmd,stderr=err,stdout=subprocess.DEVNULL,check=True)
  subprocess.run([str(bin/'ld.lld'),'-m','elf32lriscv','--unresolved-symbols=ignore-all','-e','choose','-Ttext=0x10000',str(root/(name+'.o')),'-o',str(root/(name+'.elf'))],check=True)
  out=subprocess.check_output([str(bin/'llvm-readobj'),'--bb-addr-map',str(root/(name+'.elf'))],text=True)
  (root/(name+'-map.txt')).write_text(out)
  rows.append({'case':name,'command':cmd});print(name,'compiled and linked',flush=True)
(root/'matrix-commands.json').write_text(json.dumps(rows,indent=2))
