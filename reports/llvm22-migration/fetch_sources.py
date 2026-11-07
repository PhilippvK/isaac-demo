"""Fetch only source files needed for a read-only LLVM 22 port assessment."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import subprocess,urllib.request,urllib.error,json,hashlib
root=Path(__file__).resolve().parent;repo=root.parent.parent
changed=subprocess.check_output(['git','-C',str(repo/'llvm-project'),'diff','--name-only','llvmorg-19.1.7..HEAD'],text=True).splitlines()
extra=['llvm/include/llvm/CodeGen/MachineFunction.h','llvm/include/llvm/CodeGen/MachineInstr.h','llvm/include/llvm/CodeGen/MachineRegisterInfo.h','llvm/include/llvm/MC/MCTargetOptions.h','llvm/include/llvm/MC/MCContext.h','llvm/include/llvm/BinaryFormat/ELF.h','llvm/lib/Object/ELF.cpp','llvm/docs/Extensions.rst','llvm/docs/Extensions.md','llvm/lib/Target/RISCV/RISCVTargetMachine.cpp','llvm/lib/Target/RISCV/GISel/RISCVInstructionSelector.cpp','llvm/lib/Target/RISCV/GISel/RISCVLegalizerInfo.cpp','llvm/lib/Target/RISCV/RISCVInstrInfo.cpp','llvm/lib/Target/RISCV/RISCVInstrInfo.td','llvm/lib/Target/RISCV/RISCVLateBranchOpt.cpp','llvm/lib/Target/RISCV/RISCVRedundantCopyElimination.cpp','llvm/lib/Target/RISCV/RISCVCodeGenPassBuilder.h','llvm/include/llvm/CodeGen/TargetPassConfig.h']
paths=sorted(set(p for p in changed if not p.startswith('notes/'))|set(extra))
def fetch(path):
 url='https://raw.githubusercontent.com/llvm/llvm-project/llvmorg-22.1.8/'+path
 try:
  data=urllib.request.urlopen(url,timeout=45).read();dest=root/'upstream22'/path;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
  return dict(path=path,url=url,status=200,bytes=len(data),sha256=hashlib.sha256(data).hexdigest())
 except urllib.error.HTTPError as e:
  if e.code!=404:raise
  return dict(path=path,url=url,status=404)
with ThreadPoolExecutor(max_workers=8) as pool:rows=list(pool.map(fetch,paths))
(root/'upstream-sources.json').write_text(json.dumps(rows,indent=2));print('Fetched',sum(r['status']==200 for r in rows),'files;',sum(r['status']==404 for r in rows),'absent')
