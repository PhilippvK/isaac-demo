import sys
import pandas as pd

assert len(sys.argv) == 3

in_file = sys.argv[1]
out_file = sys.argv[2]

df = pd.read_csv(in_file)
assert len(df) == 1

COL = "total_speedup"

benefit = df[COL].iloc[0]

with open(out_file, "w") as f:
    f.write(str(benefit))
