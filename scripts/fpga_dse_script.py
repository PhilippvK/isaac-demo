import os
import subprocess
import time
import re
import csv
from pathlib import Path
from datetime import timedelta
from datetime import datetime

CORE = os.environ.get("CORE", "CVA5")
TCLK = float(os.environ.get("TCLK", 10.0))
MODE = os.environ.get("MODE", "baseline")
TIMEOUT = float(os.environ.get("TIMEOUT", 10 * 60))
SLACK_MARGIN = 2
MIN_STEP = 0.01


def get_timestamp():
    now = datetime.now()
    timestamp = now.strftime("%Y-%m-%dT%H:%M:%S")
    return timestamp


def append_csv_row(csv_path, row, write_header=False):
    write_header = write_header and not os.path.exists(csv_path)
    with open(csv_path, "a", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "timestamp",
                "core",
                "mode",
                "res",
                "t_clk",
                "f_clk",
                "slack",
                "f_est",
                "f_err",
                "t_syn",
                "f_max",
                "util",
            ],
        )
        if write_header:
            writer.writeheader()
        writer.writerow(row)


def parse_slack_from_report(syn_path, t_clk_ns):
    report_path = os.path.join(syn_path, "reports/timing_summary.rpt")
    try:
        with open(report_path, "r") as f:
            for line in f:
                # match = re.search(r"Slack\s+\((MET|VIOLATED)\)\s*:\s*(-?[0-9.]+)ns", line)
                match = re.search(r"Slack\s+\((?:MET|VIOLATED)\)\s*:\s*([-+]?\d*\.\d+|\d+)ns", line)
                if match:
                    return float(match.group(1))
    except FileNotFoundError:
        pass
    return None  # Slack not found


def get_util(syn_path, mode):
    metrics_csv = Path(syn_path) / "metrics.csv"
    args = [
        "python3",
        "scripts/collect_fpga_syn_metrics.py",
        f"--{mode}-dir",
        syn_path,
        "--out",
        metrics_csv,
    ]
    # print("args", args)
    _ = subprocess.run(args, capture_output=True, text=True)
    # print("out", out)
    import pandas as pd

    assert metrics_csv.is_file()
    metrics_df = pd.read_csv(metrics_csv)
    # print("metrics_df", metrics_df)
    assert len(metrics_df) == 1
    data = metrics_df.iloc[0].to_dict()
    del data["variant"]
    # print("data", data)
    # input("!")
    return data


def run_synthesis(t_clk_ns, exp_path, work_dir=None, script="./scripts/fpga_syn_script.sh", cleanup=False):
    ts = get_timestamp()
    assert Path(exp_path).is_dir()
    print("run_synthesis", CORE, MODE, t_clk_ns, exp_path, work_dir, cleanup)
    base_dir = os.path.join(exp_path, "work/docker/fpga_syn/") if work_dir is None else work_dir
    # TODO: asser is_dir
    syn_path = os.path.join(base_dir, f"{MODE}_{t_clk_ns:.2f}")
    rtl_path = os.path.join(exp_path, f"work/docker/hls/{MODE}/rtl")
    assert Path(rtl_path).is_dir()
    args = [
        script,
        # f"{rtl_path}/fpga_syn_new/{MODE}_{t_clk_ns:.2f}",
        syn_path,
        rtl_path,
        CORE,
        "xc7a200tffv1156-1",
        f"{t_clk_ns:.2f}",
    ]

    start = time.time()
    try:
        # result = subprocess.run(["time"] + args, capture_output=True, text=True, timeout=TIMEOUT)
        _ = subprocess.run(args, capture_output=True, text=True, timeout=TIMEOUT)
        # print("result", result)
        duration = timedelta(seconds=(time.time() - start))
    except subprocess.TimeoutExpired:
        return "FAIL", t_clk_ns, 1000 / t_clk_ns, None, None, "TIMEOUT", {}, ts
    # print("duration", duration)

    # stdout = result.stdout + result.stderr

    # Detect PASS/FAIL
    slack = parse_slack_from_report(syn_path, t_clk_ns)
    # print("slack", slack)
    res = "PASS" if slack is not None and slack >= 0 else "FAIL"
    # print("res", res)

    # Clock frequency (MHz)
    f_clk = 1000 / t_clk_ns
    # print("fclk", f_clk)

    # Estimate max frequency based on slack
    if slack is not None and (t_clk_ns - slack) != 0:
        f_est = 1000 / (t_clk_ns - slack)
    else:
        f_est = None
    print("fest", f_est)

    utilization = get_util(syn_path, MODE)
    # print("utilization", utilization)

    if cleanup:
        # TODO: use logginf module
        print(f"Cleaning up temporary files: {syn_path}")
        import shutil

        shutil.rmtree(syn_path)

    return res, t_clk_ns, f_clk, slack, f_est, str(duration), utilization, ts


def dse_loop(rtl_path, max_iters=30, csv_path=None, work_dir=None, cleanup=False, min_step=0.01, slack_margin=3):
    t_clk = TCLK
    history = []

    last_valid = None
    last_fail = None
    num_fail = 0
    f_max = 0.0
    max_failing_t_clk = 0.0

    for i in range(max_iters):
        res, t_clk_ns, f_clk, slack, f_est, t_syn, util, ts = run_synthesis(
            t_clk, rtl_path, work_dir=work_dir, cleanup=cleanup
        )

        # Calculate f_err from previous valid result
        f_err = None
        if last_valid and f_est:
            f_err_val = abs(f_est - last_valid["f_est"])
            f_err = f"{f_err_val:.1f} MHz"

        new_row = {
            "timestamp": ts,
            "core": CORE,
            "mode": MODE,
            "res": res,
            "t_clk": t_clk_ns,
            "f_clk": round(f_clk, 1),
            "slack": round(slack, slack_margin) if slack is not None else "N/A",
            "f_est": round(f_est, 1) if f_est else "N/A",
            "f_err": f_err if f_err is not None else "N/A",
            "t_syn": t_syn,
            "f_max": f_max,
            "util": util,
        }
        if res == "FAIL":
            if slack < 0 and abs(round(slack, slack_margin)) == 0.0:
                res = "MARGIN"
                new_row["res"] = res
        if res in ["PASS", "MARGIN"] and f_est and f_clk > f_max:
            f_max = f_clk
            new_row["f_max"] = f"{round(f_clk, 1)}"
        if res == "FAIL":
            max_failing_t_clk = max(max_failing_t_clk, t_clk)
        elif res == "TIMEOUT":
            num_fail += 1
        else:
            num_fail = 0
            last_fail = {"t_clk": t_clk}
        print("new_row", new_row)
        history.append(new_row)
        if csv_path:
            append_csv_row(csv_path, history[-1], write_header=(i == 0))

        # Stop if improvement is less than 1 MHz
        if last_valid and f_est:
            diff = abs(f_est - last_valid["f_est"])
            # print("diff", diff)
            if diff < 1.0 or num_fail > 2:
                print("break")
                break

        # Update tracking
        if res in ["PASS", "MARGIN"] and f_est:
            last_valid = {"t_clk": t_clk, "f_est": f_est}
        elif res == "FAIL":
            last_fail = {"t_clk": t_clk}

        # Predict next t_clk
        if slack is not None:
            slack_ = slack * 0.8 if slack >= 0 else slack
            print("slack", slack)
            t_clk_pred = t_clk - slack_
            print("t_clk_pred", t_clk_pred)
            if last_valid and last_fail and t_clk_pred > last_valid["t_clk"]:
                print("bisect")
                # Use bisection fallback
                t_clk_old = t_clk
                t_clk = (last_valid["t_clk"] + last_fail["t_clk"]) / 2
                step = t_clk - t_clk_old
                sign = -1 if step < 0 else +1
                step = abs(step)
                if step < min_step:
                    print("step_to_small", step)
                    step = min_step
                    print("new_step", step)
                    t_clk = t_clk_old + sign * step
            else:
                print("update")
                t_clk_old = t_clk
                t_clk = max(1.0, t_clk_pred)
                step = t_clk - t_clk_old
                sign = -1 if step < 0 else +1
                step = abs(step)
                if step < min_step:
                    print("step_to_small", step)
                    step = min_step
                    print("new_step", step)
                    t_clk = t_clk_old + sign * step
        else:
            print("fallback")
            # No slack: fallback
            t_clk += 1.0
        print("t_clk", t_clk)

        if max_failing_t_clk > 0.0:
            if t_clk < max_failing_t_clk:
                print("abort")
                break

    # Print result table
    print(
        f"\n{'timestamp':<17} {'isa':<12} {'res':<6} {'t_clk':<6} {'f_clk':<6} {'slack':<7} {'f_est':<6} {'f_err':<10} {'t_syn':<6} util"
    )
    print(f"{MODE:<12}", end="")
    for row in history:
        print(
            f"\n{row['timestamp']:<17} {'':<12} {row['res']:<6} {row['t_clk']:<6.2f} {row['f_clk']:<6.1f} {row['slack']:<7} {row['f_est']:<6} {row['f_err']:<10} {row['t_syn']:<6} {row['util']}"
        )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("exp_path", help="Path to parent exp directory")
    parser.add_argument("--csv", help="Path to CSV output file", default=None)
    parser.add_argument("--workdir", help="DSE Working directory", default=None)
    parser.add_argument("--cleanup", help="Cleanup temporary files", action="store_true")
    parser.add_argument("--min-step", help="Minimum tclk step", type=float, default=MIN_STEP)
    parser.add_argument(
        "--slack-margin", help="Slack precision (number of deciaml digits)", type=float, default=SLACK_MARGIN
    )
    # TODO: auto-cleanup?
    args = parser.parse_args()

    dse_loop(
        args.exp_path,
        csv_path=args.csv,
        cleanup=args.cleanup,
        work_dir=args.workdir,
        min_step=args.min_step,
        slack_margin=args.slack_margin,
    )
