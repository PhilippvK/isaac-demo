.text
.option norvc
.global _start
_start:
 lui sp,0x2000
 call main
1: j 1b
