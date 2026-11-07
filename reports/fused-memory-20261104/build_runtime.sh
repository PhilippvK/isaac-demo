#!/bin/bash
set -eo pipefail
source scripts/env.sh
root=$PWD/reports/fused-memory-20261104
tools=$root/compiler/llvm_install/bin
cc=$tools/clang
flags=(--target=riscv32 -march=rv32im_xmem -mabi=ilp32 -O2 -g -ffreestanding -fno-builtin -msmall-data-limit=0 -fno-stack-protector -fno-unroll-loops)
isel_flags=(-mllvm "-global-isel=${GLOBAL_ISEL:-0}" -mllvm -global-isel-abort=1)
"$cc" "${flags[@]}" "${isel_flags[@]}" '-DFUNC(x)=selected_##x' -c "$root/selected.c" -o "$root/selected.o"
"$cc" "${flags[@]}" "${isel_flags[@]}" -march=rv32im '-DFUNC(x)=native_##x' -c "$root/selected.c" -o "$root/native.o"
"$cc" "${flags[@]}" "${isel_flags[@]}" -march=rv32im -c "$root/harness.c" -o "$root/harness.o"
"$cc" "${flags[@]}" -c "$root/start.S" -o "$root/start.o"
"$tools/ld.lld" -m elf32lriscv -T "$root/link.ld" "$root/start.o" "$root/harness.o" "$root/selected.o" "$root/native.o" -o "$root/memory-tests.elf"
"$tools/llvm-objdump" -d --mattr=+xmem,+c "$root/memory-tests.elf" > "$root/memory-tests.dump"
