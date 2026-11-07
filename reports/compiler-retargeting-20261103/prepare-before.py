"""Prepare one LLVM job from a pristine image baseline, retaining build caches."""
import argparse
import os
import pickle
import shutil
import subprocess
from pathlib import Path


def validate_models(directory):
    models = sorted(Path(directory).glob("*.seal5model"))
    if not models:
        raise RuntimeError("No SEAL5 models were generated from the uploaded CoreDSL")
    for path in models:
        with path.open("rb") as handle:
            model = pickle.load(handle)
        instructions = sum(len(item.instructions) for item in model.sets.values())
        if not instructions:
            raise RuntimeError(
                f"No instructions remain in {path.stem} after filtering. "
                "Check filter.sets, filter.instructions, filter.opcodes and "
                "filter.encoding_sizes (sizes are in bits; use 32, not 3)."
            )
        print(f"SEAL5 preflight: {path.stem}: {instructions} instruction(s)", flush=True)


def prepare(home, inputs, baseline):
    home, inputs, baseline = Path(home), Path(inputs), Path(baseline)
    if not baseline.is_file():
        raise RuntimeError(f"Missing pristine SEAL5 baseline: {baseline}")
    files = sorted(inputs.glob("*.core_desc"))
    if not files:
        raise RuntimeError("LLVM requires at least one .core_desc input")
    config = inputs / "config.yaml"
    if not config.is_file():
        raise RuntimeError("LLVM requires config.yaml")
    meta = home / ".seal5"
    # Restore all settings, including CMake options and install paths. A reset
    # alone retains some settings; cleanup at the end never runs after a failure.
    shutil.copyfile(baseline, meta / "settings.yml")
    subprocess.run(["git", "-C", str(home), "reset", "--hard", "seal5-default-stage0"], check=True)
    command = ["seal5", "--dir", str(home)]
    subprocess.run(command + ["clean", "--inputs", "--models", "--temp", "--patches"], check=True)
    subprocess.run(command + ["load", "--files", *map(str, files)], check=True)
    # Uploaded settings must override the baked-in defaults, rather than union
    # their filter lists with defaults that can hide invalid inputs on run one.
    subprocess.run(command + ["load", "--overwrite", "--files", str(config)], check=True)
    # Older baked-in baselines predate the supported-immediate inventory.
    from seal5.settings import Seal5Settings
    from seal5.tools.llvm import detect_llvm_imm_types
    settings = Seal5Settings.from_yaml_file(meta / "settings.yml")
    if settings.llvm.state.supported_imm_types is None:
        settings.llvm.state.supported_imm_types = sorted(detect_llvm_imm_types(home))
    settings.save()
    subprocess.run(command + ["transform"], check=True)
    validate_models(meta / "models")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("inputs")
    parser.add_argument("--home", default=os.getenv("SEAL5_HOME", "/work/llvm"))
    parser.add_argument("--baseline", default="/opt/seal5-baseline.yml")
    args = parser.parse_args()
    prepare(args.home, args.inputs, args.baseline)
