import sys,json,random
from pathlib import Path
sys.path.insert(0,'/tmp/isaac-export-parallel-eval')
from bench import graph
jobs=[(case,fmt,w,rep,mode) for case in ('crc','sha') for fmt in ('pkl','dotpkl','pdfdotpkl') for rep in range(3) for w,mode in [(1,'serial'),(1,'process'),(2,'process'),(4,'process'),(8,'process'),(16,'process')]]
random.Random(42).shuffle(jobs)
with Path('/tmp/isaac-export-parallel-eval/graphs.jsonl').open('w') as f:
 for case,fmt,w,rep,mode in jobs:
  result=graph(case,fmt,w,rep,mode=mode)
  f.write(json.dumps(result)+'\n');f.flush()
print('Completed',len(jobs),'graph benchmark runs',flush=True)
