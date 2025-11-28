import os
import subprocess
import time
import re
import csv
from pathlib import Path
from datetime import timedelta
from datetime import datetime

CORE = os.environ.get("CORE", "VEX_4S")
PDK = os.environ.get("PDK", "nangate45")
TCLK = float(os.environ.get("TCLK", 10.0))
MODE = os.environ.get("MODE", "baseline")
TIMEOUT = float(os.environ.get("TIMEOUT", 20 * 60))
# SLACK_MARGIN = 2
SLACK_MARGIN = 1
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
                "area",
            ],
        )
        if write_header:
            writer.writeheader()
        writer.writerow(row)


def parse_slack_from_report(syn_path, t_clk_ns):
    # report_path = os.path.join(syn_path, "reports/timing_summary.rpt")
    report_path = os.path.join(syn_path, "log/report_timing.log")
    try:
        with open(report_path, "r") as f:
            for line in f:
                # match = re.search(r"Slack\s+\((MET|VIOLATED)\)\s*:\s*(-?[0-9.]+)ns", line)
                # match = re.search(r"Slack\s+\((?:MET|VIOLATED)\)\s*:\s*([-+]?\d*\.\d+|\d+)ns", line)
                # match = re.search(r"slack\s+\((?:MET|VIOLATED)\)\s+([-+]?\d*\.\d+|\d+)$", line)
                match = re.search(r"slack\s+\((?:MET|VIOLATED)(?:[^)]*)\)\s+([-+]?\d*\.\d+|\d+)", line, re.IGNORECASE)
                if match:
                    return float(match.group(1))
    except FileNotFoundError:
        pass
    return None  # Slack not found


def get_area(syn_path, mode):
    metrics_csv = Path(syn_path) / "metrics.csv"
    args = [
        "python3",
        "scripts/collect_asip_syn_metrics.py",
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


def run_synthesis(t_clk_ns, exp_path, script="./scripts/asip_syn_script.sh", work_dir=None, cleanup=False):
    ts = get_timestamp()
    assert Path(exp_path).is_dir()
    # print("run_synthesis", CORE, MODE, t_clk_ns, exp_path)
    base_dir = os.path.join(exp_path, "work/docker/asip_syn/") if work_dir is None else work_dir

    syn_path = os.path.join(base_dir, f"{MODE}_{t_clk_ns:.2f}")
    rtl_path = os.path.join(exp_path, f"work/docker/hls/{MODE}/rtl")
    # constraints_file = os.path.join(exp_path, f"work/docker/asip_syn/{MODE}/constraints.sdc")
    # constraints_file = os.path.join(exp_path, f"/work/git/isaac-demo/constraints/{CORE}/top.sdc")
    assert Path(rtl_path).is_dir()
    args = [
        script,
        syn_path,
        rtl_path,
        CORE,
        PDK,
        f"{t_clk_ns:.2f}",
        # constraints_file,
    ]

    start = time.time()
    try:
        # result = subprocess.run(["time"] + args, capture_output=True, text=True, timeout=TIMEOUT)
        print("$", " ".join(args))
        _ = subprocess.run(args, capture_output=True, text=True, check=True, timeout=TIMEOUT)
        duration = timedelta(seconds=(time.time() - start))
    except subprocess.TimeoutExpired:
        return "FAIL", t_clk_ns, 1000 / t_clk_ns, None, None, "TIMEOUT", {}, ts
    except Exception as ex:
        raise ex
        del ex
        return "ERR", t_clk_ns, 1000 / t_clk_ns, None, None, None, {}, ts
    print("duration", duration)

    # stdout = result.stdout + result.stderr

    # Detect PASS/FAIL
    slack = parse_slack_from_report(syn_path, t_clk_ns)
    print("slack", slack)
    res = "PASS" if slack is not None and slack >= 0 else "FAIL"
    print("res", res)

    # Clock frequency (MHz)
    f_clk = 1000 / t_clk_ns
    print("fclk", f_clk)

    # Estimate max frequency based on slack
    if slack is not None and (t_clk_ns - slack) != 0:
        f_est = 1000 / (t_clk_ns - slack)
    else:
        f_est = None
    print("fest", f_est)

    area = get_area(syn_path, MODE)
    print("area", area)

    if cleanup:
        # TODO: use logginf module
        print(f"Cleaning up temporary files: {syn_path}")
        import shutil

        shutil.rmtree(syn_path)

    return res, t_clk_ns, f_clk, slack, f_est, str(duration), area, ts


def dse_loop(
    rtl_path,
    csv_path=None,
    resolution_mhz=1.0,
    tclk_min=1.0,
    tclk_max=None,
    max_iters=32,
    max_consec_fails=5,
    slack_factor=1.0,
    work_dir=None,
    cleanup=False,
    min_step=0.01,
    slack_margin=3,
):
    if tclk_max is None:
        tclk_max = TCLK

    history = []
    tried = {}
    f_max = 0.0
    best_result = None
    num_consec_failures = 0
    had_success = False
    t_clk = tclk_max  # start conservatively

    for i in range(max_iters):
        f_clk = 1000 / t_clk

        if t_clk in tried:
            print(f"Skipping t_clk={t_clk:.2f} ns (already tried)")
            t_clk += 0.01
            continue

        res, t_clk_ns, f_clk, slack, f_est, t_syn, area, ts = run_synthesis(
            t_clk, rtl_path, work_dir=work_dir, cleanup=cleanup
        )
        tried[t_clk] = res

        f_err = None
        if best_result and f_est:
            f_err_val = abs(f_est - best_result["f_est"])
            f_err = f"{f_err_val:.1f}"

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
            "f_max": round(f_max, 1),
            "area": area,
        }

        if res == "FAIL":
            if slack < 0 and abs(round(slack, slack_margin)) == 0.0:
                res = "MARGIN"
                new_row["res"] = res
        if res in ["PASS", "MARGIN"]:
            if f_clk > f_max:
                f_max = f_clk
                new_row["f_max"] = f"{round(f_clk, 1)}"

        history.append(new_row)
        if csv_path:
            append_csv_row(csv_path, new_row, write_header=(len(history) == 1))

        # Stop if slack is slightly violated
        if slack is not None and slack < 0 and abs(slack) < 0.000005:
            print("Stopping: slack violation is negligible (< 0.05 ns).")
            break

        if res in ["PASS", "MARGIN"]:
            had_success = True
            num_consec_failures = 0
            best_result = {"t_clk": t_clk, "f_est": f_est}
            tclk_max = t_clk
            # Binary search
            t_clk = round((tclk_min + tclk_max) / 2, 2)
            step = t_clk - tclk_max
            sign = -1 if step < 0 else +1
            step = abs(step)
            if step < min_step:
                print("step_to_small", step)
                step = min_step
                print("new_step", step)
                t_clk = tclk_max + sign * step
        else:
            if had_success:
                num_consec_failures += 1
                if num_consec_failures > max_consec_fails:
                    print(f"Stopping: {num_consec_failures} consecutive failures after a pass.")
                    break

            if slack is not None:
                t_clk_old = t_clk
                t_clk_new = t_clk - (slack * slack_factor)
                f_delta = abs(1000 / t_clk - 1000 / t_clk_new)

                if f_delta < resolution_mhz:
                    print(
                        f"Slack step < resolution ({f_delta:.2f} MHz < {resolution_mhz} MHz). Fallback to binary search."
                    )
                    t_clk = round((tclk_min + tclk_max) / 2, 2)
                else:
                    tclk_min = t_clk
                    t_clk = round(max(tclk_min, t_clk_new), 2)
                step = t_clk - t_clk_old
                sign = -1 if step < 0 else +1
                step = abs(step)
                if step < min_step:
                    print("step_to_small", step)
                    step = min_step
                    print("new_step", step)
                    t_clk = t_clk_old + sign * step
            else:
                tclk_min = t_clk
                t_clk += min_step

        # Resolution check
        if tclk_max != tclk_min:
            f_low = 1000 / tclk_max
            f_high = 1000 / tclk_min
            if f_high - f_low <= resolution_mhz:
                print("f_low", f_low)
                print("f_high", f_high)
                print("f_low-f_high", f_low - f_high)
                print("resolution_mhz", resolution_mhz)
                print("Stopping: frequency resolution limit reached.")
                break

    # Final report
    print(
        f"\n{'timestamp':<17} {'isa':<12} {'res':<6} {'t_clk':<6} {'f_clk':<6} {'slack':<8} {'f_est':<6} {'f_err':<10} {'t_syn':<6} {'f_max':<6} area"
    )
    print(f"{MODE:<12}", end="")
    for row in history:
        print(row)
        if True:
            print(
                f"\n{row['timestamp']:<17} {'':<12} {row['res']:<6} {row['t_clk']:<6.2f} {row['f_clk']:<6.1f} {row['slack']:<8} {row['f_est']:<6} {row['f_err']:<10} {row['t_syn']:<6} {row['f_max']:<6} {row['area']}"
            )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("exp_path", help="Path to parent exp directory")
    parser.add_argument("--csv", help="Path to CSV output file", default=None)
    parser.add_argument("--resolution", type=float, default=1.0, help="Frequency resolution in MHz")
    parser.add_argument("--min", dest="tclk_min", type=float, default=1.0, help="Minimum clock period")
    parser.add_argument("--max", dest="tclk_max", type=float, default=None, help="Maximum clock period")
    parser.add_argument("--trials", type=int, default=32, help="Maximum number of trials")
    parser.add_argument("--workdir", help="DSE Working directory", default=None)
    parser.add_argument("--cleanup", help="Cleanup temporary files", action="store_true")
    parser.add_argument("--min-step", help="Minimum tclk step", type=float, default=MIN_STEP)
    parser.add_argument(
        "--slack-margin", help="Slack precision (number of deciaml digits)", type=float, default=SLACK_MARGIN
    )
    # TODO: auto-cleanup?
    args = parser.parse_args()
    print("args", args)

    dse_loop(
        args.exp_path,
        csv_path=args.csv,
        resolution_mhz=args.resolution,
        tclk_min=args.tclk_min,
        tclk_max=args.tclk_max,
        max_iters=args.trials,
        cleanup=args.cleanup,
        work_dir=args.workdir,
        min_step=args.min_step,
        slack_margin=args.slack_margin,
    )
