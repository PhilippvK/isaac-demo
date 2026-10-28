#!/usr/bin/env python3
"""Check the CFU encoding contract in artifacts consumed by ETISS and Seal5."""

import argparse
import json
from pathlib import Path
import pickle

import yaml
from m2isar.frontends.coredsl2_set.parser import parse_cdsl2_set
from m2isar.metamodel import arch
from isaac_toolkit.generate.iss.cfu import CFUEncoder, validate_candidate


def instruction_encodings(path, base_dir):
    """Compare parsed fields, including operand names, rather than text layout."""
    result = {}
    for instruction_set in parse_cdsl2_set(path, [str(base_dir)], defines={"XLEN": 32}).values():
        for instruction in instruction_set.instructions.values():
            if instruction.name in result:
                raise ValueError(f"Duplicate instructions in {path}")
            result[instruction.name] = tuple(
                ("value", field.length, field.value) if isinstance(field, arch.BitVal)
                else ("field", field.name, field.range.upper, field.range.lower, field.ty.kind)
                for field in instruction.encoding
            )
    return result


def verify(index, gen_dir, manifest, set_name, base_dir):
    encoder = CFUEncoder(manifest)
    data = yaml.safe_load(index.read_text())
    expected = {}
    for candidate in data["candidates"]:
        properties = candidate["properties"]
        validate_candidate(properties)
        name = properties["InstrName"]
        if properties.get("EncodingPolicy") != "cfu" or name in expected:
            raise ValueError(f"Invalid CFU candidate policy or duplicate name: {name}")
        expected[name] = encoder.data["instructions"][f"{set_name}.{name}"]
    combined_path = gen_dir / f"{set_name}.core_desc"
    combined = parse_cdsl2_set(combined_path, [str(base_dir)])[set_name]
    if set(expected) != {instr.name for instr in combined.instructions.values()}:
        raise ValueError("Candidate index and combined CoreDSL disagree")
    for instr in combined.instructions.values():
        entry = expected[instr.name]
        if (instr.code, instr.mask) != (entry["code"], entry["mask"]):
            raise ValueError(f"Combined CoreDSL disagrees with manifest: {instr.name}")
        fields = instr.encoding
        if len(fields) != 6:
            raise ValueError(f"CFU requires six R-type fields: {instr.name}")
        for position, register in ((1, "rs2"), (2, "rs1"), (4, "rd")):
            field = fields[position]
            operand = entry["operands"][register]
            if operand is None:
                valid = isinstance(field, arch.BitVal) and field.length == 5 and field.value == 0
            else:
                valid = (isinstance(field, arch.BitField) and field.name == operand
                         and field.range.upper == 4 and field.range.lower == 0)
            if not valid:
                raise ValueError(f"Incorrect CFU {register} field: {instr.name}")
    # Both combined and split files use the shared typed writer. Parse both,
    # then independently inspect the serialized split model.
    combined_texts = instruction_encodings(combined_path, base_dir)
    if (set(combined_texts) != set(expected)
            or instruction_encodings(gen_dir / f"{set_name}.splitted.core_desc", base_dir) != combined_texts):
        raise ValueError("Combined and split CoreDSL encodings disagree")
    with (gen_dir / f"{set_name}.splitted.m2isarmodel").open("rb") as handle:
        model = pickle.load(handle)
    split = [instr for s in model.sets.values() for instr in s.instructions.values()]
    if len(split) != len(expected) or {instr.name for instr in split} != set(expected):
        raise ValueError("Split model has unexpected instructions")
    for instr in split:
        entry = expected[instr.name]
        if (instr.code, instr.mask) != (entry["code"], entry["mask"]):
            raise ValueError(f"Split model disagrees with manifest: {instr.name}")
    report = {"encoding_policy": "cfu", "opcode": "0x0b", "xlen": 32,
              "active_instruction_count": len(expected),
              "allocated_function_ids": len(encoder.data["instructions"]),
              "active_function_ids": {name: entry["function_id"] for name, entry in expected.items()},
              "combined_core_dsl": str(combined_path.resolve()), "encoding_validation": "passed",
              "execution_validation": "not checked by this verifier"}
    (gen_dir / "cfu_encoding_validation.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Verified {len(expected)} CFU encodings in combined/split compiler and ISS artifacts")
    return report


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--index", type=Path, required=True)
    parser.add_argument("--gen-dir", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--set-name", default="XIsaac")
    parser.add_argument("--base-dir", type=Path, required=True)
    args = parser.parse_args()
    verify(args.index, args.gen_dir, args.manifest, args.set_name, args.base_dir)
