from pathlib import Path
import shutil

root=Path(__file__).resolve().parents[2]
out=Path(__file__).resolve().parent/'compiler/llvm_install'
(out/'bin').mkdir(parents=True,exist_ok=True)
for name in ('clang','llc','ld.lld','llvm-objdump','llvm-readobj','llvm-mc','FileCheck'):
    shutil.copy2(root/'llvm-project-22/build/bin'/name,out/'bin'/name)
shutil.copytree(root/'llvm-project-22/build/lib/clang',out/'lib/clang',dirs_exist_ok=True)
shutil.copy2(root/'llvm-project-22/build/lib/Target/RISCV/RISCVGenGlobalISel.inc',out.parent/'RISCVGenGlobalISel.inc')
