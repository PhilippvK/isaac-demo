from pathlib import Path
import os,subprocess,json
from elftools.elf.elffile import ELFFile
root=Path(__file__).resolve().parent;repo=root.parents[1];tools=root/'compiler/llvm_install/bin'
env=dict(os.environ,LD_LIBRARY_PATH=str(repo/'install/mgclient/lib'))
results=[]
for pred in ('beq','bne','blt','bge','bltu','bgeu'):
 for offset in (-4098,-4096,-2,-1,0,1,2,4094,4096):
  source=f'.text\nfused_{pred} a0,a1,{offset}\n'
  obj=root/'asm-check.o'
  cmd=[str(tools/'llvm-mc'),'-triple=riscv32','-mattr=+m,+xbranch','-filetype=obj','-o',str(obj)]
  result=subprocess.run(cmd,input=source,text=True,env=env,capture_output=True)
  valid=offset%2==0 and -4096<=offset<=4094
  assert (result.returncode==0)==valid,(pred,offset,result.stderr)
  if valid:
   with obj.open('rb') as f:word=int.from_bytes(ELFFile(f).get_section_by_name('.text').data(),'little')
   raw=((word>>31)&1)<<12|((word>>25)&63)<<5|((word>>8)&15)<<1|((word>>7)&1)<<11
   decoded=raw-8192 if raw&4096 else raw
   assert decoded==offset
  results.append(dict(predicate=pred,offset=offset,accepted=result.returncode==0,diagnostic=result.stderr))
# The linker must refuse a direct branch beyond range; compiled far branches
# instead require the already-executed relaxation trampoline.
p=root/'out-of-range.s';p.write_text('.text\n.global _start\n_start:\nfused_beq a0,a1,target\n')
subprocess.run([str(tools/'llvm-mc'),'-triple=riscv32','-mattr=+m,+xbranch','-filetype=obj',str(p),'-o',str(root/'out-of-range.o')],env=env,check=True)
target=root/'out-of-range-target.s';target.write_text('.text\n.space 8192\n.global target\ntarget: ret\n')
subprocess.run([str(tools/'llvm-mc'),'-triple=riscv32','-filetype=obj',str(target),'-o',str(root/'out-of-range-target.o')],env=env,check=True)
r=subprocess.run([str(tools/'ld.lld'),'-m','elf32lriscv',str(root/'out-of-range.o'),str(root/'out-of-range-target.o'),'-o',str(root/'out-of-range.elf')],text=True,env=env,capture_output=True)
assert r.returncode and 'out of range' in r.stderr,r.stderr
(root/'assembler-results.json').write_text(json.dumps({'immediate_cases':results,'out_of_range_relocation_rejected':True,'linker_diagnostic':r.stderr},indent=2)+'\n')
print('54 assembler cases passed; out-of-range branch relocation rejected.')
