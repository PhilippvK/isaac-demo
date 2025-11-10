import argparse
from pathlib import Path
from collections import defaultdict
from typing import Dict, Optional

import matplotlib.pyplot as plt
import pandas as pd
import yaml


def main():
    parser = argparse.ArgumentParser(description="TODO")
    parser.add_argument("index", help="Index yaml file")
    parser.add_argument("-o", "--output", default=None, help="Output yaml file")
    parser.add_argument("--inplace", action="store_true", help="TODO")
    parser.add_argument("--sankey", default=None, help="TODO")
    parser.add_argument("--min-seal5-score", type=float, default=None, help="TODO")
    parser.add_argument("--min-util-score", type=float, default=None, help="TODO")
    parser.add_argument("--min-runtime-reduction-rel", type=float, default=None, help="TODO")
    parser.add_argument("--min-code-size-reduction-rel", type=float, default=None, help="TODO")
    parser.add_argument("--min-estimated-reduction", type=float, default=None, help="TODO")  # TODO: rename
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    num_candidates = len(candidates)

    to_drop = set()
    reasons_dropped = defaultdict(set)
    for i, candidate in enumerate(candidates):
        metrics = candidate.get("metrics", {})
        if args.min_seal5_score is not None:
            seal5_score = metrics.get("seal5_score")
            if seal5_score is not None:
                if seal5_score < args.min_seal5_score:
                    to_drop.add(i)
                    reasons_dropped["min_seal5_score"].add(i)
                    continue
        if args.min_util_score is not None:
            util_score = metrics.get("util_score")
            if util_score is not None:
                if util_score < args.min_util_score:
                    to_drop.add(i)
                    reasons_dropped["min_util_score"].add(i)
                    continue
        if args.min_runtime_reduction_rel is not None:
            runtime_reduction_rel = metrics.get("runtime_reduction_rel")
            if runtime_reduction_rel is not None:
                if runtime_reduction_rel < args.min_runtime_reduction_rel:
                    to_drop.add(i)
                    reasons_dropped["min_runtime_reduction_rel"].add(i)
                    continue
        if args.min_code_size_reduction_rel is not None:
            code_size_reduction_rel = metrics.get("code_size_reduction_rel")
            if code_size_reduction_rel is not None:
                if code_size_reduction_rel < args.min_code_size_reduction_rel:
                    to_drop.add(i)
                    reasons_dropped["min_code_size_reduction_rel"].add(i)
                    continue
        if args.min_estimated_reduction is not None:
            estimated_reduction_rel = metrics.get("estimated_reduction_rel")
            if estimated_reduction_rel is not None:
                if estimated_reduction_rel < args.min_estimated_reduction:
                    to_drop.add(i)
                    reasons_dropped["min_estimated_reduction"].add(i)
                    continue
    num_drop = len(to_drop)
    num_keep = num_candidates - num_drop
    # TODO: logging
    # TODO: assign new names?
    candidates = [x for i, x in enumerate(candidates) if i not in to_drop]
    combined_index_data["candidates"] = candidates

    if args.inplace:
        assert args.output is None
        out_file = args.index
    else:
        assert args.output is not None
        out_file = args.output

    with open(out_file, "w") as f:
        yaml.dump(combined_index_data, f)

    if args.sankey is not None:
        # logger.info("Exporting sankey diagram...")
        fmt = Path(args.sankey).suffix
        assert fmt in [".md"]
        content = """
```mermaid
---
config:
  sankey:
    showValues: true
---
sankey-beta

%% source,target,value
"""
        content += f"Candidates,Kept,{num_keep}\n"
        for reason, reason_dropped in reasons_dropped.items():
            reason_num_dropped = len(reason_dropped)
            content += f"Candidates,Filtered({reason}),{reason_num_dropped}\n"
        content += """
```
"""
        with open(args.sankey, "w") as f:
            f.write(content)


if __name__ == "__main__":
    main()
