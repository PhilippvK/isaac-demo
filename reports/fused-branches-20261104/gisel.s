	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0_xbranch1p0"
	.file	"selected.c"
	.text
	.globl	selected_BEQ                    # -- Begin function selected_BEQ
	.p2align	2
	.type	selected_BEQ,@function
selected_BEQ:                           # @selected_BEQ
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a2, 7
	and	a0, a1, a0
	bne	a0, a2, .LBB0_2
# %bb.1:                                # %if.then
	call	taken
	j	.LBB0_3
.LBB0_2:                                # %if.else
	call	missed
.LBB0_3:                                # %if.then
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	selected_BEQ, .Lfunc_end0-selected_BEQ
                                        # -- End function
	.globl	selected_BNE                    # -- Begin function selected_BNE
	.p2align	2
	.type	selected_BNE,@function
selected_BNE:                           # @selected_BNE
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a2, 7
	and	a0, a1, a0
	bne	a0, a2, .LBB1_2
# %bb.1:                                # %if.else
	call	missed
	j	.LBB1_3
.LBB1_2:                                # %if.then
	call	taken
.LBB1_3:                                # %if.then
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end1:
	.size	selected_BNE, .Lfunc_end1-selected_BNE
                                        # -- End function
	.globl	selected_BLT                    # -- Begin function selected_BLT
	.p2align	2
	.type	selected_BLT,@function
selected_BLT:                           # @selected_BLT
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a2, 7
	and	a0, a1, a0
	bge	a0, a2, .LBB2_2
# %bb.1:                                # %if.then
	call	taken
	j	.LBB2_3
.LBB2_2:                                # %if.else
	call	missed
.LBB2_3:                                # %if.then
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end2:
	.size	selected_BLT, .Lfunc_end2-selected_BLT
                                        # -- End function
	.globl	selected_BGE                    # -- Begin function selected_BGE
	.p2align	2
	.type	selected_BGE,@function
selected_BGE:                           # @selected_BGE
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a2, 6
	and	a0, a1, a0
	bge	a2, a0, .LBB3_2
# %bb.1:                                # %if.then
	call	taken
	j	.LBB3_3
.LBB3_2:                                # %if.else
	call	missed
.LBB3_3:                                # %if.then
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	selected_BGE, .Lfunc_end3-selected_BGE
                                        # -- End function
	.globl	selected_BLTU                   # -- Begin function selected_BLTU
	.p2align	2
	.type	selected_BLTU,@function
selected_BLTU:                          # @selected_BLTU
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a2, 7
	and	a0, a1, a0
	bgeu	a0, a2, .LBB4_2
# %bb.1:                                # %if.then
	call	taken
	j	.LBB4_3
.LBB4_2:                                # %if.else
	call	missed
.LBB4_3:                                # %if.then
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end4:
	.size	selected_BLTU, .Lfunc_end4-selected_BLTU
                                        # -- End function
	.globl	selected_BGEU                   # -- Begin function selected_BGEU
	.p2align	2
	.type	selected_BGEU,@function
selected_BGEU:                          # @selected_BGEU
# %bb.0:                                # %entry
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	li	a2, 6
	and	a0, a1, a0
	bgeu	a2, a0, .LBB5_2
# %bb.1:                                # %if.then
	call	taken
	j	.LBB5_3
.LBB5_2:                                # %if.else
	call	missed
.LBB5_3:                                # %if.then
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end5:
	.size	selected_BGEU, .Lfunc_end5-selected_BGEU
                                        # -- End function
	.ident	"clang version 22.1.8 (https://github.com/llvm/llvm-project.git 40a911a53abafcb3ab4fc633e533d849544fedf8)"
	.section	".note.GNU-stack","",@progbits
