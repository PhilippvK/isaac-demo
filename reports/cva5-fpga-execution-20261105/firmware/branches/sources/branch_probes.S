.text
.macro branch_probe name, funct
.balign 4
.globl probe_\name
probe_\name:
 .insn b 0x0b, \funct, a0, a1, 1f
 li a0, 0
 ret
1: li a0, 1
 ret
.balign 4
.globl back_\name
back_\name:
 j 2f
1: li a0, 1
 ret
2: .insn b 0x0b, \funct, a0, a1, 1b
 li a0, 0
 ret
.endm
branch_probe beq, 0
branch_probe bne, 5
branch_probe blt, 6
branch_probe bge, 4
branch_probe bltu, 1
branch_probe bgeu, 2
