"""Validate source-derived legalizer splits against actual release sources."""
from pathlib import Path
import urllib.request, json, hashlib
from seal5.tools.cdsl2llvm import split_minmax_legalizer_actions
root=Path(__file__).resolve().parent
rows=[]
for major,version in [(19,'19.1.7'),(20,'20.1.8'),(21,'21.1.8'),(22,'22.1.8')]:
    url=f'https://raw.githubusercontent.com/llvm/llvm-project/llvmorg-{version}/llvm/lib/Target/RISCV/GISel/RISCVLegalizerInfo.cpp'
    source=urllib.request.urlopen(url,timeout=60).read()
    (root/f'legalizer-llvm{major}.cpp').write_bytes(source)
    text=source.decode()
    updated=split_minmax_legalizer_actions(text)
    assert updated.count('getActionDefinitionsBuilder(Opcode)')>=1
    assert updated.count('for (unsigned Opcode : {G_UMAX, G_UMIN, G_SMAX, G_SMIN})')==1
    rows.append(dict(major=major,url=url,sha256=hashlib.sha256(source).hexdigest()))
    print(major,'PASS',flush=True)
(root/'legalizer-source-versions.json').write_text(json.dumps(rows,indent=2))
