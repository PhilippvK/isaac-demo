"""Check ported translation units early using the actual configured build flags."""
import shlex, subprocess, sys
from pathlib import Path
root=Path(__file__).resolve().parents[2]
build=root/'llvm-project-22/build'
targets = sys.argv[1:] or [
    'lib/CodeGen/GlobalISel/CMakeFiles/LLVMGlobalISel.dir/CDFGPass.cpp.o',
    'lib/CodeGen/GlobalISel/CMakeFiles/LLVMGlobalISel.dir/GIMatchTableExecutor.cpp.o',
    'lib/CodeGen/GlobalISel/CMakeFiles/LLVMGlobalISel.dir/GlobalISel.cpp.o',
    'lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/TargetPassConfig.cpp.o',
    'lib/CodeGen/CMakeFiles/LLVMCodeGen.dir/ResetMachineFunctionPass.cpp.o',
    'lib/CodeGen/AsmPrinter/CMakeFiles/LLVMAsmPrinter.dir/AsmPrinter.cpp.o',
]
failed=[]
for target in targets:
    commands=subprocess.check_output(['ninja','-C',str(build),'-t','commands',target],text=True)
    args=shlex.split(commands.splitlines()[-1]);out=[];i=0
    while i < len(args):
        if args[i] in ('-o','-MT','-MF'):
            i+=2;continue
        if args[i] in ('-MD','-c'):
            i+=1;continue
        out.append(args[i]);i+=1
    out.append('-fsyntax-only')
    print('CHECK', target, flush=True)
    if subprocess.run(out,cwd=build).returncode:
        failed.append(target)
print('FAILED', failed, flush=True)
raise SystemExit(bool(failed))
