"""Keep a standalone copy of the compiler used for SHA256 measurements."""
from pathlib import Path
import shutil,subprocess
root=Path(__file__).resolve().parents[2]
tree=root/'llvm-project-22';dest=root/'reports/llvm-version-ise-20261104/sha256-llvm22/compiler'
dest.mkdir(exist_ok=False);(dest/'bin').mkdir();(dest/'lib').mkdir()
for n in ('clang','llc','ld.lld','llvm-objdump','llvm-readobj'):
 shutil.copy2(tree/'build/bin'/n,dest/'bin'/n)
(dest/'bin/clang++').symlink_to('clang')
shutil.copytree(tree/'build/lib/clang',dest/'lib/clang',symlinks=True)
(dest/'source-head.txt').write_text(subprocess.check_output(['git','-C',str(tree),'rev-parse','HEAD'],text=True))
