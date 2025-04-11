# TODO

import sys
from pathlib import Path
import pandas as pd

assert len(sys.argv) in [2, 3]

report_file = Path(sys.argv[1])
assert report_file.is_file()

if len(sys.argv) == 3:
    out_file = Path(sys.argv[2])
else:
    out_file = None

with open(report_file, "r") as f:
    content = f.read()

PRE = "1. Utilization by Hierarchy"
POST = "Note: The sum of lower-level cells may be larger than their parent cells total, due to cross-hierarchy LUT combining"

assert PRE in content

content = content.split(PRE)[-1]

assert POST in content

content = content.split(POST)[0]

lines = list(map(lambda x: x.strip(), content.splitlines()))

lines = [line for line in lines if len(line) > 1 and "---" not in line]

def parse_line(line):
    assert len(line) > 1
    assert line[0] == "|"
    assert line[-1] == "|"
    line = line[1:-1]
    cols = line.split("|")
    cols = list(map(lambda x: x.strip(), cols))
    return cols

data = list(map(parse_line, lines))

assert len(data) > 1

col_names = data[0]

data = data[1:]

df = pd.DataFrame(data, columns=col_names)

if out_file is None:
    print(df)
else:
    df.to_csv(out_file, index=False)
