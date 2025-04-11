import sys
import json
from pathlib import Path


assert len(sys.argv) == 2

config_json = Path(sys.argv[1])
assert config_json.is_file()

# parent = config_json.parent

with open(config_json, "r") as f:
    config = json.load(f)
# rtl_files = [(str(parent), str(f.split("::", 1)[1])) for f in config["VERILOG_FILES"]]
rtl_files = [str(f.split("::", 1)[1]) for f in config["VERILOG_FILES"]]
# print("\n".join(map(lambda x: " ".join(x), rtl_files)))
print("\n".join(rtl_files))
