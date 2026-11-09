#!/usr/bin/env python3
"""Install the version-controlled native Nailgun runtime into an MLIF checkout."""

import argparse
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
p = argparse.ArgumentParser(description=__doc__)
p.add_argument("mlif", type=Path)
p.add_argument("--environment", type=Path)
a = p.parse_args()
patch = root / "cfg/mlif/nailgun.patch"
cmd = ["git", "-C", str(a.mlif.resolve()), "apply"]
forward = subprocess.run([*cmd, "--check", str(patch)], capture_output=True, text=True)
if forward.returncode == 0:
    subprocess.run([*cmd, str(patch)], check=True)
    print("Installed native Nailgun MLIF target")
elif (
    subprocess.run(
        [*cmd, "--reverse", "--check", str(patch)], capture_output=True
    ).returncode
    == 0
):
    print("Native Nailgun MLIF target already installed")
else:
    raise SystemExit(
        "MLIF checkout differs from the supported patch; review before applying:\n"
        + forward.stderr
    )

if a.environment:
    import yaml

    text = a.environment.read_text()
    settings = yaml.safe_load(text)
    if "nailgun" not in settings.get("targets", {}):
        if text.count("\ntargets:\n") != 1:
            raise SystemExit("Cannot locate unique targets section in environment")
        text = text.replace(
            "\ntargets:\n", "\ntargets:\n  nailgun:\n    enabled: true\n", 1
        )
        a.environment.write_text(text)
        print("Enabled nailgun target in", a.environment)
