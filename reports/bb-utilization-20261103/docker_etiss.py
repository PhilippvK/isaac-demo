#!/usr/bin/env python3
"""Run a generated ETISS build inside its matching service image."""
from pathlib import Path
import os,sys,json,subprocess,uuid
container='isaac-docker-service-worker-etiss-1'
resources=Path(os.environ['ISAAC_UTIL_RESOURCE_DIR'])
job=json.loads((resources/'etiss/job.json').read_text())['job_id']
remote='/tmp/bb-util-'+uuid.uuid4().hex
subprocess.run(['docker','exec',container,'mkdir','-p',remote],check=True)
args=sys.argv[1:];elf=Path(args[0]).resolve()
subprocess.run(['docker','cp',str(elf),container+':'+remote+'/program.elf'],check=True)
args[0]=remote+'/program.elf'
for i,arg in enumerate(args):
 if arg.startswith('-i') and Path(arg[2:]).is_file():
  subprocess.run(['docker','cp',arg[2:],container+':'+remote+'/custom.ini'],check=True)
  args[i]='-i'+remote+'/custom.ini'
run=subprocess.run(['docker','exec','-w',remote,container,'timeout','60s',f'/jobs/{job}/output/etiss_install/bin/run_helper.sh',*args])
if run.returncode==0:
 subprocess.run(['docker','cp',container+':'+remote+'/instr_trace.csv',str(Path.cwd()/'instr_trace.csv')],check=True)
subprocess.run(['docker','exec',container,'rm','-f',remote+'/instr_trace.csv'],check=True)
# Trace is now on the host; avoid a second full copy in the container.
print('ISAAC_CONTAINER_TRACE_DIR='+remote,flush=True)
sys.exit(run.returncode)
