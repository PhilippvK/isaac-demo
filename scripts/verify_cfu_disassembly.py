#!/usr/bin/env python3
"""Audit CUSTOM0 machine words in an objdump instruction disassembly.

This checks static compiler output, not dynamic execution or operation semantics.
Use objdump -d output, not data-inclusive -D output.
"""

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re

from isaac_toolkit.generate.iss.cfu import CFUEncoder


def verify(dump, manifest, expect_custom=True):
    ledger = CFUEncoder(manifest, allow_new=False).data["instructions"]
    by_id = {entry["function_id"]: (name, entry) for name, entry in ledger.items()}
    counts = Counter()
    sites = []
    text = dump.read_text()
    if "Disassembly of section" not in text:
        raise ValueError("Expected objdump instruction disassembly")
    for line in text.splitlines():
        match = re.match(r"^\s*([0-9a-fA-F]+):\s+([0-9a-fA-F]{8})\s+", line)
        if not match:
            continue
        address, encoded = match.groups()
        word = int(encoded, 16)
        if word & 0x7f != 0x0b:
            continue
        function_id = ((word >> 25) << 3) | ((word >> 12) & 7)
        if function_id not in by_id:
            raise ValueError(f"Unallocated CFU function ID {function_id} at 0x{address}")
        name, entry = by_id[function_id]
        if word & entry["mask"] != entry["code"]:
            raise ValueError(f"Invalid fixed fields for {name} at 0x{address}")
        counts[name] += 1
        sites.append({"address": f"0x{address}", "word": f"0x{word:08x}",
                      "instruction": name, "function_id": function_id,
                      "rd": (word >> 7) & 31, "rs1": (word >> 15) & 31,
                      "rs2": (word >> 20) & 31})
    if bool(sites) != expect_custom:
        raise ValueError("Expected custom instructions" if expect_custom else
                         "Baseline unexpectedly contains custom instructions")
    return {"static_encoding_validation": "passed", "disassembly": str(dump.resolve()),
            "disassembly_sha256": hashlib.sha256(dump.read_bytes()).hexdigest(),
            "manifest": str(manifest.resolve()),
            "manifest_sha256": hashlib.sha256(manifest.read_bytes()).hexdigest(),
            "static_custom_instruction_count": len(sites),
            "instruction_counts": dict(counts), "sites": sites,
            "execution_validation": "not checked by this verifier"}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dump", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--baseline", action="store_true")
    args = parser.parse_args()
    report = verify(args.dump, args.manifest, expect_custom=not args.baseline)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(f"Verified {report['static_custom_instruction_count']} static CFU instructions")
