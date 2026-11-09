/* Negative control: explicitly fail through the simulation exit-status port. */
.section .text.start,"ax",@progbits
.globl _start
_start:
li t0, 0x60000018
li t1, 7
sw t1, 0(t0)
1: j 1b
