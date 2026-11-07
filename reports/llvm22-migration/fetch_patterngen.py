from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import json,urllib.request,hashlib
root=Path(__file__).resolve().parent
repo='PhilippvK/CoreDSL2LLVM'
def get(url):
 req=urllib.request.Request(url,headers={'User-Agent':'ISAAC-migration-assessment'})
 return urllib.request.urlopen(req,timeout=45).read()
commit=json.loads(get(f'https://api.github.com/repos/{repo}/commits/llvm-22.1.8'))['sha']
paths=['llvm/lib/Target/RISCV/'+p for p in ['GISel/RISCVInstructionSelector.cpp','RISCVInstrInfo.cpp','RISCVLateBranchOpt.cpp','RISCVRedundantCopyElimination.cpp','GISel/RISCVLegalizerInfo.cpp','RISCVInstrInfo.td']]
paths+=['llvm/lib/CodeGen/GlobalISel/PatternGen.cpp','llvm/include/llvm/CodeGen/GlobalISel/PatternGen.h']
def fetch(path):
 url=f'https://raw.githubusercontent.com/{repo}/{commit}/{path}';data=get(url);dest=root/'patterngen22'/path;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data);return dict(path=path,url=url,sha256=hashlib.sha256(data).hexdigest(),bytes=len(data))
with ThreadPoolExecutor(max_workers=8) as p:rows=list(p.map(fetch,paths))
(root/'patterngen-sources.json').write_text(json.dumps(dict(repository=repo,branch='llvm-22.1.8',commit=commit,files=rows),indent=2));print(commit,len(rows))
