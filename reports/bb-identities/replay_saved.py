from pathlib import Path
import subprocess,shlex,os,json
import pandas as pd
root=Path('/tmp/isaac-bbid-investigation')
results=[]
for name,run in [('sha','out/embench_iot/nettle-sha256/20261021T203457'),('crc','out/embench_iot/crc32/20261021T203031')]:
 tables=Path(run)/'sess/table';cmds=pd.read_pickle(tables/'compile_commands.json.pkl');choices=pd.read_pickle(tables/'choices.pkl')
 filenames={Path(s).name for s in choices.file if isinstance(s,(str,Path))}
 for _,row in cmds.iterrows():
  if Path(row.file).name not in filenames:continue
  tag=f'{name}-{Path(row.file).stem}'
  args=shlex.split(row.command);out=args.index('-o')+1;args[out]=str(root/f'replay-{tag}.o')
  args+=['-mllvm','-print-after-all']
  env=os.environ.copy();env['LD_LIBRARY_PATH']=str(Path('install/mgclient/lib').resolve())+':'+env.get('LD_LIBRARY_PATH','')
  with (root/f'replay-{tag}.log').open('w') as f:
   subprocess.run(args,env=env,stdout=subprocess.DEVNULL,stderr=f,check=True)
  results.append({'case':name,'original_cwd':row.directory,'replay_cwd':str(Path.cwd()),'command':args})
  print(name,Path(row.file).name,'replayed',flush=True)
(root/'replay-commands.json').write_text(json.dumps(results,indent=2))
