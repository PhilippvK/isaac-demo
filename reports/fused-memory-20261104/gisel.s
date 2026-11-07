	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0_xmem1p0"
	.file	"selected.c"
	.text
	.globl	gisel_MEM_ADDR_LB               # -- Begin function gisel_MEM_ADDR_LB
	.p2align	2
	.type	gisel_MEM_ADDR_LB,@function
gisel_MEM_ADDR_LB:                      # @gisel_MEM_ADDR_LB
# %bb.0:                                # %entry
	mem_addr_lb	a0, a0, a1
	ret
.Lfunc_end0:
	.size	gisel_MEM_ADDR_LB, .Lfunc_end0-gisel_MEM_ADDR_LB
                                        # -- End function
	.globl	gisel_MEM_ADDR_LBU              # -- Begin function gisel_MEM_ADDR_LBU
	.p2align	2
	.type	gisel_MEM_ADDR_LBU,@function
gisel_MEM_ADDR_LBU:                     # @gisel_MEM_ADDR_LBU
# %bb.0:                                # %entry
	mem_addr_lbu	a0, a0, a1
	ret
.Lfunc_end1:
	.size	gisel_MEM_ADDR_LBU, .Lfunc_end1-gisel_MEM_ADDR_LBU
                                        # -- End function
	.globl	gisel_MEM_ADDR_LH               # -- Begin function gisel_MEM_ADDR_LH
	.p2align	2
	.type	gisel_MEM_ADDR_LH,@function
gisel_MEM_ADDR_LH:                      # @gisel_MEM_ADDR_LH
# %bb.0:                                # %entry
	mem_addr_lh	a0, a0, a1
	ret
.Lfunc_end2:
	.size	gisel_MEM_ADDR_LH, .Lfunc_end2-gisel_MEM_ADDR_LH
                                        # -- End function
	.globl	gisel_MEM_ADDR_LHU              # -- Begin function gisel_MEM_ADDR_LHU
	.p2align	2
	.type	gisel_MEM_ADDR_LHU,@function
gisel_MEM_ADDR_LHU:                     # @gisel_MEM_ADDR_LHU
# %bb.0:                                # %entry
	mem_addr_lhu	a0, a0, a1
	ret
.Lfunc_end3:
	.size	gisel_MEM_ADDR_LHU, .Lfunc_end3-gisel_MEM_ADDR_LHU
                                        # -- End function
	.globl	gisel_MEM_ADDR_LW               # -- Begin function gisel_MEM_ADDR_LW
	.p2align	2
	.type	gisel_MEM_ADDR_LW,@function
gisel_MEM_ADDR_LW:                      # @gisel_MEM_ADDR_LW
# %bb.0:                                # %entry
	mem_addr_lw	a0, a0, a1
	ret
.Lfunc_end4:
	.size	gisel_MEM_ADDR_LW, .Lfunc_end4-gisel_MEM_ADDR_LW
                                        # -- End function
	.globl	gisel_MEM_LOADADD_LB            # -- Begin function gisel_MEM_LOADADD_LB
	.p2align	2
	.type	gisel_MEM_LOADADD_LB,@function
gisel_MEM_LOADADD_LB:                   # @gisel_MEM_LOADADD_LB
# %bb.0:                                # %entry
	mem_loadadd_lb	a0, a0, a1
	ret
.Lfunc_end5:
	.size	gisel_MEM_LOADADD_LB, .Lfunc_end5-gisel_MEM_LOADADD_LB
                                        # -- End function
	.globl	gisel_MEM_LOADADD_LBU           # -- Begin function gisel_MEM_LOADADD_LBU
	.p2align	2
	.type	gisel_MEM_LOADADD_LBU,@function
gisel_MEM_LOADADD_LBU:                  # @gisel_MEM_LOADADD_LBU
# %bb.0:                                # %entry
	mem_loadadd_lbu	a0, a0, a1
	ret
.Lfunc_end6:
	.size	gisel_MEM_LOADADD_LBU, .Lfunc_end6-gisel_MEM_LOADADD_LBU
                                        # -- End function
	.globl	gisel_MEM_LOADADD_LH            # -- Begin function gisel_MEM_LOADADD_LH
	.p2align	2
	.type	gisel_MEM_LOADADD_LH,@function
gisel_MEM_LOADADD_LH:                   # @gisel_MEM_LOADADD_LH
# %bb.0:                                # %entry
	mem_loadadd_lh	a0, a0, a1
	ret
.Lfunc_end7:
	.size	gisel_MEM_LOADADD_LH, .Lfunc_end7-gisel_MEM_LOADADD_LH
                                        # -- End function
	.globl	gisel_MEM_LOADADD_LHU           # -- Begin function gisel_MEM_LOADADD_LHU
	.p2align	2
	.type	gisel_MEM_LOADADD_LHU,@function
gisel_MEM_LOADADD_LHU:                  # @gisel_MEM_LOADADD_LHU
# %bb.0:                                # %entry
	mem_loadadd_lhu	a0, a0, a1
	ret
.Lfunc_end8:
	.size	gisel_MEM_LOADADD_LHU, .Lfunc_end8-gisel_MEM_LOADADD_LHU
                                        # -- End function
	.globl	gisel_MEM_LOADADD_LW            # -- Begin function gisel_MEM_LOADADD_LW
	.p2align	2
	.type	gisel_MEM_LOADADD_LW,@function
gisel_MEM_LOADADD_LW:                   # @gisel_MEM_LOADADD_LW
# %bb.0:                                # %entry
	mem_loadadd_lw	a0, a0, a1
	ret
.Lfunc_end9:
	.size	gisel_MEM_LOADADD_LW, .Lfunc_end9-gisel_MEM_LOADADD_LW
                                        # -- End function
	.globl	gisel_MEM_ADDR_SB               # -- Begin function gisel_MEM_ADDR_SB
	.p2align	2
	.type	gisel_MEM_ADDR_SB,@function
gisel_MEM_ADDR_SB:                      # @gisel_MEM_ADDR_SB
# %bb.0:                                # %entry
	mem_addr_sb	a0, a1, a2
	li	a0, 0
	ret
.Lfunc_end10:
	.size	gisel_MEM_ADDR_SB, .Lfunc_end10-gisel_MEM_ADDR_SB
                                        # -- End function
	.globl	gisel_MEM_ADDR_SH               # -- Begin function gisel_MEM_ADDR_SH
	.p2align	2
	.type	gisel_MEM_ADDR_SH,@function
gisel_MEM_ADDR_SH:                      # @gisel_MEM_ADDR_SH
# %bb.0:                                # %entry
	mem_addr_sh	a0, a1, a2
	li	a0, 0
	ret
.Lfunc_end11:
	.size	gisel_MEM_ADDR_SH, .Lfunc_end11-gisel_MEM_ADDR_SH
                                        # -- End function
	.globl	gisel_MEM_ADDR_SW               # -- Begin function gisel_MEM_ADDR_SW
	.p2align	2
	.type	gisel_MEM_ADDR_SW,@function
gisel_MEM_ADDR_SW:                      # @gisel_MEM_ADDR_SW
# %bb.0:                                # %entry
	mem_addr_sw	a0, a1, a2
	li	a0, 0
	ret
.Lfunc_end12:
	.size	gisel_MEM_ADDR_SW, .Lfunc_end12-gisel_MEM_ADDR_SW
                                        # -- End function
	.globl	gisel_MEM_STOREXOR_SB           # -- Begin function gisel_MEM_STOREXOR_SB
	.p2align	2
	.type	gisel_MEM_STOREXOR_SB,@function
gisel_MEM_STOREXOR_SB:                  # @gisel_MEM_STOREXOR_SB
# %bb.0:                                # %entry
	mem_storexor_sb	a0, a1, a2
	li	a0, 0
	ret
.Lfunc_end13:
	.size	gisel_MEM_STOREXOR_SB, .Lfunc_end13-gisel_MEM_STOREXOR_SB
                                        # -- End function
	.globl	gisel_MEM_STOREXOR_SH           # -- Begin function gisel_MEM_STOREXOR_SH
	.p2align	2
	.type	gisel_MEM_STOREXOR_SH,@function
gisel_MEM_STOREXOR_SH:                  # @gisel_MEM_STOREXOR_SH
# %bb.0:                                # %entry
	mem_storexor_sh	a0, a1, a2
	li	a0, 0
	ret
.Lfunc_end14:
	.size	gisel_MEM_STOREXOR_SH, .Lfunc_end14-gisel_MEM_STOREXOR_SH
                                        # -- End function
	.globl	gisel_MEM_STOREXOR_SW           # -- Begin function gisel_MEM_STOREXOR_SW
	.p2align	2
	.type	gisel_MEM_STOREXOR_SW,@function
gisel_MEM_STOREXOR_SW:                  # @gisel_MEM_STOREXOR_SW
# %bb.0:                                # %entry
	mem_storexor_sw	a0, a1, a2
	li	a0, 0
	ret
.Lfunc_end15:
	.size	gisel_MEM_STOREXOR_SW, .Lfunc_end15-gisel_MEM_STOREXOR_SW
                                        # -- End function
	.ident	"clang version 22.1.8 (https://github.com/llvm/llvm-project.git cad0b2de32c91d20d4e0c39b7de194894f307107)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
