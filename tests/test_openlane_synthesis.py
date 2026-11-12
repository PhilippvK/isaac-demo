"""Verify independent OpenLane result validation and full-flow dispatch."""

import importlib.util
import json
import math
import os
from pathlib import Path
import shutil
import subprocess
import sys

import pandas as pd
import pytest

ROOT = Path(__file__).resolve().parents[1]


def load():
    spec = importlib.util.spec_from_file_location("ol_backend", ROOT / "scripts/asip_syn/openlane_run.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def output(tmp_path, setup=1, hold=-0.1):
    final = tmp_path / "runs/asip/final"
    final.mkdir(parents=True)
    (final / "nl").mkdir()
    (final / "nl/top.nl.v").write_text("module top; endmodule")
    state = final.parent / "6-openroad-staprepnr/state_out.json"
    state.parent.mkdir()
    state.write_text("{}")
    (final.parent / "resolved.json").write_text("{}")
    metrics = {
        "design__instance_unmapped__count": 0,
        "synthesis__check_error__count": 0,
        "design__instance__area": 100,
        "timing__setup__ws": setup,
        "timing__hold__ws": hold,
    }
    (final / "metrics.json").write_text(json.dumps(metrics))
    return metrics


@pytest.mark.parametrize("setup,hold", [(1, 0.1), (-1, 0.1), (1, -0.1)])
def test_synthesis_completion_is_separate_from_setup_and_hold(tmp_path, setup, hold):
    module = load()
    output(tmp_path, setup, hold)
    meta = {"clock_period_ns": 10}
    module.collect_results(tmp_path, meta)
    assert meta["passed"]
    assert meta["setup_timing_met"] == (setup >= 0)
    assert meta["hold_timing_met"] == (hold >= 0)
    assert meta["timing_met"] == (setup >= 0 and hold >= 0)
    (tmp_path / "runs/asip/final/nl/top.nl.v").write_text("altered")
    with pytest.raises(ValueError, match="hash mismatch"):
        module.collect_results(tmp_path, meta)


@pytest.mark.parametrize(
    "key,value",
    [
        ("timing__setup__ws", None),
        ("timing__setup__ws", math.inf),
        ("design__instance_unmapped__count", 1),
        ("synthesis__check_error__count", 1),
    ],
)
def test_incomplete_or_invalid_results_fail_closed(tmp_path, key, value):
    module = load()
    metrics = output(tmp_path)
    metrics[key] = value
    (tmp_path / "runs/asip/final/metrics.json").write_text(json.dumps(metrics))
    with pytest.raises(ValueError):
        module.collect_results(tmp_path, {"clock_period_ns": 10})
    assert not (tmp_path / "metrics.csv").exists()


def test_synthesis_only_cannot_count_as_sta(tmp_path):
    module = load()
    output(tmp_path)
    (tmp_path / "runs/asip/6-openroad-staprepnr/state_out.json").unlink()
    with pytest.raises(ValueError, match="STA"):
        module.collect_results(tmp_path, {"clock_period_ns": 10})


def test_sibling_extension_and_headers_are_staged(tmp_path):
    module = load()
    core = tmp_path / "rtl/VexRiscv_5s"
    core.mkdir(parents=True)
    (core / "files.txt").write_text("top.sv\n")
    (core / "top.sv").write_text('`include "nested/data.svh"\n')
    (core / "nested").mkdir()
    (core / "nested/data.svh").write_text("// Header")
    (core.parent / "ISAX_test.sv").write_text("// Extension")
    sources = module.rtl_sources(core.parent, "VEX_5S")
    staged, includes, headers = module.stage_sources(sources, tmp_path / "out")
    assert {Path(p).name for p in staged} == {"top.sv", "ISAX_test.sv"}
    assert any((Path(p) / "nested/data.svh").is_file() for p in includes)
    assert len(headers) == 1


@pytest.mark.parametrize("tool", ["synopsys", "ol2", "librelane"])
def test_full_flow_dispatches_all_variants_and_collects_reports(tmp_path, tool):
    scripts = tmp_path / "scripts"
    scripts.mkdir()
    shutil.copyfile(ROOT / "scripts/collect_asip_syn_metrics.py", scripts / "collect_asip_syn_metrics.py")
    backend = scripts / "asip_syn_script.sh"
    backend.write_text("""#!/bin/bash
set -e
mkdir -p "$1"
python3 - "$1" "$2" "$3" "$4" "$5" <<'PY'
import json,sys,pathlib
out=pathlib.Path(sys.argv[1])
(out/'invocation.json').write_text(json.dumps(sys.argv[2:]))
(out/'metrics.csv').write_text('total_cell_area,isax_area,scaiev_area\\n100,5,2\\n')
import os
(out/'execution.json').write_text(json.dumps({'passed':True,'tool':os.environ['ASIP_SYN_TOOL'],
'pdk':sys.argv[4],'clock_period_ns':float(sys.argv[5]),'metrics':{'setup_slack_ns':1},
'setup_timing_met':True,'hold_timing_met':False,'timing_met':False}))
PY
""")
    experiment = tmp_path / "experiment"
    experiment.mkdir()
    env = dict(
        os.environ,
        ASIP_SYN_ENABLE="1",
        ASIP_SYN_TOOL=tool,
        FPGA_SYN_ENABLE="0",
        SCRIPTS_DIR=str(scripts),
        ASIP_SYN_PYTHON=sys.executable,
        USE_HLS_DOCKER="1",
        ASIP_SYN_SKIP_BASELINE="0",
        ASIP_SYN_SKIP_DEFAULT="0",
        ASIP_SYN_SKIP_SHARED="0",
        HLS_TOOL="nailgun",
        HLS_NAILGUN_SHARE_RESOURCES="1",
        FILTERED="1",
        SELECTED="1",
        ASIP_SYN_SYNOPSYS_CORE_NAME="VEX_5S",
        ASIP_SYN_SYNOPSYS_CLOCK_NS="12",
        ASIP_SYN_SYNOPSYS_PDK="nangate45",
        ASIP_SYN_OL2_PDK="sky130A",
        ASIP_SYN_OL2_CLOCK_NS="15",
    )
    env.pop("ASIP_SYN_SYNOPSYS_CLK_PERIOD", None)
    env.pop("ASIP_SYN_OUTPUT_DIR", None)
    env.pop("ASIP_SYN_HLS_DIR", None)
    env.pop("ASIP_SYN_BASELINE_USE", None)
    subprocess.run(
        ["bash", str(ROOT / "scripts/flow_syn.sh"), str(experiment)], env=env, check=True, capture_output=True
    )
    backend_suffix = {"synopsys": "", "ol2": "_openlane2", "librelane": "_librelane"}[tool]
    output_dir = experiment / f"work/docker/asip_syn{backend_suffix}_filtered_selected"
    table = pd.read_csv(output_dir / "metrics.csv")
    assert set(table["variant"]) == {"baseline", "default", "shared"}
    assert set(table["tool"]) == {tool}
    assert set(table["clock_period_ns"]) == {12 if tool == "synopsys" else 15}
    assert (experiment / f"asip_syn{backend_suffix}_filtered_selected/manifest.json").is_file()
    for variant in ["baseline", "default", "shared"]:
        invocation = json.loads((output_dir / variant / "invocation.json").read_text())
        assert "hls_filtered_selected" in invocation[0]
        assert invocation[1] == "VEX_5S"


@pytest.mark.parametrize(
    "change", [{"tool": "synopsys"}, {"pdk": "sky130B"}, {"clock_period_ns": 20}, {"passed": False}]
)
def test_cached_baseline_must_match_backend_pdk_and_clock(tmp_path, change):
    baseline = tmp_path / "baseline"
    baseline.mkdir()
    (baseline / "metrics.csv").write_text("total_cell_area\n100\n")
    meta = {"passed": True, "tool": "librelane", "pdk": "sky130A", "clock_period_ns": 10}
    meta.update(change)
    (baseline / "execution.json").write_text(json.dumps(meta))
    target = tmp_path / "aggregate.csv"
    result = subprocess.run(
        [
            sys.executable,
            str(ROOT / "scripts/collect_asip_syn_metrics.py"),
            "--baseline-dir",
            str(baseline),
            "--expected-tool",
            "librelane",
            "--expected-pdk",
            "sky130A",
            "--expected-clock-ns",
            "10",
            "--output",
            str(target),
        ],
        capture_output=True,
    )
    assert result.returncode != 0
    assert not target.exists()
