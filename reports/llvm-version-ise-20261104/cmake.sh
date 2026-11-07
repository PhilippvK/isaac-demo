#!/bin/bash
if [[ -d "${1:-}" ]]; then
 exec /usr/bin/cmake "$@" -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY -DCMAKE_C_FLAGS=--target=riscv32 -DCMAKE_CXX_FLAGS=--target=riscv32
fi
exec /usr/bin/cmake "$@"
