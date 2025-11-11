#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-${(%):-%N}}" )" &> /dev/null && pwd )
TOP_DIR=$(dirname $SCRIPT_DIR)
INSTALL_DIR=$TOP_DIR/install
GNU_DIR=$INSTALL_DIR/gnu
GNU_NAME=${GNU_NAME:-riscv64-unknown-elf}

echo "SCRIPT_DIR=${SCRIPT_DIR}"
echo "TOP_DIR=${TOP_DIR}"

DL_URL=${GNU_URL:-https://syncandshare.lrz.de/dl/fiWBtDLWz17RBc1Yd4VDW7/GCC/default/2023.11.27/Ubuntu/20.04/rv64imfd_lp64d_medany.tar.xz}
# DL_ARCHIVE=rv64imfd_lp64d.tar.xz

if [[ -d "$GNU_DIR/$GNU_NAME" ]]
then
    echo "Already downloaded!"
    exit 0
fi

wget $DL_URL -O gnu_dl.tar.xz
mkdir -p $GNU_DIR
tar xvf gnu_dl.tar.xz -C $GNU_DIR
rm gnu_dl.tar.xz
