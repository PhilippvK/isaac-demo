#!/usr/bin/env python3
"""Rebuild and run the four verified extraction-benchmark/core combinations."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import sys

report = Path(__file__).resolve().parent
root = report.parents[1]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument('--verilator', default=os.environ.get('RTL_SIM_VERILATOR', 'verilator'))
p.add_argument('--compiler', type=Path, default=root/'llvm-project-22/build/bin/clang')
p.add_argument('--output', type=Path, default=report/'reproduced')
a = p.parse_args()
commands = []

def execute(command):
    commands.append(list(map(str,command)))
    subprocess.run(commands[-1], check=True, cwd=root)

for bench in ('crc32','nettle-sha256'):
    export = report/'inputs'/f'{bench}-compile_commands.json'
    old_root = json.loads(export.read_text())[0]['file'].split('/install/')[0]
    firmware = a.output/'firmware'/bench
    execute([sys.executable,root/'scripts/rtl_sim/build_benchmark.py',export,firmware,
             '--gnu',root/'install/gnu_cfu','--compiler',a.compiler,
             '--arch','rv32im_zicsr_zifencei','--abi','ilp32','--isel','dag',
             '--path-map',old_root+'='+str(root)])
    for core,rtl in (
        ('vex', root/'reports/vex-5s-hls-20261107/hls-run/baseline'),
        ('cva5',root/'reports/cva5-reuseio-hls-20261105/hls-run/baseline'),
    ):
        execute([sys.executable,root/'scripts/rtl_sim/run.py','--core',core,'--rtl',rtl,
                 '--firmware',firmware/'benchmark.bin','--output',a.output/core/bench,
                 '--verilator',a.verilator,'--timeout','600'])
a.output.mkdir(parents=True,exist_ok=True)
(a.output/'commands.json').write_text(json.dumps(commands,indent=2)+'\n')
