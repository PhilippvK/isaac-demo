import sys,json,random
from pathlib import Path
sys.path.insert(0,'/tmp/isaac-export-parallel-eval')
from bench import graph
jobs=[(family,case,w,rep,mode) for family in ('sub','io_sub') for case in ('crc','sha') for rep in range(3) for w,mode in [(1,'serial'),(4,'process'),(8,'process'),(16,'process')]]
random.Random(16).shuffle(jobs)
with Path('/tmp/isaac-export-parallel-eval/full-graphs.jsonl').open('w') as f:
 for family,case,w,rep,mode in jobs:
  result=graph(case,'pdfdotpkl',w,rep+10,count=100000,mode=mode,selected_only=True,family=family)
  f.write(json.dumps(result)+'\n');f.flush()
  print(json.dumps(result),flush=True)
