#!/usr/bin/env python3
"""Preserve synthesis results outside disposable work directories."""

import argparse
import hashlib
import json
from pathlib import Path
import shutil
import tarfile


def preserve(source, output, variants, baseline_dir=None):
    output.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source / "metrics.csv", output / "metrics.csv")
    manifest = {}
    for variant in variants:
        src = baseline_dir if variant == "baseline" and baseline_dir else source / variant
        dst = output / variant
        dst.mkdir(exist_ok=True)
        meta = json.loads((src / "execution.json").read_text())
        if not meta.get("passed"):
            raise ValueError(f"Cannot preserve failed synthesis: {src}")
        for name in [
            "execution.json",
            "metrics.json",
            "metrics.csv",
            "config.json",
            "sources.txt",
            "synthesize.tcl",
            "constraints.tcl",
            "constraints.sdc",
            "version.log",
            "tool.log",
        ]:
            if (src / name).is_file() and (src / name).resolve() != (dst / name).resolve():
                shutil.copyfile(src / name, dst / name)
        # Include final views and native synthesis/STA reports, not temporary
        # liberty caches or intermediate elaboration/optimization trees.
        chosen = []
        if (src / "runs/asip").is_dir():
            run = src / "runs/asip"
            chosen += list((run / "final").rglob("*"))
            chosen += [run / "resolved.json", run / "warning.log", run / "error.log"]
            for sta in run.glob("*-openroad-staprepnr"):
                chosen += list(sta.rglob("*"))
            for synth in run.glob("*-yosys-synthesis"):
                chosen += [synth / "yosys-synthesis.log", synth / "reports/stat.json"]
        else:
            chosen += list((src / "out").glob("*")) + list((src / "log").glob("*"))
        if (src / "artifacts.tar.gz").is_file() and not chosen:
            if (src / "artifacts.tar.gz").resolve() != (dst / "artifacts.tar.gz").resolve():
                shutil.copyfile(src / "artifacts.tar.gz", dst / "artifacts.tar.gz")
        else:
            with tarfile.open(dst / "artifacts.tar.gz", "w:gz") as archive:
                for p in sorted(set(chosen)):
                    if p.is_file():
                        archive.add(p, arcname=p.relative_to(src))
        manifest[variant] = {
            "tool": meta.get("tool", "synopsys"),
            "pdk": meta.get("pdk"),
            "sha256": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in dst.iterdir() if p.is_file()},
        }
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("source", type=Path)
    p.add_argument("output", type=Path)
    p.add_argument("variants", nargs="+")
    p.add_argument("--baseline-dir", type=Path)
    a = p.parse_args()
    if a.source.resolve() == a.output.resolve():
        p.error("Evidence output must differ from the work directory")
    preserve(a.source, a.output, a.variants, a.baseline_dir)


if __name__ == "__main__":
    main()
