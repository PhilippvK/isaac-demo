#!/usr/bin/python3

import sys
import re
from pathlib import Path

assert len(sys.argv) == 2

report_file = Path(sys.argv[1])
assert report_file.is_file()

with open(report_file, "r") as f:
    contents = f.read()

matched = re.compile(r"slack \(([A-Z]+)\)\s+([\-\+]?[0-9]*(?:\.[0-9]+)?)").findall(contents)
assert len(matched) == 1
status, slack = matched[0]
slack = float(slack)
matched2 = re.compile(r"clock clk \(rise edge\)\s+([\-\+]?[0-9]*(?:\.[0-9]+)?)").findall(contents)
assert len(matched2) > 0
clk = float(matched2[-1])

# print("matched", matched)
# print("matched2", matched2)

print("clk,status,slack")
print(f"{clk},{status},{slack}")
