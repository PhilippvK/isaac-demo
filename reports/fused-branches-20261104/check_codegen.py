from pathlib import Path
import subprocess,os,re,json
root=Path(__file__).resolve().parent;repo=root.parents[1];tools=root/'compiler/llvm_install/bin'
env=dict(os.environ,LD_LIBRARY_PATH=str(repo/'install/mgclient/lib'))
base=[str(tools/'clang'),'--target=riscv32','-march=rv32im_xbranch','-mabi=ilp32','-O2','-ffreestanding','-fno-builtin','-S','-emit-llvm','-DFUNC(x)=selected_##x',str(root/'selected.c'),'-o',str(root/'selected.ll')]
subprocess.run(base,env=env,check=True)
subprocess.run([str(tools/'llc'),'-O2','-mtriple=riscv32','-mattr=+m,+xbranch','-global-isel=1','-global-isel-abort=1','-verify-machineinstrs',str(root/'selected.ll'),'-o',str(root/'gisel.s')],env=env,check=True)
assert not re.search(r'\bfused_', (root/'gisel.s').read_text())
assert 'FUSED_' not in (root/'compiler/RISCVGenGlobalISel.inc').read_text()
irs=['target triple = "riscv32"']
for name,cc in [('BEQ','eq'),('BNE','ne'),('BLT','slt'),('BGE','sge'),('BLTU','ult'),('BGEU','uge')]:
 irs += [f'define i32 @far_{name}(i32 %a,i32 %b) {{','entry:', '%v = and i32 %a,%b',f'%c = icmp {cc} i32 %v,7','br i1 %c,label %taken,label %padding, !prof !0','padding:']
 irs += ['call void asm sideeffect "addi zero, zero, 0", ""()']*1100
 irs += ['ret i32 0','taken:','ret i32 1','}']
irs += ['!0 = !{!"branch_weights", i32 1, i32 1000}']
(root/'far.ll').write_text('\n'.join(irs)+'\n')
cmd=[str(tools/'llc'),'-O2','-mtriple=riscv32','-mattr=+m,+xbranch','-verify-machineinstrs',str(root/'far.ll')]
subprocess.run(cmd+['-o',str(root/'far.s')],env=env,check=True)
subprocess.run(cmd+['-filetype=obj','-o',str(root/'far.o')],env=env,check=True)
far=(root/'far.s').read_text();assert len(re.findall(r'\bfused_',far))>=6
(root/'codegen-controls.json').write_text(json.dumps({'gisel_compiles_without_fused_branches':True,'gisel_generated_table_has_no_branch_ise_names':True,'far_functions_compile_and_verify':True,'far_fused_sites':len(re.findall(r'\bfused_',far))},indent=2)+'\n')
print('GI exclusion and far-branch compiler verification passed.')
