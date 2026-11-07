"""Compile the real CRC32 body with the same flags and same 32-ISE set."""
from pathlib import Path
from collections import Counter
import hashlib, json, os, re, shlex, subprocess
root=Path(__file__).resolve().parent
repo=root.parents[1]
commands=json.loads((repo/'reports/bb-utilization-20261103/runs/crc32/new/compile_commands.json').read_text())
row=next(row for row in commands if row['file'].endswith('/crc32/crc_32.c'))
results=[]
for major,tools in [(19,repo/'reports/bb-utilization-20261103/llvm/llvm_install/bin'),
                    (22,repo/'llvm-project-22/build/bin')]:
    dest=root/'crc32-codegen'/str(major)
    dest.mkdir(parents=True,exist_ok=True)
    obj=dest/'crc32.o'
    args=shlex.split(row['command'])
    args[0]=str(tools/'clang')
    args[args.index('-o')+1]=str(obj)
    env=dict(os.environ,LD_LIBRARY_PATH=str(repo/'install/mgclient/lib'))
    result=subprocess.run(args,cwd=dest,env=env,text=True,capture_output=True)
    (dest/'compile.log').write_text(result.stdout+result.stderr)
    assert result.returncode==0, result.stderr
    dump=subprocess.check_output([str(tools/'llvm-objdump'),'-d','--mattr=+xisaac',str(obj)],env=env,text=True)
    (dest/'decoded.dump').write_text(dump)
    counts=Counter(re.findall(r'\b(custom\d+)\b',dump))
    assert counts, f'No ISEs selected by LLVM{major}'
    results.append(dict(major=major,command=args,source_sha256=hashlib.sha256(Path(row['file']).read_bytes()).hexdigest(),
                        emitted_custom_sites=sum(counts.values()),per_ise_static=dict(sorted(counts.items()))))
(root/'crc32-codegen-results.json').write_text(json.dumps(results,indent=2))
print(json.dumps(results,indent=2))
