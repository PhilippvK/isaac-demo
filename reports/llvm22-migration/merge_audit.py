"""Three-way source merge feasibility, not a compiler/build validation."""
from pathlib import Path
import subprocess,tempfile,json
root=Path(__file__).resolve().parent;repo=root.parent.parent/'llvm-project';rows=[]
paths=subprocess.check_output(['git','-C',str(repo),'diff','--name-only','llvmorg-19.1.7..HEAD'],text=True).splitlines()
for path in paths:
 up=root/'upstream22'/path
 current=subprocess.check_output(['git','-C',str(repo),'show','HEAD:'+path])
 old=subprocess.run(['git','-C',str(repo),'show','llvmorg-19.1.7:'+path],capture_output=True)
 if old.returncode:
  rows.append(dict(path=path,status='new-custom-file',lines=len(current.splitlines())));continue
 if not up.exists():rows.append(dict(path=path,status='upstream-missing'));continue
 with tempfile.TemporaryDirectory() as tmp:
  t=Path(tmp);(t/'base').write_bytes(old.stdout);(t/'custom').write_bytes(current)
  merge=subprocess.run(['git','merge-file','-p','--diff3',str(up),str(t/'base'),str(t/'custom')],capture_output=True)
  out=root/'merge-preview'/path;out.parent.mkdir(parents=True,exist_ok=True);out.write_bytes(merge.stdout)
  rows.append(dict(path=path,status='clean-text-merge' if merge.returncode==0 else 'conflict',conflict_regions=merge.returncode))
(root/'merge-audit.json').write_text(json.dumps(rows,indent=2))
for r in rows:print(r)
