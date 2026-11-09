.section .text.start,"ax",@progbits
.globl _start
_start:
.option push
.option norelax
la gp, __global_pointer$
.option pop
la sp, __stack_top
csrw mie, zero
la t0, trap_entry
csrw mtvec, t0
la t0, __bss_start
la t1, __bss_end
1: bgeu t0, t1, 2f
sw zero, 0(t0)
addi t0, t0, 4
j 1b
2: call main
#ifdef ISAAC_RTL_SIM_EXIT
li t0, 0x60000018
sw a0, 0(t0)
#endif
3: j 3b
.balign 4
trap_entry:
csrr a0, mcause
csrr a1, mepc
csrr a2, mtval
tail trap_report
