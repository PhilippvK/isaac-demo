import sys,subprocess,json,random
from pathlib import Path
root=Path('/tmp/isaac-export-parallel-eval')
jobs=[(case,method,rep) for case in ('crc','sha') for method in ('serial','batch','process2') for rep in range(3)]
random.Random(24).shuffle(jobs)
with (root/'charts.jsonl').open('w') as out:
 for case,method,rep in jobs:
  cmd=[sys.executable,str(root/'bench.py'),'chart',case,method,str(rep)]
  p=subprocess.run(cmd,text=True,capture_output=True,timeout=65)
  if p.returncode:raise RuntimeError(p.stderr[-2000:])
  result=json.loads(p.stdout.strip().splitlines()[-1]);out.write(json.dumps(result)+'\n');out.flush()
  print(json.dumps(result),flush=True)
