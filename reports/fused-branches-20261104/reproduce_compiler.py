"""Repeat normal generation from the common stage0, preserving the repaired run."""
from pathlib import Path
import subprocess,tarfile,shutil,yaml
repo=Path(__file__).resolve().parents[2];out=repo/'reports/fused-branches-20261104';tree=repo/'llvm-project-22'
diff=subprocess.check_output(['git','-C',str(tree),'diff','--binary'])
(out/'first-build-generated-fixes.patch').write_bytes(diff)
if diff:
 subprocess.run(['git','-C',str(tree),'apply','--reverse','--check','-'],input=diff,check=True)
 subprocess.run(['git','-C',str(tree),'apply','--reverse','-'],input=diff,check=True)
assert not subprocess.check_output(['git','-C',str(tree),'status','--porcelain'],text=True).strip()
with tarfile.open(out/'first-build-seal5-state.tar.gz','w:gz') as tar:
 for p in (tree/'.seal5').iterdir():
  if p.name not in ('deps','build'):tar.add(p,arcname=p.name)
subprocess.run(['git','-C',str(tree),'switch','-c','experiment-fused-branches-reproduction-llvm22','646fe13e'],check=True)
p=tree/'.seal5/settings.yml';s=yaml.safe_load(p.read_text());s.update(patches=[],metrics=[],inputs=[],models={});s['test']['paths']=[];p.write_text(yaml.safe_dump(s,sort_keys=False))
for d in ('inputs','models','patches','temp','gen','cache'):
 for p in (tree/'.seal5'/d).iterdir():
  if p.is_dir():shutil.rmtree(p)
  else:p.unlink()
