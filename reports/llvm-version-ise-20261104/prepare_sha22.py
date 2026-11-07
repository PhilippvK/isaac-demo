"""Preserve CRC32 tools/state and reuse the disposable LLVM22 build for SHA256."""
from pathlib import Path
import subprocess,tarfile,shutil,json
import yaml
root=Path(__file__).resolve().parents[2];out=root/'reports/llvm-version-ise-20261104';tree=root/'llvm-project-22'
assert not subprocess.check_output(['git','-C',str(tree),'status','--porcelain'],text=True).strip()
save=out/'crc32-llvm22';save.mkdir(exist_ok=False)
head=subprocess.check_output(['git','-C',str(tree),'rev-parse','HEAD'],text=True).strip()
(save/'source-head.txt').write_text(head+'\n')
with tarfile.open(save/'seal5-state.tar.gz','w:gz') as tar:
 for p in (tree/'.seal5').iterdir():
  if p.name not in ('build','deps'):tar.add(p,arcname=p.name)
(save/'bin').mkdir()
for n in ('clang','llc','ld.lld','llvm-objdump','llvm-readobj'):
 shutil.copy2(tree/'build/bin'/n,save/'bin'/n)
(save/'lib').mkdir();shutil.copytree(tree/'build/lib/clang',save/'lib/clang',symlinks=True)
(save/'bin/clang++').symlink_to('clang')
# The branch retains the complete CRC32 source; a separate branch starts at
# the completed common stage0 before any workload-specific definitions.
subprocess.run(['git','-C',str(tree),'switch','-c','experiment-sha256-llvm22','646fe13e'],check=True)
settings=tree/'.seal5/settings.yml'
s=yaml.safe_load(settings.read_text())
# Keep the common compiler configuration and completed stage0 patches only.
s['patches']=[]  # Common stage0 is already present in the source.
s['metrics']=[]
s['inputs']=[]
s['test']['paths']=[]
settings.write_text(yaml.safe_dump(s,sort_keys=False))
for name in ('inputs','models','patches','temp','gen','cache'):
 p=tree/'.seal5'/name
 # Retain old files in the durable state archive, then start empty for SHA256.
 for q in p.iterdir():
  if q.is_dir():shutil.rmtree(q)
  else:q.unlink()
print('CRC32 compiler and Seal5 state preserved at',save)
