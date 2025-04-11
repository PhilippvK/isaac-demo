# TODO

import sys
from pathlib import Path
import pandas as pd

assert len(sys.argv) in [2, 3]

csv_file = Path(sys.argv[1])
assert csv_file.is_file()
assert csv_file.suffix == ".csv"

if len(sys.argv) == 3:
    out_file = Path(sys.argv[2])
else:
    out_file = None

df = pd.read_csv(csv_file)

columns = [col for col in df.columns if col != "Module"]

for col in columns:
    df[f"{col} (rel.)"] = df[col] / df[col].iloc[0]

if out_file is None:
    print(df)
else:
    df.to_csv(out_file, index=False)
