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
    parser.add_argument("--keep-ids", action="store_true", help="TODO")
    parser.add_argument("--sankey", default=None, help="TODO")
    parser.add_argument("--topk", type=int, default=None, help="TODO")
    args = parser.parse_args()

    with open(args.index, "r") as f:
        combined_index_data = yaml.safe_load(f)
    candidates = combined_index_data["candidates"]
    num_candidates = len(candidates)
    print("candidates", candidates, len(candidates))

    if args.topk is not None:
        selected_candidates = [candidate for i, candidate in enumerate(candidates) if i < args.topk]
    else:
        selected_candidates = candidates
    print("selected_candidates", selected_candidates, len(selected_candidates))
    if not args.keep_ids:
        for i, candidate in enumerate(selected_candidates):
            candidate["id"] = i

    num_selected = len(selected_candidates)
    num_dropped = num_candidates - num_selected
    # TODO: logging
    # TODO: assign new names?
    combined_index_data["candidates"] = selected_candidates

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
        content += f"Candidates,Selected,{num_selected}\n"
        content += f"Candidates,Dropped,{num_dropped}\n"
        content += """
```
"""
        with open(args.sankey, "w") as f:
            f.write(content)


if __name__ == "__main__":
    main()
