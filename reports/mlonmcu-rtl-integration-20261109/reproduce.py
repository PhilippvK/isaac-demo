#!/usr/bin/env python3
"""Run native MLonMCU workloads on generated Vex and/or CVA5 RTL."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

root=Path(__file__).resolve().parents[2]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--core',choices=['vex','cva5'],default='vex')
p.add_argument('--verilator',default=os.environ.get('RTL_SIM_VERILATOR','verilator'))
p.add_argument('--workloads',nargs='+',default=['crc32','nettle-sha256','hello_world'])
a=p.parse_args()
rtl=root/'reports'/('vex-5s-hls-20261107/hls-run/baseline' if a.core=='vex' else 'cva5-reuseio-hls-20261105/hls-run/baseline')
env=dict(os.environ);env['PYTHONPATH']=str(root/'mlonmcu')+os.pathsep+env.get('PYTHONPATH','')
commands=[]
for name in a.workloads:
 command=[sys.executable,'-m','mlonmcu.cli.main','flow','run',name,'--backend','none','--target','nailgun',
          '-c','mlif.toolchain=llvm','-c','mlif.global_isel=1','-c','mlif.unroll_loops=0',
          '-c',f'llvm.install_dir={root}/llvm-project-22/build','-c','run.export_optional=1',
          '-c',f'riscv_gcc_rv32.install_dir={root}/install/gnu_cfu','-c','riscv_gcc_rv32.name=riscv32-unknown-elf',
          '-c',f'nailgun.runner={root}/scripts/rtl_sim/run.py','-c',f'nailgun.rtl_dir={rtl}',
          '-c',f'nailgun.core={a.core}','-c',f'nailgun.verilator={a.verilator}']
 commands.append(command);subprocess.run(command,check=True,cwd=root,env=env)
print(json.dumps(commands,indent=2))
