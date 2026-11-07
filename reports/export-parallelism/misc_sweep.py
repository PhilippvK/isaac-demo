import sys,time,json,importlib,random
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from collections import defaultdict
from types import SimpleNamespace as NS
import pandas as pd
sys.path.insert(0,'/tmp/isaac-export-parallel-eval')
from bench import DATA,ROOT
from tool.enums import ExportFormat as E,ExportFilter as F
write_dfs=importlib.import_module('tool.stages.write_dfs').write_dfs
write_sankey=importlib.import_module('tool.stages.write_sankey').write_sankey
rows=[]
jobs=[(case,mode,rep) for case in ('crc','sha') for mode in ('serial','threads2') for rep in range(3)]
random.Random(7).shuffle(jobs)
for case,mode,rep in jobs:
 df=pd.read_pickle(DATA[case]/'subs.pkl'); glob=pd.read_pickle(DATA[case]/'global.pkl')
 out=ROOT/f'misc-{case}-{mode}-{rep}';out.mkdir(exist_ok=True)
 settings=NS(out_dir=out,write=NS(df_flt=F.ALL,df_fmt=E.CSV|E.PKL,sankey_flt=F.ALL,sankey_fmt=E.MARKDOWN))
 artifacts=defaultdict(dict);times={}
 def run(name,fn):
  start=time.perf_counter();fn(settings,df,glob,artifacts) if name=='df' else fn(settings,df,artifacts)
  times[name]=time.perf_counter()-start
 start=time.perf_counter()
 if mode=='serial':run('df',write_dfs);run('sankey',write_sankey)
 else:
  with ThreadPoolExecutor(2) as pool:
   a=pool.submit(run,'df',write_dfs);b=pool.submit(run,'sankey',write_sankey);a.result();b.result()
 elapsed=time.perf_counter()-start
 pd.testing.assert_frame_equal(pd.read_pickle(out/'subs.pkl'),df[(df.Status&int(F.ALL))>0])
 assert set(artifacts[None])=={'subs','sankey'}
 rows.append(dict(case=case,mode=mode,rep=rep,seconds=elapsed,stages=times))
 print(rows[-1],flush=True)
(ROOT/'misc.json').write_text(json.dumps(rows,indent=2))
