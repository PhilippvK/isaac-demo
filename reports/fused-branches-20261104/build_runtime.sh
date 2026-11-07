#!/bin/bash
set -eo pipefail
source scripts/env.sh
root=$PWD/reports/fused-branches-20261104
tools=$root/compiler/llvm_install/bin
cc=$tools/clang
flags=(--target=riscv32 -march=rv32im_xbranch -mabi=ilp32 -O2 -g -ffreestanding -fno-builtin -msmall-data-limit=0 -fno-stack-protector -fno-unroll-loops)
"$cc" "${flags[@]}" '-DFUNC(x)=selected_##x' -c "$root/selected.c" -o "$root/selected.o"
"$cc" "${flags[@]}" -march=rv32im '-DFUNC(x)=native_##x' -c "$root/selected.c" -o "$root/native.o"
"$cc" "${flags[@]}" -march=rv32im -c "$root/harness.c" -o "$root/harness.o"
"$cc" "${flags[@]}" -c "$root/branches.S" -o "$root/branches.o"
"$cc" "${flags[@]}" -c "$root/start.S" -o "$root/start.o"
"$tools/ld.lld" -m elf32lriscv -T "$root/link.ld" "$root/start.o" "$root/harness.o" "$root/selected.o" "$root/native.o" "$root/far.o" "$root/branches.o" -o "$root/branch-tests.elf"
"$tools/llvm-objdump" -d --mattr=+xbranch,+c "$root/branch-tests.elf" > "$root/branch-tests.dump"
