import argparse
from typing import Union, List, Optional
from pathlib import Path

import pandas as pd

DEFAULT_SEAL5_PHASES = [f"PHASE_{i}" for i in range(1, 6)]


def parse_git_diff_shortstat(stat_file: Union[str, Path]):
    n_files_changed = 0
    n_insertions = 0
    n_deletions = 0
    with open(stat_file, "r") as f:
        content = f.read()
    for x in content.split(","):
        x = x.strip()
        if len(x) == 0:
            continue
        val, key = x.split(" ", 1)
        val = int(val)
        if "files changed" in key or "file changed" in key:
            n_files_changed = val
        elif "insertions" in key:
            n_insertions = val
        elif "deletions" in key:
            n_deletions = val
    return n_files_changed, n_insertions, n_deletions


def get_combined_locs_df(
    seal5_diff_csv: Optional[Union[str, Path]] = None,
    seal5_phases: List[str] = DEFAULT_SEAL5_PHASES,
    etiss_patch_stat: Optional[Union[str, Path]] = None,
    hls_metrics_csv: Optional[Union[str, Path]] = None,
):
    combined_locs_data = []
    if seal5_diff_csv is not None:
        seal5_diff_df = pd.read_csv(seal5_diff_csv)
        filtered_seal5_diff_df = seal5_diff_df[seal5_diff_df["phase"].isin(seal5_phases)]
        n_files_changed = filtered_seal5_diff_df["n_files_changed"].sum()
        n_insertions = filtered_seal5_diff_df["n_insertions"].sum()
        n_deletions = filtered_seal5_diff_df["n_deletions"].sum()
        seal5_locs_data = {
            "step": "seal5",
            "n_files_changed": n_files_changed,
            "n_insertions": n_insertions,
            "n_deletions": n_deletions,
        }
        combined_locs_data.append(seal5_locs_data)
    if etiss_patch_stat is not None:
        n_files_changed, n_insertions, n_deletions = parse_git_diff_shortstat(etiss_patch_stat)
        etiss_locs_data = {
            "step": "etiss",
            "n_files_changed": n_files_changed,
            "n_insertions": n_insertions,
            "n_deletions": n_deletions,
        }
        combined_locs_data.append(etiss_locs_data)
    if hls_metrics_csv is not None:
        hls_metrics_df = pd.read_csv(hls_metrics_csv)
        n_files_changed = 1
        n_insertions = hls_metrics_df["locs"].sum()  # TODO: add SCAIE-V locs?
        n_deletions = 0
        rtl_locs_data = {
            "step": "rtl",
            "n_files_changed": n_files_changed,
            "n_insertions": n_insertions,
            "n_deletions": n_deletions,
        }
        combined_locs_data.append(rtl_locs_data)
    combined_locs_df = pd.DataFrame(combined_locs_data)
    if "n_insertions" in combined_locs_df.columns:
        combined_locs_df["n_insertions"] = combined_locs_df["n_insertions"].astype(int)
    return combined_locs_df


def write_combined_locs_csv(
    dest: Union[str, Path],
    seal5_diff_csv: Optional[Union[str, Path]] = None,
    seal5_phases: List[str] = DEFAULT_SEAL5_PHASES,
    etiss_patch_stat: Optional[Union[str, Path]] = None,
    hls_metrics_csv: Optional[Union[str, Path]] = None,
):
    combined_locs_df = get_combined_locs_df(
        seal5_diff_csv=seal5_diff_csv, etiss_patch_stat=etiss_patch_stat, hls_metrics_csv=hls_metrics_csv
    )
    combined_locs_df.to_csv(dest, index=False)


def main():
    parser = argparse.ArgumentParser(description="Collect LOCs from ISAAC steps")
    parser.add_argument("-o", "--output", default=None, help="Output CSV file")
    parser.add_argument("--seal5-diff-csv", default=None, help="Seal5 diff CSV file")
    parser.add_argument("--etiss-patch-stat", default=None, help="ETISS patch stat file")
    parser.add_argument("--hls-metrics-csv", default=None, help="HLS metrics file")
    args = parser.parse_args()
    if args.output is None:
        combined_locs_df = get_combined_locs_df(
            seal5_diff_csv=args.seal5_diff_csv,
            etiss_patch_stat=args.etiss_patch_stat,
            hls_metrics_csv=args.hls_metrics_csv,
        )
        print("Combined LOCs DF:")
        print(combined_locs_df)
    else:
        write_combined_locs_csv(
            args.output,
            seal5_diff_csv=args.seal5_diff_csv,
            etiss_patch_stat=args.etiss_patch_stat,
            hls_metrics_csv=args.hls_metrics_csv,
        )


if __name__ == "__main__":
    main()
