"""Inspect actual LLVM22 CDFG observation stages without connecting to a DB."""
from pathlib import Path
import json, os, re, subprocess
root=Path(__file__).resolve().parent
repo=root.parents[1]
source=root/'pipeline-cases.c'
source.write_text((repo/'reports/bb-identities/cases.c').read_text())
env=dict(os.environ, LD_LIBRARY_PATH=str(repo/'install/mgclient/lib'))
results=[]
for mode in ('dag','gisel'):
    command=[str(repo/'llvm-project-22/build/bin/clang'),'--target=riscv32','-march=rv32im','-mabi=ilp32',
             '-O2','-g','-fbasic-block-sections=labels','-mllvm','-debug-only=bbid-trace']
    if mode=='gisel':
        command += ['-fglobal-isel','-mllvm','-global-isel-abort=1']
    command += ['-c',str(source),'-o',str(root/f'pipeline-{mode}.o')]
    result=subprocess.run(command,env=env,text=True,capture_output=True)
    (root/f'pipeline-{mode}.log').write_text(result.stdout+result.stderr)
    assert result.returncode==0, result.stderr
    stages=sorted({int(s) for s in re.findall(r'event=cdfg-stage.*? stage=(\d+)',result.stderr)})
    expected=[16,32,64,128,256] if mode=='dag' else [1,2,4,8,16,32,64,128,256]
    assert stages==expected,(mode,stages)
    assert not re.search(r'event=cdfg-stage.*? base=none',result.stderr), mode
    assert not re.search(r'event=cdfg-stage.*? clone=[1-9]',result.stderr), mode
    results.append(dict(mode=mode,stages=stages,command=command))
(root/'pipeline-results.json').write_text(json.dumps(results,indent=2))
print(json.dumps(results,indent=2))
