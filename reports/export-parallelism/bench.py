import os, sys, time, json, pickle, copy, importlib, statistics
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor
from types import SimpleNamespace as NS
import pandas as pd
import plotly.io as pio
from tool.enums import ExportFormat as E, ExportFilter as F
from tool.pie import generate_pie_chart, generate_pie2_chart
from tool.settings import Settings
BASE=Path('/var/tmp/ga87puy/isaac-demo-new')
ROOT=Path('/tmp/isaac-export-parallel-eval')
DATA={
 'crc':BASE/'out/embench_iot/crc32/20261022T132649/work/benchmark_body_%bb.3_0',
 'sha':BASE/'out/embench_iot/nettle-sha256/20261021T091416/work/_nettle_sha256_compress_%bb.5_0',
}
def chart_task(args):
 fig,paths=args
 for p in paths:fig.write_image(p)

def chart(case,method,rep):
 df=pd.read_pickle(DATA[case]/'subs.pkl');df=df[(df.Status & int(F.ALL))>0].copy()
 out=ROOT/f'chart-{case}-{method}-{rep}';out.mkdir(exist_ok=True)
 start=time.perf_counter()
 _,a=generate_pie_chart(df);_,b=generate_pie2_chart(df)
 figs=[a,b,a,b];paths=[out/'pie.pdf',out/'pie2.pdf',out/'pie.png',out/'pie2.png']
 if method=='serial':
  for f,p in zip(figs,paths):f.write_image(p)
 elif method=='batch':pio.write_images(fig=figs,file=paths)
 elif method=='process2':
  import multiprocessing as mp
  with ProcessPoolExecutor(2,mp_context=mp.get_context('spawn')) as pool:
   list(pool.map(chart_task,[(a,[paths[0],paths[2]]),(b,[paths[1],paths[3]])]))
 else:raise ValueError(method)
 elapsed=time.perf_counter()-start
 for p in paths:assert p.stat().st_size>100
 return {'kind':'chart','case':case,'method':method,'rep':rep,'seconds':elapsed,'files':len(paths)}

def graph(case,fmt,workers,rep,count=48,mode='process',selected_only=False,family='sub'):
 module=importlib.import_module('tool.stages.write_io_subs' if family=='io_sub' else 'tool.stages.write_subs')
 paths=sorted(DATA[case].glob(f'{family}[0-9]*.pkl'))
 if selected_only:
  df=pd.read_pickle(DATA[case]/'subs.pkl')
  selected=set(df.index[(df.Status & int(F.SELECTED))>0])
  paths=[p for p in paths if int(p.stem[len(family):]) in selected]
 paths=paths[:count]
 graphs=[pickle.loads(p.read_bytes()) for p in paths]
 out=ROOT/f'graph-{family}-{case}-{fmt}-{mode}{workers}-{rep}';out.mkdir(exist_ok=True)
 formats={'pkl':E.PKL,'dotpkl':E.DOT|E.PKL,'pdfdotpkl':E.PDF|E.DOT|E.PKL}
 settings=NS(out_dir=out,write=NS(sub=NS(fmt=formats[fmt]),io_sub_fmt=formats[fmt]))
 start=time.perf_counter()
 if mode=='serial':res=[module.worker(i,g,settings) for i,g in enumerate(graphs)]
 else:
  with ProcessPoolExecutor(workers) as pool:
   res=list(pool.map(module.worker,range(len(graphs)),graphs,[settings]*len(graphs)))
 elapsed=time.perf_counter()-start
 for i,g in enumerate(graphs):
  stored=pickle.loads((out/f'{family}{i}.pkl').read_bytes())
  assert dict(stored.nodes(data=True))==dict(g.nodes(data=True))
  assert list(stored.edges(data=True,keys=True))==list(g.edges(data=True,keys=True))
 for ext,flag in [('dot',E.DOT),('pdf',E.PDF)]:
  if formats[fmt]&flag:
   assert len(list(out.glob('*.'+ext)))==len(graphs)
 return {'kind':'graph','case':case,'method':mode,'format':fmt,'workers':workers,'rep':rep,'n':len(graphs),'seconds':elapsed,'selected_only':selected_only,'family':family}

if __name__=='__main__':
 kind=sys.argv[1]
 if kind=='chart': result=chart(sys.argv[2],sys.argv[3],int(sys.argv[4]))
 elif kind=='graph':result=graph(sys.argv[2],sys.argv[3],int(sys.argv[4]),int(sys.argv[5]),mode=sys.argv[6])
 print(json.dumps(result),flush=True)
