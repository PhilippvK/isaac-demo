import importlib.util
import json
import os
from pathlib import Path
import subprocess

import pandas as pd
import pytest

ROOT=Path(__file__).resolve().parents[1]


def policy(tmp_path, phase='eval', **settings):
    env={k:v for k,v in os.environ.items() if k not in ('GLOBAL_ISEL','ISAAC_ISEL','ISEL_VARIANT')}
    env.update(settings)
    return subprocess.run(['bash','-c',
        'source "$1"; isaac_select_isel "$2" "$3" || exit $?; '
        'printf "%s,%s,%s\\n" "$GLOBAL_ISEL" "$ISAAC_SELECTED_ISEL" "$EVAL_SUFFIX"',
        'test',str(ROOT/'scripts/isel_config.sh'),str(tmp_path),phase],env=env,text=True,capture_output=True)


def test_default_dag(tmp_path):
    assert policy(tmp_path).stdout.strip()=='0,dag,'


def test_eval_inherits_trace(tmp_path):
    (tmp_path/'run').mkdir()
    (tmp_path/'run/instruction-selector.json').write_text('{"global_isel":true}')
    assert policy(tmp_path).stdout.strip()=='1,gisel,'
    assert policy(tmp_path,GLOBAL_ISEL='0').stdout.strip()=='0,dag,'
    assert policy(tmp_path,ISAAC_ISEL='dag').stdout.strip()=='0,dag,'
    assert policy(tmp_path,phase='trace').stdout.strip()=='0,dag,'


@pytest.mark.parametrize('settings',[
    {'GLOBAL_ISEL':'2'},{'ISAAC_ISEL':'oops'},
    {'GLOBAL_ISEL':'0','ISAAC_ISEL':'gisel'},{'ISEL_VARIANT':'../bad'}])
def test_invalid_policy(tmp_path,settings):
    assert policy(tmp_path,**settings).returncode!=0


def test_variant_is_separate(tmp_path):
    assert policy(tmp_path,ISAAC_ISEL='gisel',ISEL_VARIANT='gisel').stdout.strip()=='1,gisel,_isel_gisel'


def test_summary_does_not_double_count_aggregate(tmp_path):
    spec=importlib.util.spec_from_file_location('compare_isel_results',ROOT/'scripts/compare_isel_results.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    table=tmp_path/'table';table.mkdir()
    pd.DataFrame({'instr':[None,'fused_a'],'count':[12,12]}).to_pickle(table/'dynamic_counts_custom.pkl')
    pd.DataFrame({'instr':[None,'fused_a'],'count':[2,2]}).to_pickle(table/'static_counts_custom.pkl')
    pd.DataFrame({'instr':['add','fused_a'],'count':[100,12]}).to_pickle(table/'instrs_hist.pkl')
    pd.DataFrame({'instr_lower':['fused_a','unused_b']}).to_pickle(table/'ise_instrs.pkl')
    (tmp_path/'instruction-selector.json').write_text('{"selector":"dag","global_isel":false}')
    result=module.summarize(tmp_path)
    assert result['custom_executions']==12
    assert result['custom_static_sites']==2
    assert result['trace_instructions']==112
    assert result['emitted_ises']==2 and result['utilized_ises']==1
    assert result['per_ise_executions']['unused_b']==0


def test_shell_syntax():
    for name in ('isel_config.sh','flow_trace.sh','flow_compare.sh','flow_retrace.sh',
                 'flow_reanalyze.sh','flow_compare_isel.sh','flow_bench.sh',
                 'flow_bench_perf.sh','flow_trace_perf.sh','flow_retrace_perf.sh',
                 'flow_compare_perf.sh','flow_compare_per_instr.sh','flow_compare_others.sh'):
        subprocess.run(['bash','-n',str(ROOT/'scripts'/name)],check=True)


def test_comparison_runs_both_selectors_with_separate_outputs(tmp_path):
    binaries=tmp_path/'bin';binaries.mkdir();log=tmp_path/'calls'
    shell=binaries/'bash'
    shell.write_text('#!/bin/sh\nprintf "%s,%s,%s,%s\\n" "$GLOBAL_ISEL" "$ISAAC_ISEL" "$ISEL_VARIANT" "$1" >> "$CALL_LOG"\n')
    python=binaries/'python3'
    python.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$CALL_LOG"\n')
    shell.chmod(0o755);python.chmod(0o755)
    env=dict(os.environ,PATH=str(binaries)+':'+os.environ['PATH'],CALL_LOG=str(log),FINAL='1')
    subprocess.run(['/bin/bash',str(ROOT/'scripts/flow_compare_isel.sh'),str(tmp_path)],env=env,check=True)
    calls=log.read_text().splitlines()
    assert len(calls)==7
    for offset,selector,variant in ((0,0,'dag'),(3,1,'gisel')):
        for index,stage in enumerate(('compare','retrace','reanalyze')):
            assert calls[offset+index].startswith(f'{selector},{variant},{variant},')
            assert calls[offset+index].endswith(f'flow_{stage}.sh')
    assert 'sess_new_final_isel_dag' in calls[-1]
    assert 'sess_new_final_isel_gisel' in calls[-1]
