#!/usr/bin/env python3
"""Download pinned open libraries and compile local Design Compiler databases."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import urllib.request

REVISION = "a47d4fdc6534cb3cdfdd9ff76737a899a5bb2ee0"
LIBRARIES = {
    "nangate45": (
        "NangateOpenCellLibrary_typical.lib",
        "8d540a4d4cf6d09d27c87ad067857a9c0c2eeb023ab7a56e058cd3113db4e9b1",
    ),
    "sky130hd": (
        "sky130_fd_sc_hd__tt_025C_1v80.lib",
        "ec0e1067a35c8bf20b11e58d1e8ac53326067e4dac84a125cc1b917a3518d0d9",
    ),
}


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def prepare(pdk, output, lc_shell):
    filename, digest = LIBRARIES[pdk]
    directory = output.resolve() / pdk
    directory.mkdir(parents=True, exist_ok=True)
    liberty = directory / filename
    url = f"https://raw.githubusercontent.com/The-OpenROAD-Project/OpenROAD-flow-scripts/{REVISION}/flow/platforms/{pdk}/lib/{filename}"
    if not liberty.exists():
        with urllib.request.urlopen(url, timeout=120) as response:
            liberty.write_bytes(response.read())
    if sha(liberty) != digest:
        raise ValueError(f"Liberty checksum mismatch: {liberty}")
    db = liberty.with_suffix(".db")
    db.unlink(missing_ok=True)
    env = dict(os.environ, ASIP_LIBERTY=str(liberty), ASIP_DB=str(db))
    command = [lc_shell, "-f", str(Path(__file__).with_name("compile_library.tcl").resolve())]
    log = directory / "compile.log"
    with log.open("w") as stream:
        result = subprocess.run(command, env=env, cwd=directory, stdout=stream, stderr=subprocess.STDOUT, timeout=300)
    text = log.read_text(errors="replace")
    # The installed LC emits a CLE-100 message during startup even on successful
    # imports. Retain it; validate the conversion result rather than hide it.
    errors = [
        line
        for line in text.splitlines()
        if line.startswith("Error:") and "Message for 'CLE-100' not found" not in line
    ]
    if result.returncode or errors or "ASIP_LIBRARY_COMPLETE\n" not in text or not db.exists():
        raise RuntimeError(f"Library conversion failed; see {log}")
    version = re.search(r"Version ([^\n]+)", text)
    meta = {
        "pdk": pdk,
        "source": url,
        "revision": REVISION,
        "liberty_sha256": digest,
        "db_sha256": sha(db),
        "lc_shell": lc_shell,
        "version": version.group(1).strip() if version else None,
    }
    (directory / "manifest.json").write_text(json.dumps(meta, indent=2) + "\n")
    print(json.dumps(meta, indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pdk", choices=LIBRARIES, default="nangate45")
    parser.add_argument("--output", type=Path, default=Path("install/asip-libs"))
    parser.add_argument("--lc-shell", default=os.environ.get("ASIP_SYN_LC_SHELL", "lc_shell"))
    args = parser.parse_args()
    prepare(args.pdk, args.output, args.lc_shell)


if __name__ == "__main__":
    main()
