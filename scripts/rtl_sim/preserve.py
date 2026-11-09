#!/usr/bin/env python3
"""Preserve selected RTL execution evidence outside disposable simulator builds."""

import argparse
from pathlib import Path
import shutil


def preserve(source, destination, variants):
    source, destination = source.resolve(), destination.resolve()
    if source == destination:
        return
    destination.mkdir(parents=True, exist_ok=True)
    names = ["summary.json", "metrics.csv"]
    for variant in variants:
        names.append(f"{variant}-build.log")
        names += [
            f"{variant}/{name}"
            for name in (
                "execution.json",
                "uart.log",
                "compile.log",
                "instruction-selector.json",
                "firmware/build.json",
                "firmware/benchmark.elf",
                "firmware/benchmark.bin",
            )
        ]
    for name in names:
        path = source / name
        if path.is_file():
            target = destination / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(path, target)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    parser.add_argument("variants", nargs="+")
    args = parser.parse_args()
    preserve(args.source, args.destination, args.variants)


if __name__ == "__main__":
    main()
