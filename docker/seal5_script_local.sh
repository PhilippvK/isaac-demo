#!/bin/bash
# Local retargeting: LLVM_MAJOR=19|20|21|22, defaults to the existing LLVM19 path.
set -euo pipefail
if (( $# < 2 )); then
    echo "Usage: $0 DEST MODEL.core_desc [CONFIG.yml ...]" >&2
    exit 2
fi
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TOP_DIR=$(dirname "$SCRIPT_DIR")
DEST=$(realpath -m -- "$1")
shift
GEN_CDSL_FILES=()
GEN_CFG_FILES=()
for file in "$@"; do
    file=$(realpath -- "$file")
    case "$file" in
        *.core_desc) GEN_CDSL_FILES+=("$file") ;;
        *) GEN_CFG_FILES+=("$file") ;;
    esac
done
(( ${#GEN_CDSL_FILES[@]} )) || { echo "No CoreDSL input supplied" >&2; exit 2; }
LLVM_MAJOR=${LLVM_MAJOR:-19}
case "$LLVM_MAJOR" in
    19) DEFAULT_REF=isaac-llvm19.1.7; DEFAULT_SOURCE="$TOP_DIR/llvm-project" ;;
    20) DEFAULT_REF=llvmorg-20.1.8; DEFAULT_SOURCE=https://github.com/llvm/llvm-project.git ;;
    21) DEFAULT_REF=llvmorg-21.1.8; DEFAULT_SOURCE=https://github.com/llvm/llvm-project.git ;;
    22) DEFAULT_REF=llvmorg-22.1.8; DEFAULT_SOURCE="$TOP_DIR/llvm-project-22" ;;
    *) echo "Unsupported LLVM_MAJOR=$LLVM_MAJOR (expected 19–22)" >&2; exit 2 ;;
esac
export SEAL5_DIR=${SEAL5_DIR:-$TOP_DIR/seal5}
export SEAL5_M2ISAR_DIR=${SEAL5_M2ISAR_DIR:-${M2ISAR_DIR:-$TOP_DIR/M2-ISA-R}}
# Current Seal5 uses the typed M2-ISA-R model API.
export PYTHONPATH="$SEAL5_DIR:$SEAL5_M2ISAR_DIR${PYTHONPATH:+:$PYTHONPATH}"
export SEAL5_HOME=${SEAL5_HOME:-$TOP_DIR/tmp/seal5_local_llvm$LLVM_MAJOR}
if [[ "$LLVM_MAJOR" == 22 && ! -e "$DEFAULT_SOURCE/.git" ]]; then
    DEFAULT_SOURCE=https://github.com/llvm/llvm-project.git
fi
LLVM_REPO=${LLVM_REPO:-$DEFAULT_SOURCE}
LLVM_REF=${LLVM_REF:-$DEFAULT_REF}
SEAL5_CFG_DIR=${SEAL5_CFG_DIR:-$TOP_DIR/cfg/seal5}
CLONE_DEPTH=${CLONE_DEPTH:-2}
ENABLE_CDFG_PASS=${ENABLE_CDFG_PASS:-1}
CCACHE=${CCACHE:-0}
CLEANUP=${CLEANUP:-0}
RESET=${RESET:-1}
VERBOSE=${VERBOSE:-1}
REDUCED=${REDUCED:-1}
INSTALL=${INSTALL:-1}
DEPLOY=${DEPLOY:-0}
EXPORT=${EXPORT:-1}
TEST=${TEST:-1}
export CCACHE_DIR=${CCACHE_DIR:-$TOP_DIR/install/ccache}
export SEAL5_NUM_THREADS=${SEAL5_NUM_THREADS:-4}
export SEAL5_BUILD_THREADS=${SEAL5_BUILD_THREADS:-4}
mkdir -p "$DEST/seal5_reports"
# Save a durable log even if compilation or a generated test fails.
exec > >(tee -a "$DEST/seal5_reports/local-retarget.log") 2>&1
seal5_cmd=(python3 -m seal5.cli.main --dir "$SEAL5_HOME")
[[ "$VERBOSE" == 1 ]] && seal5_cmd+=(--verbose)
seal5_run() { "${seal5_cmd[@]}" "$@"; }
build_args=()
[[ "$CCACHE" == 1 ]] && build_args+=(--ccache)
cmake_args="-DENABLE_CDFG_PASS=$([[ "$ENABLE_CDFG_PASS" == 1 ]] && echo ON || echo OFF)"
# Use the same complete Python runtime as Seal5; CMake may otherwise pick a
# vendor-bundled interpreter with an incomplete standard library.
seal5_python=$(python3 -c 'import sys, xml.sax.saxutils; print(sys.executable)')
cmake_args+=",-DPython3_EXECUTABLE='$seal5_python'"
[[ -n "${MGCLIENT_ROOT:-}" ]] && cmake_args+=",-DMGCLIENT_ROOT='$MGCLIENT_ROOT'"
[[ -n "${CMAKE_EXTRA_ARGS:-}" ]] && cmake_args+=",$CMAKE_EXTRA_ARGS"
build_args+=("--cmake-extra-args=$cmake_args")
[[ "$REDUCED" == 1 ]] && build_args+=(--reduced)
# Resume the same inputs at a recorded checkpoint without replacing settings.
SEAL5_START_AT=${SEAL5_START_AT:-setup}
case "$SEAL5_START_AT" in
    setup) START_INDEX=0 ;; models) START_INDEX=1 ;; build-tools) START_INDEX=2 ;;
    patterns) START_INDEX=3 ;; build-final) START_INDEX=4 ;; test) START_INDEX=5 ;;
    export) START_INDEX=6 ;; reports) START_INDEX=7 ;;
    *) echo "Unknown SEAL5_START_AT=$SEAL5_START_AT" >&2; exit 2 ;;
esac
if (( START_INDEX > 0 )); then
    [[ "$RESET" == 0 && -f "$SEAL5_HOME/.seal5/settings.yml" ]] || {
        echo "Resuming requires RESET=0 and an initialized SEAL5_HOME" >&2; exit 2;
    }
fi
if (( START_INDEX == 0 )); then
    if [[ "$RESET" == 1 && -d "$SEAL5_HOME/.seal5" ]]; then
        seal5_run reset --settings
        seal5_run clean --temp --patches --models --inputs
    fi
    if [[ ! -d "$SEAL5_HOME/.seal5" || "$RESET" == 1 ]]; then
        seal5_run init --non-interactive --clone --clone-url "$LLVM_REPO" --clone-ref "$LLVM_REF" --clone-depth "$CLONE_DEPTH" --force
    fi
fi
cd "$TOP_DIR"
if (( START_INDEX == 0 )); then
    # Work from the repository root so relative manual patch files resolve reliably.
    seal5_run load --overwrite --files "$SEAL5_CFG_DIR"/*.yml
    if (( ${#GEN_CFG_FILES[@]} )); then
        seal5_run load --overwrite --files "${GEN_CFG_FILES[@]}"
    fi
    # Keep the version and PatternGen selection paired, after the shared defaults.
    seal5_run load --overwrite --files "$SEAL5_CFG_DIR/versions/llvm$LLVM_MAJOR.yml"
    seal5_run setup
    seal5_run patch -s 0
fi
if [[ "$ENABLE_CDFG_PASS" == 1 && ! -f "$SEAL5_HOME/llvm/lib/CodeGen/GlobalISel/CDFGPass.cpp" ]]; then
    echo "This LLVM source has no CDFG pass. Supply a patched LLVM_REPO/LLVM_REF or set ENABLE_CDFG_PASS=0 for retargeting without CDFG export." >&2
    exit 1
fi
# No baseline compiler build is needed: generation consumes the stage-2 tools.
if (( START_INDEX <= 1 )); then
    seal5_run load --files "${GEN_CDSL_FILES[@]}"
    seal5_run transform
    seal5_run generate --skip pattern_gen
    seal5_run patch -s 1 2
fi
if (( START_INDEX <= 2 )); then
    seal5_run build -t pattern-gen "${build_args[@]}"
    seal5_run build -t llc "${build_args[@]}"
fi
if (( START_INDEX <= 3 )); then
    seal5_run generate --only pattern_gen
    seal5_run patch -s 3 4 5
fi
if (( START_INDEX <= 4 )); then
    seal5_run build "${build_args[@]}"
fi
if (( START_INDEX <= 5 )) && [[ "$TEST" == 1 ]]; then
    seal5_run test
fi
if (( START_INDEX <= 6 )); then
    [[ "$INSTALL" != 1 ]] || seal5_run install --dest "$DEST/llvm_install" "${build_args[@]}"
    [[ "$DEPLOY" != 1 ]] || seal5_run deploy --dest "$DEST/llvm_source.zip"
    [[ "$EXPORT" != 1 ]] || seal5_run export --dest "$DEST/seal5.tar.gz"
fi
models=("$SEAL5_HOME"/.seal5/models/*.seal5model)
settings="$SEAL5_HOME/.seal5/settings.yml"
python3 -m seal5.backends.report.properties.writer "${models[@]}" --output "$DEST/seal5_reports/properties.csv"
for compact in 0 1; do
    suffix=""; args=()
    if [[ "$compact" == 1 ]]; then suffix=_compact; args=(--compact); fi
    python3 -m seal5.backends.report.status.writer "${models[@]}" --yaml "$settings" "${args[@]}" --output "$DEST/seal5_reports/status$suffix.csv"
    python3 -m seal5.backends.report.test_results.writer "${models[@]}" --yaml "$settings" "${args[@]}" --output "$DEST/seal5_reports/test_results$suffix.csv" --coverage "$DEST/seal5_reports/test_coverage$suffix.csv"
done
python3 -m seal5.backends.report.diff.writer --yaml "$settings" --output "$DEST/seal5_reports/diff.csv"
python3 -m seal5.backends.report.times.writer --yaml "$settings" --pass-times --output "$DEST/seal5_reports/stage_times.csv" --sum-level 2
if [[ "$CLEANUP" == 1 ]]; then
    # Explicit opt-in, only after exports and reports have completed.
    rm -rf -- "$SEAL5_HOME"
fi
