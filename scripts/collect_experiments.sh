#!/bin/bash

set -e

OUT_DIR_BASE=${1:-out/}
OUT_FILE=${2:-all_experiments.csv}

if [[ ! -d $OUT_DIR_BASE ]]
then
    echo "Not a directory: $OUT_DIR_BASE"
    exit
fi

find $OUT_DIR_BASE -name "experiment.ini" | xargs -L1 dirname | xargs python3 scripts/combine_tables.py -o $OUT_FILE

echo "Exported all experiments to: $OUT_FILE"
