#!/bin/bash

set -e

DIR=$(readlink -f $1)
DATE=$(basename $DIR)
BENCH=$(basename $(dirname $DIR))

echo DIR=$DIR DATE=$DATE BENCH=$BENCH

RUN=$DIR/run
SESS=$DIR/sess
WORK=$DIR/work

python3 $SCRIPTS_DIR/gen_ci_summary.py $DIR/experiment.ini --fmt md > $DIR/ci_report.md
if [[ "${ISAAC_ENCODING_POLICY:-auto}" == "cfu" ]]
then
    cat >> "$DIR/ci_report.md" <<'EOF'

### CFU ISS evaluation

This run uses the CFU-Playground CUSTOM0 R-type interface in ETISS. Instruction
counts are ISS measurements, not VexRiscv cycle measurements or hardware speedup.
Fake-HLS selection estimates are not measured FPGA resources. Encoding checks
and persistent function IDs are recorded in `work/gen*/cfu_encoding_validation.json`
and `work/cfu_manifest.json`.
EOF
    for comparison in "$WORK"/cfu_evaluation_*/compare.csv; do
        [[ -f "$comparison" ]] || continue
        relative=${comparison#"$DIR"/}
        printf '\nCFU runner measurements: [%s](%s)\n' "$relative" "$relative" >> "$DIR/ci_report.md"
    done
    for resources in "$WORK"/cfu_evaluation_*/resource_comparison.json; do
        [[ -f "$resources" ]] || continue
        relative=${resources#"$DIR"/}
        printf '\nFPGA resource and routed timing report: [%s](%s)\n' "$relative" "$relative" >> "$DIR/ci_report.md"
    done
fi
