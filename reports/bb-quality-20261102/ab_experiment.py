"""A/B Toolkit HEAD versus working-tree BB mapping on identical fresh sessions.
Current compiler, database snapshot and memgraph_experiments are held constant.
Only endpoint forwarding is added to the legacy subprocess for isolation.
"""
from pathlib import Path
import json,os,subprocess,types,time,traceback
from isaac_toolkit.session import Session
from isaac_toolkit.generate.ise.query_candidates_from_db import query_candidates_from_db
from isaac_toolkit.backend.memgraph.annotate_bb_weights import annotate_bb_weights
from isaac_toolkit.analysis.static.llvm_bbs import parse_elf
import yaml
root=Path(__file__).resolve().parent;repo=root.parent.parent
os.environ.update(MEMGRAPH_HOST='127.0.0.1',MEMGRAPH_PORT='28763')
def legacy(path):
 m=types.ModuleType('legacy_'+Path(path).stem)
 exec(subprocess.check_output(['git','-C',str(repo/'isaac-toolkit'),'show','HEAD:'+path],text=True),m.__dict__)
 return m
old_query=legacy('isaac_toolkit/generate/ise/query_candidates_from_db.py')
old_annotation=legacy('isaac_toolkit/backend/memgraph/annotate_bb_weights.py')
old_decoder=legacy('isaac_toolkit/analysis/static/llvm_bbs.py')
run_original=subprocess.run
def isolated_run(args,*a,**kw):
 if isinstance(args,list) and 'tool.main' in args and '--host' not in args:
  args=args+['--host','127.0.0.1','--port','28763']
 return run_original(args,*a,**kw)
subprocess.run=isolated_run
results=[]
for bench in ['crc32','nettle-sha256']:
 run=sorted(p for p in (root/'runs'/bench).iterdir() if (p/'sess').exists())[-1]
 label=f'isaac-demo-{bench}-{run.name}'
 for arm in ['old','new']:
  sess=Session.from_dir(run/'sess');work=run/('work-'+arm);work.mkdir(exist_ok=True)
  row=dict(benchmark=bench,arm=arm,stage=32,limit_results=1000,max_path_length=3,max_path_width=2,query_timeout=30,mismatch_action='warn')
  start=time.perf_counter()
  try:
   elf=next(a.path for a in sess.artifacts if a.name in ['generic_mlonmcu','firmware.elf'])
   row['decoder_equal']=old_decoder.parse_elf(elf)==parse_elf(elf)
   (old_annotation.annotate_bb_weights if arm=='old' else annotate_bb_weights)(sess,label=label,force=True,mismatch_action='warn')
   fn=old_query.query_candidates_from_db if arm=='old' else query_candidates_from_db
   fn(sess,label=label,stage=32,workdir=work,force=True,query_config_yaml=str(repo/'cfg/isaac/query/paper/iss_only.yml'),limit_results=1000,MAX_PATH_LENGTH=3,MAX_PATH_WIDTH=2,min_iso_weight=.05,query_timeout=30,partition_with_maxmiso='auto',**({'n_parallel':2} if arm=='new' else {}))
   index=yaml.safe_load((work/'combined_index.yml').read_text())
   candidates=index.get('candidates',[])
   row.update(ok=True,selected_candidates=len(candidates),candidates=[{k:c['properties'].get(k) for k in ['InstrName','#Instrs','Freq','Weight','IsoWeight','#Isos','#IsosNO']} for c in candidates])
  except Exception as exc:
   traceback.print_exc();row.update(ok=False,error=type(exc).__name__+': '+str(exc))
  row['wall_seconds']=time.perf_counter()-start;results.append(row)
  (root/'ab-results.json').write_text(json.dumps(results,indent=2,default=str))
  print('AB_RESULT',json.dumps({k:v for k,v in row.items() if k!='candidates'}),flush=True)
