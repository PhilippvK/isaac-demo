from pathlib import Path
import re,urllib.request,json
from concurrent.futures import ThreadPoolExecutor
root=Path(__file__).resolve().parent;repo=root.parent.parent
code=(repo/'llvm-project/llvm/lib/CodeGen/GlobalISel/CDFGPass.cpp').read_text()
paths=[f'llvm/include/{p}' for p in re.findall(r'#include [<"](llvm/[^">]+)[">]',code)]
paths+=['llvm/include/llvm/CodeGen/TargetRegisterInfo.h','llvm/include/llvm/CodeGen/MachineFunctionPass.h','llvm/include/llvm/Support/UniqueBBID.h','llvm/lib/MC/MCContext.cpp']
def fetch(path):
 dest=root/'upstream22'/path
 if dest.exists():return dict(path=path,status='cached')
 try:
  data=urllib.request.urlopen('https://raw.githubusercontent.com/llvm/llvm-project/llvmorg-22.1.8/'+path,timeout=45).read();dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data);return dict(path=path,status=200)
 except urllib.error.HTTPError as e:
  if e.code!=404:raise
  return dict(path=path,status=404)
with ThreadPoolExecutor(max_workers=8) as p:rows=list(p.map(fetch,sorted(set(paths))))
(root/'header-audit.json').write_text(json.dumps(rows,indent=2));print(json.dumps([r for r in rows if r['status']==404],indent=2));print(len(rows),'direct includes audited')
