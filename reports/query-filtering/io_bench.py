import ast,copy,json,logging,statistics,time
from types import SimpleNamespace
import pandas as pd
import numpy as np
import networkx as nx
from neo4j import GraphDatabase
from bench import ROOT,query,run,filter_rows,allowed
from tool.settings import Settings
from tool.enums import Variation,ExportFilter
from tool.stages.analyze_io import analyze_io
logging.disable(logging.CRITICAL)
source=ast.parse(open('memgraph_experiments/tool/main.py').read())
fn=next(n for n in source.body if isinstance(n,ast.FunctionDef) and n.name=='init_subs_df')
init_code=compile(ast.Module(body=[fn],type_ignores=[]),'tool.main:init_subs_df','exec')
settings=Settings.get_defaults();settings.progress=False
cases=[('sha_load',0,'_nettle_sha256_compress','%bb.1',None),('sha_mixed',0,'sha256_digest','%bb.6',None),('crc_alloc',1,'malloc_beebs','%bb.1',None),('sha_arith_partition',0,'_nettle_sha256_compress','%bb.5',0)]
results=[]
with GraphDatabase.driver('bolt://127.0.0.1:28763',auth=('', ''),connection_timeout=3) as d:
 for name,idx,func,bb,partition in cases:
  g=dict(json.loads((ROOT/f'graph-{idx}.json').read_text()),partition=partition)
  rows,query_ms,error=run(d,query(g,func,bb,9),{})
  if error:raise RuntimeError(error)
  eligible={n['id'] for n in g['nodes'] if allowed(n['props'],'cfu_local')}
  kept,_=filter_rows(rows,eligible)
  for mode,items in [('late_filter',rows),('pre_filtered',kept)]:
   times=[];errors=[]
   for repeat in range(3):
    gf=nx.MultiDiGraph()
    ids={n['id']:i for i,n in enumerate([n for n in g['nodes'] if n['props']['func_name']==func])}
    for n in g['nodes']:
     if n['id'] in ids:
      gf.add_node(ids[n['id']],label=n['props']['name'],properties=copy.deepcopy(n['props']))
    for e in g['edges']:
     if e['source'] in ids and e['target'] in ids:
      gf.add_edge(ids[e['source']],ids[e['target']],key=e['id'],properties=copy.deepcopy(e['props']))
    subs=[gf.subgraph({ids[n] for path in row for n in path}).copy() for row in items]
    env=dict(pd=pd,np=np,ts='experiment',subs=subs,Variation=Variation,ExportFilter=ExportFilter)
    exec(init_code,env);frame=env['init_subs_df'](settings)
    start=time.perf_counter()
    try:
     ios=analyze_io(settings,gf,subs,frame)
     assert len(ios)==len(items)
     times.append((time.perf_counter()-start)*1000)
    except Exception as e:
     errors.append(type(e).__name__+': '+str(e));break
   result=dict(case=name,mode=mode,rows=len(items),io_ms=statistics.median(times) if times else None,all_ms=times,errors=errors)
   results.append(result);print(json.dumps(result),flush=True)
(ROOT/'io-stage.json').write_text(json.dumps(results,indent=2))
