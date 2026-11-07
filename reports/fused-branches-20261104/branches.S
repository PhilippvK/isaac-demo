.text
.option norvc
.balign 4
.global asm_BEQ_forward
.type asm_BEQ_forward,@function
asm_BEQ_forward:
.Lstart_asm_BEQ_forward:
fused_beq a0,a1,.Ltrue_asm_BEQ_forward
li a0,0
ret
.Ltrue_asm_BEQ_forward:
li a0,1
ret
.size asm_BEQ_forward,.-asm_BEQ_forward
.balign 4
.global asm_BEQ_backward
.type asm_BEQ_backward,@function
asm_BEQ_backward:
j .Ltest_asm_BEQ_backward
.Ltrue_asm_BEQ_backward:
li a0,1
ret
.Ltest_asm_BEQ_backward:
fused_beq a0,a1,.Ltrue_asm_BEQ_backward
li a0,0
ret
.size asm_BEQ_backward,.-asm_BEQ_backward
.balign 4
.global asm_BEQ_p4094
.type asm_BEQ_p4094,@function
asm_BEQ_p4094:
.Lstart_asm_BEQ_p4094:
fused_beq a0,a1,.Ltrue_asm_BEQ_p4094
li a0,0
ret
.space 4094-(.-.Lstart_asm_BEQ_p4094),0
.Ltrue_asm_BEQ_p4094:
li a0,1
ret
.size asm_BEQ_p4094,.-asm_BEQ_p4094
.balign 4
.global asm_BEQ_m4096
.type asm_BEQ_m4096,@function
asm_BEQ_m4096:
j .Ltest_asm_BEQ_m4096
.Ltrue_asm_BEQ_m4096:
li a0,1
ret
.space 4096-(.-.Ltrue_asm_BEQ_m4096),0
.Ltest_asm_BEQ_m4096:
fused_beq a0,a1,.Ltrue_asm_BEQ_m4096
li a0,0
ret
.size asm_BEQ_m4096,.-asm_BEQ_m4096
.balign 4
.global asm_BNE_forward
.type asm_BNE_forward,@function
asm_BNE_forward:
.Lstart_asm_BNE_forward:
fused_bne a0,a1,.Ltrue_asm_BNE_forward
li a0,0
ret
.Ltrue_asm_BNE_forward:
li a0,1
ret
.size asm_BNE_forward,.-asm_BNE_forward
.balign 4
.global asm_BNE_backward
.type asm_BNE_backward,@function
asm_BNE_backward:
j .Ltest_asm_BNE_backward
.Ltrue_asm_BNE_backward:
li a0,1
ret
.Ltest_asm_BNE_backward:
fused_bne a0,a1,.Ltrue_asm_BNE_backward
li a0,0
ret
.size asm_BNE_backward,.-asm_BNE_backward
.balign 4
.global asm_BNE_p4094
.type asm_BNE_p4094,@function
asm_BNE_p4094:
.Lstart_asm_BNE_p4094:
fused_bne a0,a1,.Ltrue_asm_BNE_p4094
li a0,0
ret
.space 4094-(.-.Lstart_asm_BNE_p4094),0
.Ltrue_asm_BNE_p4094:
li a0,1
ret
.size asm_BNE_p4094,.-asm_BNE_p4094
.balign 4
.global asm_BNE_m4096
.type asm_BNE_m4096,@function
asm_BNE_m4096:
j .Ltest_asm_BNE_m4096
.Ltrue_asm_BNE_m4096:
li a0,1
ret
.space 4096-(.-.Ltrue_asm_BNE_m4096),0
.Ltest_asm_BNE_m4096:
fused_bne a0,a1,.Ltrue_asm_BNE_m4096
li a0,0
ret
.size asm_BNE_m4096,.-asm_BNE_m4096
.balign 4
.global asm_BLT_forward
.type asm_BLT_forward,@function
asm_BLT_forward:
.Lstart_asm_BLT_forward:
fused_blt a0,a1,.Ltrue_asm_BLT_forward
li a0,0
ret
.Ltrue_asm_BLT_forward:
li a0,1
ret
.size asm_BLT_forward,.-asm_BLT_forward
.balign 4
.global asm_BLT_backward
.type asm_BLT_backward,@function
asm_BLT_backward:
j .Ltest_asm_BLT_backward
.Ltrue_asm_BLT_backward:
li a0,1
ret
.Ltest_asm_BLT_backward:
fused_blt a0,a1,.Ltrue_asm_BLT_backward
li a0,0
ret
.size asm_BLT_backward,.-asm_BLT_backward
.balign 4
.global asm_BLT_p4094
.type asm_BLT_p4094,@function
asm_BLT_p4094:
.Lstart_asm_BLT_p4094:
fused_blt a0,a1,.Ltrue_asm_BLT_p4094
li a0,0
ret
.space 4094-(.-.Lstart_asm_BLT_p4094),0
.Ltrue_asm_BLT_p4094:
li a0,1
ret
.size asm_BLT_p4094,.-asm_BLT_p4094
.balign 4
.global asm_BLT_m4096
.type asm_BLT_m4096,@function
asm_BLT_m4096:
j .Ltest_asm_BLT_m4096
.Ltrue_asm_BLT_m4096:
li a0,1
ret
.space 4096-(.-.Ltrue_asm_BLT_m4096),0
.Ltest_asm_BLT_m4096:
fused_blt a0,a1,.Ltrue_asm_BLT_m4096
li a0,0
ret
.size asm_BLT_m4096,.-asm_BLT_m4096
.balign 4
.global asm_BGE_forward
.type asm_BGE_forward,@function
asm_BGE_forward:
.Lstart_asm_BGE_forward:
fused_bge a0,a1,.Ltrue_asm_BGE_forward
li a0,0
ret
.Ltrue_asm_BGE_forward:
li a0,1
ret
.size asm_BGE_forward,.-asm_BGE_forward
.balign 4
.global asm_BGE_backward
.type asm_BGE_backward,@function
asm_BGE_backward:
j .Ltest_asm_BGE_backward
.Ltrue_asm_BGE_backward:
li a0,1
ret
.Ltest_asm_BGE_backward:
fused_bge a0,a1,.Ltrue_asm_BGE_backward
li a0,0
ret
.size asm_BGE_backward,.-asm_BGE_backward
.balign 4
.global asm_BGE_p4094
.type asm_BGE_p4094,@function
asm_BGE_p4094:
.Lstart_asm_BGE_p4094:
fused_bge a0,a1,.Ltrue_asm_BGE_p4094
li a0,0
ret
.space 4094-(.-.Lstart_asm_BGE_p4094),0
.Ltrue_asm_BGE_p4094:
li a0,1
ret
.size asm_BGE_p4094,.-asm_BGE_p4094
.balign 4
.global asm_BGE_m4096
.type asm_BGE_m4096,@function
asm_BGE_m4096:
j .Ltest_asm_BGE_m4096
.Ltrue_asm_BGE_m4096:
li a0,1
ret
.space 4096-(.-.Ltrue_asm_BGE_m4096),0
.Ltest_asm_BGE_m4096:
fused_bge a0,a1,.Ltrue_asm_BGE_m4096
li a0,0
ret
.size asm_BGE_m4096,.-asm_BGE_m4096
.balign 4
.global asm_BLTU_forward
.type asm_BLTU_forward,@function
asm_BLTU_forward:
.Lstart_asm_BLTU_forward:
fused_bltu a0,a1,.Ltrue_asm_BLTU_forward
li a0,0
ret
.Ltrue_asm_BLTU_forward:
li a0,1
ret
.size asm_BLTU_forward,.-asm_BLTU_forward
.balign 4
.global asm_BLTU_backward
.type asm_BLTU_backward,@function
asm_BLTU_backward:
j .Ltest_asm_BLTU_backward
.Ltrue_asm_BLTU_backward:
li a0,1
ret
.Ltest_asm_BLTU_backward:
fused_bltu a0,a1,.Ltrue_asm_BLTU_backward
li a0,0
ret
.size asm_BLTU_backward,.-asm_BLTU_backward
.balign 4
.global asm_BLTU_p4094
.type asm_BLTU_p4094,@function
asm_BLTU_p4094:
.Lstart_asm_BLTU_p4094:
fused_bltu a0,a1,.Ltrue_asm_BLTU_p4094
li a0,0
ret
.space 4094-(.-.Lstart_asm_BLTU_p4094),0
.Ltrue_asm_BLTU_p4094:
li a0,1
ret
.size asm_BLTU_p4094,.-asm_BLTU_p4094
.balign 4
.global asm_BLTU_m4096
.type asm_BLTU_m4096,@function
asm_BLTU_m4096:
j .Ltest_asm_BLTU_m4096
.Ltrue_asm_BLTU_m4096:
li a0,1
ret
.space 4096-(.-.Ltrue_asm_BLTU_m4096),0
.Ltest_asm_BLTU_m4096:
fused_bltu a0,a1,.Ltrue_asm_BLTU_m4096
li a0,0
ret
.size asm_BLTU_m4096,.-asm_BLTU_m4096
.balign 4
.global asm_BGEU_forward
.type asm_BGEU_forward,@function
asm_BGEU_forward:
.Lstart_asm_BGEU_forward:
fused_bgeu a0,a1,.Ltrue_asm_BGEU_forward
li a0,0
ret
.Ltrue_asm_BGEU_forward:
li a0,1
ret
.size asm_BGEU_forward,.-asm_BGEU_forward
.balign 4
.global asm_BGEU_backward
.type asm_BGEU_backward,@function
asm_BGEU_backward:
j .Ltest_asm_BGEU_backward
.Ltrue_asm_BGEU_backward:
li a0,1
ret
.Ltest_asm_BGEU_backward:
fused_bgeu a0,a1,.Ltrue_asm_BGEU_backward
li a0,0
ret
.size asm_BGEU_backward,.-asm_BGEU_backward
.balign 4
.global asm_BGEU_p4094
.type asm_BGEU_p4094,@function
asm_BGEU_p4094:
.Lstart_asm_BGEU_p4094:
fused_bgeu a0,a1,.Ltrue_asm_BGEU_p4094
li a0,0
ret
.space 4094-(.-.Lstart_asm_BGEU_p4094),0
.Ltrue_asm_BGEU_p4094:
li a0,1
ret
.size asm_BGEU_p4094,.-asm_BGEU_p4094
.balign 4
.global asm_BGEU_m4096
.type asm_BGEU_m4096,@function
asm_BGEU_m4096:
j .Ltest_asm_BGEU_m4096
.Ltrue_asm_BGEU_m4096:
li a0,1
ret
.space 4096-(.-.Ltrue_asm_BGEU_m4096),0
.Ltest_asm_BGEU_m4096:
fused_bgeu a0,a1,.Ltrue_asm_BGEU_m4096
li a0,0
ret
.size asm_BGEU_m4096,.-asm_BGEU_m4096
