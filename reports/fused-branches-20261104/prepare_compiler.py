from pathlib import Path
import subprocess,tarfile,shutil,yaml
root=Path(__file__).resolve().parents[2];out=root/'reports/fused-branches-20261104';tree=root/'llvm-project-22'
assert not subprocess.check_output(['git','-C',str(tree),'status','--porcelain'],text=True).strip()
(out/'previous-source-head.txt').write_text(subprocess.check_output(['git','-C',str(tree),'rev-parse','HEAD'],text=True))
with tarfile.open(out/'previous-seal5-state.tar.gz','w:gz') as tar:
 for p in (tree/'.seal5').iterdir():
  if p.name not in ('build','deps'):tar.add(p,arcname=p.name)
subprocess.run(['git','-C',str(tree),'switch','-c','experiment-fused-branches-llvm22','646fe13e'],check=True)
p=tree/'.seal5/settings.yml';s=yaml.safe_load(p.read_text());s.update(patches=[],metrics=[],inputs=[],models={});s['test']['paths']=[];p.write_text(yaml.safe_dump(s,sort_keys=False))
for d in ('inputs','models','patches','temp','gen','cache'):
 for p in (tree/'.seal5'/d).iterdir():
  if p.is_dir():shutil.rmtree(p)
  else:p.unlink()
