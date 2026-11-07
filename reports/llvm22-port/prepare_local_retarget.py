"""Reuse the completed baseline source/build tree for a normal Seal5 run.

Seal5 manages its own patch commits in this disposable LLVM22 checkout.
The main repository and the existing LLVM19 checkout are not modified here.
"""
from pathlib import Path
import os, shutil, subprocess, sys
root=Path(__file__).resolve().parents[2]
tree=root/'llvm-project-22'
patch=root/'cfg/seal5/llvm22-isaac.patch'
# Remove exactly our saved patch so Seal5 can apply and track it at stage0.
subprocess.run(['git','-C',str(tree),'apply','--reverse','--check',str(patch)],check=True)
subprocess.run(['git','-C',str(tree),'apply','--reverse',str(patch)],check=True)
assert not subprocess.check_output(['git','-C',str(tree),'status','--porcelain'],text=True).strip()
env=dict(os.environ, PYTHONPATH=str(root/'seal5')+':'+str(root/'M2-ISA-R-new'),
         SEAL5_HOME=str(tree))
subprocess.run([sys.executable,'-m','seal5.cli.main','--dir',str(tree),'init','--non-interactive',
                '--clone','--clone-url','https://github.com/llvm/llvm-project.git',
                '--clone-ref','llvmorg-22.1.8','--clone-depth','1','--force'],env=env,check=True)
link=tree/'.seal5/build/release'
assert not link.exists()
link.symlink_to('../../build',target_is_directory=True)
cached=root/'reports/llvm22-port/patterngen-source'
if cached.exists():
    shutil.move(str(cached),str(tree/'.seal5/deps/cdsl2llvm'))
print('Prepared local Seal5 state; build directory reused:',link.resolve())
