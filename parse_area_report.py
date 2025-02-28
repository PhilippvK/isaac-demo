#!/usr/bin/python3

import sys
import re
from pathlib import Path

assert len(sys.argv) == 2

report_file = Path(sys.argv[1])
assert report_file.is_file()

with open(report_file, "r") as f:
    contents = f.read()

matched = re.compile(r"Total cell area:\s+([\-\+]?[0-9]*(?:\.[0-9]+)?)").findall(contents)
# print("matched", matched)
assert len(matched) == 1
total_cell_area = float(matched[0])
# status, slack = matched[0]
# slack = float(slack)
# isax_xisaac                        5734.4280     19.3      0.0000      0.0000  0.0000  ISAX_XIsaac_0
matched2 = re.compile(r"isax_xisaac\s+([\-\+]?[0-9]*(?:\.[0-9]+)?)\s+([\-\+]?[0-9]*(?:\.[0-9]+)?)").findall(contents)
# print("matched2", matched2)
assert len(matched2) == 1
isax_area, isax_area_rel = matched2[0]
isax_area = float(isax_area)
isax_area_rel = float(isax_area_rel) / 100.0


print("total_cell_area,isax_area,isax_area_rel")
print(f"{total_cell_area},{isax_area},{isax_area_rel}")
