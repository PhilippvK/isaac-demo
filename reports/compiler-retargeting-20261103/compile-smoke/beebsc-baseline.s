	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_f2p2_d2p2_zicsr2p0_zmmul1p0"
	.file	"beebsc.c"
	.file	0 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/temp/sessions/367/runs/0/mlif/lib/embench" "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/benchmarks/embench/support/beebsc.c" md5 0xf851a3b7dc454aa58fc858df30452456
	.file	1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/src/benchmarks/embench/support/beebsc.c" md5 0xf851a3b7dc454aa58fc858df30452456
	.file	2 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/install/riscv_gcc_rv32/riscv32-unknown-elf/include/sys/_types.h" md5 0x17b5691773b3e3881dfdbe392c9e8d43
	.file	3 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/install/riscv_gcc_rv32/riscv32-unknown-elf/include/strings.h" md5 0xdceb1b71cd72987b246237af8552faba
	.file	4 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/install/riscv_gcc_rv32/riscv32-unknown-elf/include/machine/_default_types.h" md5 0xf7024d0682a918b41f94e8be9cd90461
	.file	5 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/install/riscv_gcc_rv32/riscv32-unknown-elf/include/sys/_stdint.h" md5 0xab914e287601b2385e57880e6599aa6b
	.section	.text.rand_beebs,"ax",@progbits
	.globl	rand_beebs                      # -- Begin function rand_beebs
	.p2align	2
	.type	rand_beebs,@function
rand_beebs:                             # @rand_beebs
.Lfunc_begin0:
	.cfi_sections .debug_frame
	.cfi_startproc
# %bb.0:
	.loc	1 45 11 prologue_end            # deps/src/benchmarks/embench/support/beebsc.c:45:11
	lui	a1, %hi(seed)
	lw	a0, %lo(seed)(a1)
	lui	a2, 269413
	addi	a2, a2, -403
	.loc	1 45 16 is_stmt 0               # deps/src/benchmarks/embench/support/beebsc.c:45:16
	mul	a0, a0, a2
	lui	a2, 3
	addi	a2, a2, 57
	.loc	1 45 30                         # deps/src/benchmarks/embench/support/beebsc.c:45:30
	add	a0, a0, a2
	.loc	1 45 39                         # deps/src/benchmarks/embench/support/beebsc.c:45:39
	slli	a0, a0, 1
	srli	a2, a0, 1
	.loc	1 46 22 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:46:22
	srli	a0, a2, 16
	.loc	1 45 8                          # deps/src/benchmarks/embench/support/beebsc.c:45:8
	sw	a2, %lo(seed)(a1)
	.loc	1 46 3                          # deps/src/benchmarks/embench/support/beebsc.c:46:3
	ret
.Ltmp0:
.LBB_END0_0:
.Lfunc_end0:
	.size	rand_beebs, .Lfunc_end0-rand_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.rand_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin0                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin0-.Lfunc_begin0
	.uleb128 .LBB_END0_0-.Lfunc_begin0
	.byte	1
	.section	.text.rand_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.srand_beebs,"ax",@progbits
	.globl	srand_beebs                     # -- Begin function srand_beebs
	.p2align	2
	.type	srand_beebs,@function
srand_beebs:                            # @srand_beebs
.Lfunc_begin1:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: srand_beebs:new_seed <- $x10
	.loc	1 55 8 prologue_end             # deps/src/benchmarks/embench/support/beebsc.c:55:8
	lui	a1, %hi(seed)
	sw	a0, %lo(seed)(a1)
	.loc	1 56 1                          # deps/src/benchmarks/embench/support/beebsc.c:56:1
	ret
.Ltmp1:
.LBB_END1_0:
.Lfunc_end1:
	.size	srand_beebs, .Lfunc_end1-srand_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.srand_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin1                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin1-.Lfunc_begin1
	.uleb128 .LBB_END1_0-.Lfunc_begin1
	.byte	1
	.section	.text.srand_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.init_heap_beebs,"ax",@progbits
	.globl	init_heap_beebs                 # -- Begin function init_heap_beebs
	.p2align	2
	.type	init_heap_beebs,@function
init_heap_beebs:                        # @init_heap_beebs
.Lfunc_begin2:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: init_heap_beebs:heap <- $x10
	#DEBUG_VALUE: init_heap_beebs:heap_size <- $x11
	.loc	1 66 12 prologue_end            # deps/src/benchmarks/embench/support/beebsc.c:66:12
	lui	a2, %hi(heap_ptr)
	sw	a0, %lo(heap_ptr)(a2)
	.loc	1 67 42                         # deps/src/benchmarks/embench/support/beebsc.c:67:42
	add	a0, a0, a1
.Ltmp2:
	.loc	1 67 12 is_stmt 0               # deps/src/benchmarks/embench/support/beebsc.c:67:12
	lui	a1, %hi(heap_end)
.Ltmp3:
	sw	a0, %lo(heap_end)(a1)
	.loc	1 68 18 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:68:18
	lui	a0, %hi(heap_requested)
	sw	zero, %lo(heap_requested)(a0)
	.loc	1 69 1                          # deps/src/benchmarks/embench/support/beebsc.c:69:1
	ret
.Ltmp4:
.LBB_END2_0:
.Lfunc_end2:
	.size	init_heap_beebs, .Lfunc_end2-init_heap_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.init_heap_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin2                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin2-.Lfunc_begin2
	.uleb128 .LBB_END2_0-.Lfunc_begin2
	.byte	1
	.section	.text.init_heap_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.check_heap_beebs,"ax",@progbits
	.globl	check_heap_beebs                # -- Begin function check_heap_beebs
	.p2align	2
	.type	check_heap_beebs,@function
check_heap_beebs:                       # @check_heap_beebs
.Lfunc_begin3:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: check_heap_beebs:heap <- $x10
	.loc	1 80 37 prologue_end            # deps/src/benchmarks/embench/support/beebsc.c:80:37
	lui	a1, %hi(heap_requested)
	lw	a1, %lo(heap_requested)(a1)
	.loc	1 80 56 is_stmt 0               # deps/src/benchmarks/embench/support/beebsc.c:80:56
	lui	a2, %hi(heap_end)
	lw	a2, %lo(heap_end)(a2)
	.loc	1 80 35                         # deps/src/benchmarks/embench/support/beebsc.c:80:35
	add	a0, a0, a1
.Ltmp5:
	.loc	1 80 53                         # deps/src/benchmarks/embench/support/beebsc.c:80:53
	sltu	a0, a2, a0
	xori	a0, a0, 1
	.loc	1 80 3                          # deps/src/benchmarks/embench/support/beebsc.c:80:3
	ret
.Ltmp6:
.LBB_END3_0:
.Lfunc_end3:
	.size	check_heap_beebs, .Lfunc_end3-check_heap_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.check_heap_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin3                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin3-.Lfunc_begin3
	.uleb128 .LBB_END3_0-.Lfunc_begin3
	.byte	1
	.section	.text.check_heap_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.malloc_beebs,"ax",@progbits
	.globl	malloc_beebs                    # -- Begin function malloc_beebs
	.p2align	2
	.type	malloc_beebs,@function
malloc_beebs:                           # @malloc_beebs
.Lfunc_begin4:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: malloc_beebs:size <- $x10
	#DEBUG_VALUE: malloc_beebs:size <- $x10
	.loc	1 96 7 prologue_end is_stmt 1   # deps/src/benchmarks/embench/support/beebsc.c:96:7
	beqz	a0, .LBB4_4
.Ltmp7:
.LBB_END4_0:
.LBB4_1:
	#DEBUG_VALUE: malloc_beebs:size <- $x10
	.loc	1 0 7 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:7
	mv	a1, a0
.Ltmp8:
	#DEBUG_VALUE: malloc_beebs:size <- $x11
	.loc	1 99 33 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:99:33
	lui	a2, %hi(heap_ptr)
	lw	a0, %lo(heap_ptr)(a2)
	.loc	1 101 18                        # deps/src/benchmarks/embench/support/beebsc.c:101:18
	lui	a3, %hi(heap_requested)
	lw	a4, %lo(heap_requested)(a3)
	.loc	1 99 42                         # deps/src/benchmarks/embench/support/beebsc.c:99:42
	add	a5, a0, a1
.Ltmp9:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x15
	.loc	1 101 18                        # deps/src/benchmarks/embench/support/beebsc.c:101:18
	add	a1, a4, a1
.Ltmp10:
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	.loc	1 106 33                        # deps/src/benchmarks/embench/support/beebsc.c:106:33
	andi	a4, a5, 3
	.loc	1 106 46 is_stmt 0              # deps/src/benchmarks/embench/support/beebsc.c:106:46
	seqz	a6, a4
	li	a7, 4
.Ltmp11:
	.loc	1 106 7                         # deps/src/benchmarks/embench/support/beebsc.c:106:7
	sub	a4, a7, a4
	addi	a6, a6, -1
.Ltmp12:
	.loc	1 118 23 is_stmt 1              # deps/src/benchmarks/embench/support/beebsc.c:118:23
	lui	a7, %hi(heap_end)
	lw	a7, %lo(heap_end)(a7)
.Ltmp13:
	.loc	1 106 7                         # deps/src/benchmarks/embench/support/beebsc.c:106:7
	and	a4, a6, a4
	add	a6, a1, a4
	add	a1, a5, a4
	.loc	1 0 0 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:0
	sw	a6, %lo(heap_requested)(a3)
.Ltmp14:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x11
	.loc	1 118 7 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:118:7
	bgeu	a7, a1, .LBB4_3
.Ltmp15:
.LBB_END4_1:
.LBB4_2:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x11
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	.loc	1 0 7 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:7
	li	a0, 0
	.loc	1 125 1 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:125:1
	ret
.Ltmp16:
.LBB_END4_2:
.LBB4_3:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x11
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	#DEBUG_VALUE: malloc_beebs:new_ptr <- $x10
	.loc	1 122 12                        # deps/src/benchmarks/embench/support/beebsc.c:122:12
	sw	a1, %lo(heap_ptr)(a2)
.Ltmp17:
.LBB_END4_3:
.LBB4_4:
	.loc	1 125 1                         # deps/src/benchmarks/embench/support/beebsc.c:125:1
	ret
.Ltmp18:
.LBB_END4_4:
.Lfunc_end4:
	.size	malloc_beebs, .Lfunc_end4-malloc_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.malloc_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin4                   # function address
	.byte	5                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin4-.Lfunc_begin4
	.uleb128 .LBB_END4_0-.Lfunc_begin4
	.byte	8
	.byte	1                               # BB id
	.uleb128 .LBB4_1-.LBB_END4_0
	.uleb128 .LBB_END4_1-.LBB4_1
	.byte	8
	.byte	5                               # BB id
	.uleb128 .LBB4_2-.LBB_END4_1
	.uleb128 .LBB_END4_2-.LBB4_2
	.byte	1
	.byte	2                               # BB id
	.uleb128 .LBB4_3-.LBB_END4_2
	.uleb128 .LBB_END4_3-.LBB4_3
	.byte	8
	.byte	3                               # BB id
	.uleb128 .LBB4_4-.LBB_END4_3
	.uleb128 .LBB_END4_4-.LBB4_4
	.byte	1
	.section	.text.malloc_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.calloc_beebs,"ax",@progbits
	.globl	calloc_beebs                    # -- Begin function calloc_beebs
	.p2align	2
	.type	calloc_beebs,@function
calloc_beebs:                           # @calloc_beebs
.Lfunc_begin5:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: calloc_beebs:nmemb <- $x10
	#DEBUG_VALUE: calloc_beebs:size <- $x11
	.loc	1 135 39 prologue_end           # deps/src/benchmarks/embench/support/beebsc.c:135:39
	mul	a2, a1, a0
.Ltmp19:
	#DEBUG_VALUE: malloc_beebs:size <- $x12
	.loc	1 96 7                          # deps/src/benchmarks/embench/support/beebsc.c:96:7
	beqz	a2, .LBB5_4
.Ltmp20:
.LBB_END5_0:
.LBB5_1:
	#DEBUG_VALUE: malloc_beebs:size <- $x12
	#DEBUG_VALUE: calloc_beebs:size <- $x11
	#DEBUG_VALUE: calloc_beebs:nmemb <- $x10
	.loc	1 99 33                         # deps/src/benchmarks/embench/support/beebsc.c:99:33
	lui	a1, %hi(heap_ptr)
.Ltmp21:
	lw	a0, %lo(heap_ptr)(a1)
.Ltmp22:
	.loc	1 101 18                        # deps/src/benchmarks/embench/support/beebsc.c:101:18
	lui	a4, %hi(heap_requested)
	lw	a3, %lo(heap_requested)(a4)
	.loc	1 99 42                         # deps/src/benchmarks/embench/support/beebsc.c:99:42
	add	a5, a0, a2
.Ltmp23:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x15
	.loc	1 101 18                        # deps/src/benchmarks/embench/support/beebsc.c:101:18
	add	a3, a3, a2
.Ltmp24:
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	.loc	1 106 33                        # deps/src/benchmarks/embench/support/beebsc.c:106:33
	andi	a6, a5, 3
	.loc	1 106 46 is_stmt 0              # deps/src/benchmarks/embench/support/beebsc.c:106:46
	seqz	a7, a6
	li	t0, 4
.Ltmp25:
	.loc	1 106 7                         # deps/src/benchmarks/embench/support/beebsc.c:106:7
	sub	a6, t0, a6
	addi	a7, a7, -1
.Ltmp26:
	.loc	1 118 23 is_stmt 1              # deps/src/benchmarks/embench/support/beebsc.c:118:23
	lui	t0, %hi(heap_end)
	lw	t0, %lo(heap_end)(t0)
.Ltmp27:
	.loc	1 106 7                         # deps/src/benchmarks/embench/support/beebsc.c:106:7
	and	a6, a7, a6
	add	a7, a3, a6
	add	a3, a5, a6
	.loc	1 0 0 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:0
	sw	a7, %lo(heap_requested)(a4)
.Ltmp28:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x13
	.loc	1 118 7 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:118:7
	bltu	t0, a3, .LBB5_4
.Ltmp29:
.LBB_END5_1:
.LBB5_2:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x13
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	#DEBUG_VALUE: malloc_beebs:size <- $x12
	#DEBUG_VALUE: malloc_beebs:new_ptr <- $x10
	.loc	1 122 12                        # deps/src/benchmarks/embench/support/beebsc.c:122:12
	sw	a3, %lo(heap_ptr)(a1)
.Ltmp30:
	#DEBUG_VALUE: calloc_beebs:new_ptr <- $x10
	.loc	1 140 7                         # deps/src/benchmarks/embench/support/beebsc.c:140:7
	beqz	a0, .LBB5_4
.Ltmp31:
.LBB_END5_2:
.LBB5_3:
	#DEBUG_VALUE: calloc_beebs:new_ptr <- $x10
	.loc	1 141 5                         # deps/src/benchmarks/embench/support/beebsc.c:141:5
	li	a1, 0
.Ltmp32:
	tail	memset
.Ltmp33:
.LBB_END5_3:
.LBB5_4:
	.loc	1 143 3                         # deps/src/benchmarks/embench/support/beebsc.c:143:3
	li	a0, 0
	ret
.Ltmp34:
.LBB_END5_4:
.Lfunc_end5:
	.size	calloc_beebs, .Lfunc_end5-calloc_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.calloc_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin5                   # function address
	.byte	5                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin5-.Lfunc_begin5
	.uleb128 .LBB_END5_0-.Lfunc_begin5
	.byte	8
	.byte	1                               # BB id
	.uleb128 .LBB5_1-.LBB_END5_0
	.uleb128 .LBB_END5_1-.LBB5_1
	.byte	8
	.byte	2                               # BB id
	.uleb128 .LBB5_2-.LBB_END5_1
	.uleb128 .LBB_END5_2-.LBB5_2
	.byte	8
	.byte	3                               # BB id
	.uleb128 .LBB5_3-.LBB_END5_2
	.uleb128 .LBB_END5_3-.LBB5_3
	.byte	3
	.byte	4                               # BB id
	.uleb128 .LBB5_4-.LBB_END5_3
	.uleb128 .LBB_END5_4-.LBB5_4
	.byte	1
	.section	.text.calloc_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.realloc_beebs,"ax",@progbits
	.globl	realloc_beebs                   # -- Begin function realloc_beebs
	.p2align	2
	.type	realloc_beebs,@function
realloc_beebs:                          # @realloc_beebs
.Lfunc_begin6:
	.loc	1 154 0                         # deps/src/benchmarks/embench/support/beebsc.c:154:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: realloc_beebs:ptr <- $x10
	#DEBUG_VALUE: realloc_beebs:size <- $x11
	mv	a2, a0
	#DEBUG_VALUE: malloc_beebs:size <- undef
.Ltmp35:
	#DEBUG_VALUE: realloc_beebs:ptr <- $x12
	li	a0, 0
.Ltmp36:
	.loc	1 155 7 prologue_end            # deps/src/benchmarks/embench/support/beebsc.c:155:7
	beqz	a2, .LBB6_7
.Ltmp37:
.LBB_END6_0:
.LBB6_1:
	#DEBUG_VALUE: realloc_beebs:ptr <- $x12
	#DEBUG_VALUE: realloc_beebs:size <- $x11
	beqz	a1, .LBB6_7
.Ltmp38:
.LBB_END6_1:
.LBB6_2:
	#DEBUG_VALUE: realloc_beebs:ptr <- $x12
	#DEBUG_VALUE: realloc_beebs:size <- $x11
	.loc	1 99 33                         # deps/src/benchmarks/embench/support/beebsc.c:99:33
	lui	a4, %hi(heap_ptr)
	lw	a0, %lo(heap_ptr)(a4)
	.loc	1 101 18                        # deps/src/benchmarks/embench/support/beebsc.c:101:18
	lui	a5, %hi(heap_requested)
	lw	a6, %lo(heap_requested)(a5)
	.loc	1 99 42                         # deps/src/benchmarks/embench/support/beebsc.c:99:42
	add	a3, a0, a1
.Ltmp39:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x13
	.loc	1 101 18                        # deps/src/benchmarks/embench/support/beebsc.c:101:18
	add	a1, a6, a1
.Ltmp40:
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	.loc	1 106 33                        # deps/src/benchmarks/embench/support/beebsc.c:106:33
	andi	a6, a3, 3
	.loc	1 106 46 is_stmt 0              # deps/src/benchmarks/embench/support/beebsc.c:106:46
	seqz	a7, a6
	li	t0, 4
.Ltmp41:
	.loc	1 106 7                         # deps/src/benchmarks/embench/support/beebsc.c:106:7
	sub	a6, t0, a6
	addi	a7, a7, -1
.Ltmp42:
	.loc	1 118 23 is_stmt 1              # deps/src/benchmarks/embench/support/beebsc.c:118:23
	lui	t0, %hi(heap_end)
	lw	t0, %lo(heap_end)(t0)
.Ltmp43:
	.loc	1 106 7                         # deps/src/benchmarks/embench/support/beebsc.c:106:7
	and	a6, a7, a6
	add	a7, a1, a6
	add	a1, a3, a6
	.loc	1 0 0 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:0
	sw	a7, %lo(heap_requested)(a5)
.Ltmp44:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x11
	.loc	1 118 7 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:118:7
	bgeu	t0, a1, .LBB6_4
.Ltmp45:
.LBB_END6_2:
.LBB6_3:
	#DEBUG_VALUE: realloc_beebs:ptr <- $x12
	.loc	1 0 7 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:7
	li	a0, 0
	.loc	1 171 1 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:171:1
	ret
.Ltmp46:
.LBB_END6_3:
.LBB6_4:
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x11
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	#DEBUG_VALUE: realloc_beebs:ptr <- $x12
	#DEBUG_VALUE: malloc_beebs:new_ptr <- $x10
	.loc	1 122 12                        # deps/src/benchmarks/embench/support/beebsc.c:122:12
	sw	a1, %lo(heap_ptr)(a4)
.Ltmp47:
	#DEBUG_VALUE: realloc_beebs:new_ptr <- $x10
	.loc	1 166 7                         # deps/src/benchmarks/embench/support/beebsc.c:166:7
	beqz	a0, .LBB6_7
.Ltmp48:
.LBB_END6_4:
.LBB6_5:
	#DEBUG_VALUE: realloc_beebs:new_ptr <- $x10
	#DEBUG_VALUE: malloc_beebs:new_ptr <- $x10
	#DEBUG_VALUE: malloc_beebs:next_heap_ptr <- $x11
	#DEBUG_VALUE: malloc_beebs:alignment <- 4
	#DEBUG_VALUE: realloc_beebs:ptr <- $x12
	.loc	1 0 7 is_stmt 0                 # deps/src/benchmarks/embench/support/beebsc.c:0:7
	mv	a1, a0
.Ltmp49:
.LBB_END6_5:
.LBB6_6:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: realloc_beebs:new_ptr <- $x10
	#DEBUG_VALUE: i <- [DW_OP_LLVM_arg 0, DW_OP_LLVM_arg 1, DW_OP_minus, DW_OP_stack_value] $x11, $x10
	.loc	1 168 30 is_stmt 1              # deps/src/benchmarks/embench/support/beebsc.c:168:30
	lbu	a4, 0(a2)
	.loc	1 168 28 is_stmt 0              # deps/src/benchmarks/embench/support/beebsc.c:168:28
	sb	a4, 0(a1)
.Ltmp50:
	#DEBUG_VALUE: i <- [DW_OP_LLVM_arg 0, DW_OP_LLVM_arg 1, DW_OP_minus, DW_OP_consts 1, DW_OP_plus, DW_OP_stack_value] $x11, $x10
	.loc	1 167 26 is_stmt 1              # deps/src/benchmarks/embench/support/beebsc.c:167:26
	addi	a1, a1, 1
.Ltmp51:
	addi	a2, a2, 1
.Ltmp52:
	.loc	1 167 5 is_stmt 0               # deps/src/benchmarks/embench/support/beebsc.c:167:5
	bne	a1, a3, .LBB6_6
.Ltmp53:
.LBB_END6_6:
.LBB6_7:
	.loc	1 171 1 is_stmt 1               # deps/src/benchmarks/embench/support/beebsc.c:171:1
	ret
.Ltmp54:
.LBB_END6_7:
.Lfunc_end6:
	.size	realloc_beebs, .Lfunc_end6-realloc_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.realloc_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin6                   # function address
	.byte	8                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin6-.Lfunc_begin6
	.uleb128 .LBB_END6_0-.Lfunc_begin6
	.byte	8
	.byte	6                               # BB id
	.uleb128 .LBB6_1-.LBB_END6_0
	.uleb128 .LBB_END6_1-.LBB6_1
	.byte	8
	.byte	1                               # BB id
	.uleb128 .LBB6_2-.LBB_END6_1
	.uleb128 .LBB_END6_2-.LBB6_2
	.byte	8
	.byte	7                               # BB id
	.uleb128 .LBB6_3-.LBB_END6_2
	.uleb128 .LBB_END6_3-.LBB6_3
	.byte	1
	.byte	2                               # BB id
	.uleb128 .LBB6_4-.LBB_END6_3
	.uleb128 .LBB_END6_4-.LBB6_4
	.byte	8
	.byte	3                               # BB id
	.uleb128 .LBB6_5-.LBB_END6_4
	.uleb128 .LBB_END6_5-.LBB6_5
	.byte	8
	.byte	4                               # BB id
	.uleb128 .LBB6_6-.LBB_END6_5
	.uleb128 .LBB_END6_6-.LBB6_6
	.byte	8
	.byte	5                               # BB id
	.uleb128 .LBB6_7-.LBB_END6_6
	.uleb128 .LBB_END6_7-.LBB6_7
	.byte	1
	.section	.text.realloc_beebs,"ax",@progbits
                                        # -- End function
	.section	.text.free_beebs,"ax",@progbits
	.globl	free_beebs                      # -- Begin function free_beebs
	.p2align	2
	.type	free_beebs,@function
free_beebs:                             # @free_beebs
.Lfunc_begin7:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: free_beebs:ptr <- $x10
	.loc	1 181 1 prologue_end            # deps/src/benchmarks/embench/support/beebsc.c:181:1
	ret
.Ltmp55:
.LBB_END7_0:
.Lfunc_end7:
	.size	free_beebs, .Lfunc_end7-free_beebs
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.free_beebs
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin7                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin7-.Lfunc_begin7
	.uleb128 .LBB_END7_0-.Lfunc_begin7
	.byte	1
	.section	.text.free_beebs,"ax",@progbits
                                        # -- End function
	.type	seed,@object                    # @seed
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
seed:
	.word	0                               # 0x0
	.size	seed, 4

	.type	heap_ptr,@object                # @heap_ptr
	.p2align	2, 0x0
heap_ptr:
	.word	0
	.size	heap_ptr, 4

	.type	heap_end,@object                # @heap_end
	.p2align	2, 0x0
heap_end:
	.word	0
	.size	heap_end, 4

	.type	heap_requested,@object          # @heap_requested
	.p2align	2, 0x0
heap_requested:
	.word	0                               # 0x0
	.size	heap_requested, 4

	.section	.debug_loclists,"",@progbits
	.word	.Ldebug_list_header_end0-.Ldebug_list_header_start0 # Length
.Ldebug_list_header_start0:
	.half	5                               # Version
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
	.word	20                              # Offset entry count
.Lloclists_table_base0:
	.word	.Ldebug_loc0-.Lloclists_table_base0
	.word	.Ldebug_loc1-.Lloclists_table_base0
	.word	.Ldebug_loc2-.Lloclists_table_base0
	.word	.Ldebug_loc3-.Lloclists_table_base0
	.word	.Ldebug_loc4-.Lloclists_table_base0
	.word	.Ldebug_loc5-.Lloclists_table_base0
	.word	.Ldebug_loc6-.Lloclists_table_base0
	.word	.Ldebug_loc7-.Lloclists_table_base0
	.word	.Ldebug_loc8-.Lloclists_table_base0
	.word	.Ldebug_loc9-.Lloclists_table_base0
	.word	.Ldebug_loc10-.Lloclists_table_base0
	.word	.Ldebug_loc11-.Lloclists_table_base0
	.word	.Ldebug_loc12-.Lloclists_table_base0
	.word	.Ldebug_loc13-.Lloclists_table_base0
	.word	.Ldebug_loc14-.Lloclists_table_base0
	.word	.Ldebug_loc15-.Lloclists_table_base0
	.word	.Ldebug_loc16-.Lloclists_table_base0
	.word	.Ldebug_loc17-.Lloclists_table_base0
	.word	.Ldebug_loc18-.Lloclists_table_base0
	.word	.Ldebug_loc19-.Lloclists_table_base0
.Ldebug_loc0:
	.byte	3                               # DW_LLE_startx_length
	.byte	6                               #   start index
	.uleb128 .Ltmp2-.Lfunc_begin2           #   length
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc1:
	.byte	3                               # DW_LLE_startx_length
	.byte	6                               #   start index
	.uleb128 .Ltmp3-.Lfunc_begin2           #   length
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc2:
	.byte	3                               # DW_LLE_startx_length
	.byte	7                               #   start index
	.uleb128 .Ltmp5-.Lfunc_begin3           #   length
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc3:
	.byte	1                               # DW_LLE_base_addressx
	.byte	8                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Lfunc_begin4-.Lfunc_begin4    #   starting offset
	.uleb128 .Ltmp8-.Lfunc_begin4           #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin4           #   starting offset
	.uleb128 .Ltmp10-.Lfunc_begin4          #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc4:
	.byte	1                               # DW_LLE_base_addressx
	.byte	8                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp9-.Lfunc_begin4           #   starting offset
	.uleb128 .Ltmp14-.Lfunc_begin4          #   ending offset
	.byte	1                               # Loc expr size
	.byte	95                              # DW_OP_reg15
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp14-.Lfunc_begin4          #   starting offset
	.uleb128 .Ltmp17-.Lfunc_begin4          #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc5:
	.byte	1                               # DW_LLE_base_addressx
	.byte	8                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp10-.Lfunc_begin4          #   starting offset
	.uleb128 .Ltmp17-.Lfunc_begin4          #   ending offset
	.byte	2                               # Loc expr size
	.byte	52                              # DW_OP_lit4
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc6:
	.byte	1                               # DW_LLE_base_addressx
	.byte	8                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp16-.Lfunc_begin4          #   starting offset
	.uleb128 .Ltmp17-.Lfunc_begin4          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc7:
	.byte	3                               # DW_LLE_startx_length
	.byte	9                               #   start index
	.uleb128 .Ltmp22-.Lfunc_begin5          #   length
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc8:
	.byte	3                               # DW_LLE_startx_length
	.byte	9                               #   start index
	.uleb128 .Ltmp21-.Lfunc_begin5          #   length
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc9:
	.byte	1                               # DW_LLE_base_addressx
	.byte	9                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp23-.Lfunc_begin5          #   starting offset
	.uleb128 .Ltmp28-.Lfunc_begin5          #   ending offset
	.byte	1                               # Loc expr size
	.byte	95                              # DW_OP_reg15
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp28-.Lfunc_begin5          #   starting offset
	.uleb128 .Ltmp31-.Lfunc_begin5          #   ending offset
	.byte	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc10:
	.byte	1                               # DW_LLE_base_addressx
	.byte	9                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp24-.Lfunc_begin5          #   starting offset
	.uleb128 .Ltmp31-.Lfunc_begin5          #   ending offset
	.byte	2                               # Loc expr size
	.byte	52                              # DW_OP_lit4
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc11:
	.byte	1                               # DW_LLE_base_addressx
	.byte	9                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp29-.Lfunc_begin5          #   starting offset
	.uleb128 .Ltmp31-.Lfunc_begin5          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc12:
	.byte	1                               # DW_LLE_base_addressx
	.byte	9                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp30-.Lfunc_begin5          #   starting offset
	.uleb128 .Ltmp33-.Lfunc_begin5          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc13:
	.byte	1                               # DW_LLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Lfunc_begin6-.Lfunc_begin6    #   starting offset
	.uleb128 .Ltmp35-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp35-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp49-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	92                              # DW_OP_reg12
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc14:
	.byte	3                               # DW_LLE_startx_length
	.byte	11                              #   start index
	.uleb128 .Ltmp40-.Lfunc_begin6          #   length
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc15:
	.byte	1                               # DW_LLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp39-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp44-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	93                              # DW_OP_reg13
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp44-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp45-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp46-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp48-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	91                              # DW_OP_reg11
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc16:
	.byte	1                               # DW_LLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp40-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp45-.Lfunc_begin6          #   ending offset
	.byte	2                               # Loc expr size
	.byte	52                              # DW_OP_lit4
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp46-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp48-.Lfunc_begin6          #   ending offset
	.byte	2                               # Loc expr size
	.byte	52                              # DW_OP_lit4
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc17:
	.byte	1                               # DW_LLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp46-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp48-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc18:
	.byte	1                               # DW_LLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp47-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp53-.Lfunc_begin6          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc19:
	.byte	1                               # DW_LLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp49-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp50-.Lfunc_begin6          #   ending offset
	.byte	6                               # Loc expr size
	.byte	123                             # DW_OP_breg11
	.byte	0                               # 0
	.byte	122                             # DW_OP_breg10
	.byte	0                               # 0
	.byte	28                              # DW_OP_minus
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp50-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp51-.Lfunc_begin6          #   ending offset
	.byte	9                               # Loc expr size
	.byte	123                             # DW_OP_breg11
	.byte	0                               # 0
	.byte	122                             # DW_OP_breg10
	.byte	0                               # 0
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	1                               # 1
	.byte	34                              # DW_OP_plus
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_list_header_end0:
	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	37                              # DW_FORM_strx1
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	114                             # DW_AT_str_offsets_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	37                              # DW_FORM_strx1
	.byte	17                              # DW_AT_low_pc
	.byte	1                               # DW_FORM_addr
	.byte	85                              # DW_AT_ranges
	.byte	35                              # DW_FORM_rnglistx
	.byte	115                             # DW_AT_addr_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	116                             # DW_AT_rnglists_base
	.byte	23                              # DW_FORM_sec_offset
	.ascii	"\214\001"                      # DW_AT_loclists_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	22                              # DW_TAG_typedef
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	0                               # DW_CHILDREN_no
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	32                              # DW_AT_inline
	.byte	33                              # DW_FORM_implicit_const
	.byte	1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	16                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	17                              # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	18                              # Abbreviation Code
	.byte	11                              # DW_TAG_lexical_block
	.byte	1                               # DW_CHILDREN_yes
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	19                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	20                              # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	21                              # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	87                              # DW_AT_call_column
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	22                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	23                              # Abbreviation Code
	.byte	29                              # DW_TAG_inlined_subroutine
	.byte	1                               # DW_CHILDREN_yes
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	85                              # DW_AT_ranges
	.byte	35                              # DW_FORM_rnglistx
	.byte	88                              # DW_AT_call_file
	.byte	11                              # DW_FORM_data1
	.byte	89                              # DW_AT_call_line
	.byte	11                              # DW_FORM_data1
	.byte	87                              # DW_AT_call_column
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	24                              # Abbreviation Code
	.byte	11                              # DW_TAG_lexical_block
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.word	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.half	5                               # DWARF version number
	.byte	1                               # DWARF Unit Type
	.byte	4                               # Address Size (in bytes)
	.word	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	1                               # Abbrev [1] 0xc:0x1fa DW_TAG_compile_unit
	.byte	0                               # DW_AT_producer
	.half	29                              # DW_AT_language
	.byte	1                               # DW_AT_name
	.word	.Lstr_offsets_base0             # DW_AT_str_offsets_base
	.word	.Lline_table_start0             # DW_AT_stmt_list
	.byte	2                               # DW_AT_comp_dir
	.word	0                               # DW_AT_low_pc
	.byte	1                               # DW_AT_ranges
	.word	.Laddr_table_base0              # DW_AT_addr_base
	.word	.Lrnglists_table_base0          # DW_AT_rnglists_base
	.word	.Lloclists_table_base0          # DW_AT_loclists_base
	.byte	2                               # Abbrev [2] 0x2b:0xb DW_TAG_variable
	.byte	3                               # DW_AT_name
	.word	54                              # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	25                              # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	0
	.byte	3                               # Abbrev [3] 0x36:0x4 DW_TAG_base_type
	.byte	4                               # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	2                               # Abbrev [2] 0x3a:0xb DW_TAG_variable
	.byte	5                               # DW_AT_name
	.word	69                              # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	29                              # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	1
	.byte	4                               # Abbrev [4] 0x45:0x1 DW_TAG_pointer_type
	.byte	2                               # Abbrev [2] 0x46:0xb DW_TAG_variable
	.byte	6                               # DW_AT_name
	.word	69                              # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	30                              # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	2
	.byte	2                               # Abbrev [2] 0x51:0xb DW_TAG_variable
	.byte	7                               # DW_AT_name
	.word	92                              # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	31                              # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	3
	.byte	5                               # Abbrev [5] 0x5c:0x8 DW_TAG_typedef
	.word	100                             # DW_AT_type
	.byte	10                              # DW_AT_name
	.byte	3                               # DW_AT_decl_file
	.byte	40                              # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0x64:0x8 DW_TAG_typedef
	.word	108                             # DW_AT_type
	.byte	9                               # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	131                             # DW_AT_decl_line
	.byte	3                               # Abbrev [3] 0x6c:0x4 DW_TAG_base_type
	.byte	8                               # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	3                               # Abbrev [3] 0x70:0x4 DW_TAG_base_type
	.byte	11                              # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	6                               # Abbrev [6] 0x74:0x5 DW_TAG_pointer_type
	.word	121                             # DW_AT_type
	.byte	3                               # Abbrev [3] 0x79:0x4 DW_TAG_base_type
	.byte	12                              # DW_AT_name
	.byte	8                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	5                               # Abbrev [5] 0x7d:0x8 DW_TAG_typedef
	.word	133                             # DW_AT_type
	.byte	14                              # DW_AT_name
	.byte	5                               # DW_AT_decl_file
	.byte	82                              # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0x85:0x8 DW_TAG_typedef
	.word	108                             # DW_AT_type
	.byte	13                              # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	232                             # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x8d:0xf DW_TAG_subprogram
	.byte	4                               # DW_AT_low_pc
	.word	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	21                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	43                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	112                             # DW_AT_type
                                        # DW_AT_external
	.byte	8                               # Abbrev [8] 0x9c:0x16 DW_TAG_subprogram
	.byte	5                               # DW_AT_low_pc
	.word	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	22                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	53                              # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	9                               # Abbrev [9] 0xa7:0xa DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	90
	.byte	28                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	53                              # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0xb2:0x1e DW_TAG_subprogram
	.byte	6                               # DW_AT_low_pc
	.word	.Lfunc_end2-.Lfunc_begin2       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	23                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	63                              # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	10                              # Abbrev [10] 0xbd:0x9 DW_TAG_formal_parameter
	.byte	0                               # DW_AT_location
	.byte	29                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	63                              # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	10                              # Abbrev [10] 0xc6:0x9 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	30                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	63                              # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0xd0:0x19 DW_TAG_subprogram
	.byte	7                               # DW_AT_low_pc
	.word	.Lfunc_end3-.Lfunc_begin3       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	24                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	78                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	112                             # DW_AT_type
                                        # DW_AT_external
	.byte	10                              # Abbrev [10] 0xdf:0x9 DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	29                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	78                              # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	12                              # Abbrev [12] 0xe9:0x25 DW_TAG_subprogram
	.byte	8                               # DW_AT_low_pc
	.word	.Lfunc_end4-.Lfunc_begin4       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.word	270                             # DW_AT_abstract_origin
	.byte	13                              # Abbrev [13] 0xf5:0x6 DW_TAG_formal_parameter
	.byte	3                               # DW_AT_location
	.word	278                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0xfb:0x6 DW_TAG_variable
	.byte	4                               # DW_AT_location
	.word	286                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x101:0x6 DW_TAG_variable
	.byte	5                               # DW_AT_location
	.word	294                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x107:0x6 DW_TAG_variable
	.byte	6                               # DW_AT_location
	.word	302                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	15                              # Abbrev [15] 0x10e:0x33 DW_TAG_subprogram
	.byte	15                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	94                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	69                              # DW_AT_type
                                        # DW_AT_external
                                        # DW_AT_inline
	.byte	16                              # Abbrev [16] 0x116:0x8 DW_TAG_formal_parameter
	.byte	16                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	94                              # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	17                              # Abbrev [17] 0x11e:0x8 DW_TAG_variable
	.byte	17                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	99                              # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	17                              # Abbrev [17] 0x126:0x8 DW_TAG_variable
	.byte	18                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	103                             # DW_AT_decl_line
	.word	321                             # DW_AT_type
	.byte	17                              # Abbrev [17] 0x12e:0x8 DW_TAG_variable
	.byte	19                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	121                             # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	18                              # Abbrev [18] 0x136:0xa DW_TAG_lexical_block
	.byte	17                              # Abbrev [17] 0x137:0x8 DW_TAG_variable
	.byte	20                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	108                             # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	19                              # Abbrev [19] 0x141:0x5 DW_TAG_const_type
	.word	92                              # DW_AT_type
	.byte	11                              # Abbrev [11] 0x146:0x52 DW_TAG_subprogram
	.byte	9                               # DW_AT_low_pc
	.word	.Lfunc_end5-.Lfunc_begin5       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	25                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	133                             # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	69                              # DW_AT_type
                                        # DW_AT_external
	.byte	10                              # Abbrev [10] 0x155:0x9 DW_TAG_formal_parameter
	.byte	7                               # DW_AT_location
	.byte	31                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	133                             # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	10                              # Abbrev [10] 0x15e:0x9 DW_TAG_formal_parameter
	.byte	8                               # DW_AT_location
	.byte	16                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	133                             # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	20                              # Abbrev [20] 0x167:0x9 DW_TAG_variable
	.byte	12                              # DW_AT_location
	.byte	19                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	135                             # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	21                              # Abbrev [21] 0x170:0x27 DW_TAG_inlined_subroutine
	.word	270                             # DW_AT_abstract_origin
	.byte	10                              # DW_AT_low_pc
	.word	.Ltmp30-.Ltmp19                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	135                             # DW_AT_call_line
	.byte	19                              # DW_AT_call_column
	.byte	22                              # Abbrev [22] 0x17d:0x7 DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	92
	.word	278                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x184:0x6 DW_TAG_variable
	.byte	9                               # DW_AT_location
	.word	286                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x18a:0x6 DW_TAG_variable
	.byte	10                              # DW_AT_location
	.word	294                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x190:0x6 DW_TAG_variable
	.byte	11                              # DW_AT_location
	.word	302                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0x198:0x57 DW_TAG_subprogram
	.byte	11                              # DW_AT_low_pc
	.word	.Lfunc_end6-.Lfunc_begin6       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	26                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	153                             # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	69                              # DW_AT_type
                                        # DW_AT_external
	.byte	10                              # Abbrev [10] 0x1a7:0x9 DW_TAG_formal_parameter
	.byte	13                              # DW_AT_location
	.byte	32                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	153                             # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	10                              # Abbrev [10] 0x1b0:0x9 DW_TAG_formal_parameter
	.byte	14                              # DW_AT_location
	.byte	16                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	153                             # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	20                              # Abbrev [20] 0x1b9:0x9 DW_TAG_variable
	.byte	18                              # DW_AT_location
	.byte	19                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	159                             # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	23                              # Abbrev [23] 0x1c2:0x1c DW_TAG_inlined_subroutine
	.word	270                             # DW_AT_abstract_origin
	.byte	0                               # DW_AT_ranges
	.byte	1                               # DW_AT_call_file
	.byte	159                             # DW_AT_call_line
	.byte	19                              # DW_AT_call_column
	.byte	14                              # Abbrev [14] 0x1cb:0x6 DW_TAG_variable
	.byte	15                              # DW_AT_location
	.word	286                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x1d1:0x6 DW_TAG_variable
	.byte	16                              # DW_AT_location
	.word	294                             # DW_AT_abstract_origin
	.byte	14                              # Abbrev [14] 0x1d7:0x6 DW_TAG_variable
	.byte	17                              # DW_AT_location
	.word	302                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	24                              # Abbrev [24] 0x1de:0x10 DW_TAG_lexical_block
	.byte	12                              # DW_AT_low_pc
	.word	.Ltmp53-.Ltmp49                 # DW_AT_high_pc
	.byte	20                              # Abbrev [20] 0x1e4:0x9 DW_TAG_variable
	.byte	19                              # DW_AT_location
	.byte	33                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	167                             # DW_AT_decl_line
	.word	92                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
	.byte	8                               # Abbrev [8] 0x1ef:0x16 DW_TAG_subprogram
	.byte	13                              # DW_AT_low_pc
	.word	.Lfunc_end7-.Lfunc_begin7       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	27                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	179                             # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	9                               # Abbrev [9] 0x1fa:0xa DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	90
	.byte	32                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	179                             # DW_AT_decl_line
	.word	69                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_rnglists,"",@progbits
	.word	.Ldebug_list_header_end1-.Ldebug_list_header_start1 # Length
.Ldebug_list_header_start1:
	.half	5                               # Version
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
	.word	2                               # Offset entry count
.Lrnglists_table_base0:
	.word	.Ldebug_ranges0-.Lrnglists_table_base0
	.word	.Ldebug_ranges1-.Lrnglists_table_base0
.Ldebug_ranges0:
	.byte	1                               # DW_RLE_base_addressx
	.byte	11                              #   base address index
	.byte	4                               # DW_RLE_offset_pair
	.uleb128 .Ltmp38-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp45-.Lfunc_begin6          #   ending offset
	.byte	4                               # DW_RLE_offset_pair
	.uleb128 .Ltmp46-.Lfunc_begin6          #   starting offset
	.uleb128 .Ltmp47-.Lfunc_begin6          #   ending offset
	.byte	0                               # DW_RLE_end_of_list
.Ldebug_ranges1:
	.byte	3                               # DW_RLE_startx_length
	.byte	4                               #   start index
	.uleb128 .Lfunc_end0-.Lfunc_begin0      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	5                               #   start index
	.uleb128 .Lfunc_end1-.Lfunc_begin1      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	6                               #   start index
	.uleb128 .Lfunc_end2-.Lfunc_begin2      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	7                               #   start index
	.uleb128 .Lfunc_end3-.Lfunc_begin3      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	8                               #   start index
	.uleb128 .Lfunc_end4-.Lfunc_begin4      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	9                               #   start index
	.uleb128 .Lfunc_end5-.Lfunc_begin5      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	11                              #   start index
	.uleb128 .Lfunc_end6-.Lfunc_begin6      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	13                              #   start index
	.uleb128 .Lfunc_end7-.Lfunc_begin7      #   length
	.byte	0                               # DW_RLE_end_of_list
.Ldebug_list_header_end1:
	.section	.debug_str_offsets,"",@progbits
	.word	140                             # Length of String Offsets Set
	.half	5
	.half	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 19.1.7 (https://github.com/PhilippvK/llvm-project.git f8fcd61d1cd23a0ba4412cc6ab878a57ecfd1e4e)" # string offset=0
.Linfo_string1:
	.asciz	"/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/benchmarks/embench/support/beebsc.c" # string offset=110
.Linfo_string2:
	.asciz	"/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/temp/sessions/367/runs/0/mlif/lib/embench" # string offset=203
.Linfo_string3:
	.asciz	"seed"                          # string offset=293
.Linfo_string4:
	.asciz	"long"                          # string offset=298
.Linfo_string5:
	.asciz	"heap_ptr"                      # string offset=303
.Linfo_string6:
	.asciz	"heap_end"                      # string offset=312
.Linfo_string7:
	.asciz	"heap_requested"                # string offset=321
.Linfo_string8:
	.asciz	"unsigned int"                  # string offset=336
.Linfo_string9:
	.asciz	"__size_t"                      # string offset=349
.Linfo_string10:
	.asciz	"size_t"                        # string offset=358
.Linfo_string11:
	.asciz	"int"                           # string offset=365
.Linfo_string12:
	.asciz	"char"                          # string offset=369
.Linfo_string13:
	.asciz	"__uintptr_t"                   # string offset=374
.Linfo_string14:
	.asciz	"uintptr_t"                     # string offset=386
.Linfo_string15:
	.asciz	"malloc_beebs"                  # string offset=396
.Linfo_string16:
	.asciz	"size"                          # string offset=409
.Linfo_string17:
	.asciz	"next_heap_ptr"                 # string offset=414
.Linfo_string18:
	.asciz	"alignment"                     # string offset=428
.Linfo_string19:
	.asciz	"new_ptr"                       # string offset=438
.Linfo_string20:
	.asciz	"padding"                       # string offset=446
.Linfo_string21:
	.asciz	"rand_beebs"                    # string offset=454
.Linfo_string22:
	.asciz	"srand_beebs"                   # string offset=465
.Linfo_string23:
	.asciz	"init_heap_beebs"               # string offset=477
.Linfo_string24:
	.asciz	"check_heap_beebs"              # string offset=493
.Linfo_string25:
	.asciz	"calloc_beebs"                  # string offset=510
.Linfo_string26:
	.asciz	"realloc_beebs"                 # string offset=523
.Linfo_string27:
	.asciz	"free_beebs"                    # string offset=537
.Linfo_string28:
	.asciz	"new_seed"                      # string offset=548
.Linfo_string29:
	.asciz	"heap"                          # string offset=557
.Linfo_string30:
	.asciz	"heap_size"                     # string offset=562
.Linfo_string31:
	.asciz	"nmemb"                         # string offset=572
.Linfo_string32:
	.asciz	"ptr"                           # string offset=578
.Linfo_string33:
	.asciz	"i"                             # string offset=582
	.section	.debug_str_offsets,"",@progbits
	.word	.Linfo_string0
	.word	.Linfo_string1
	.word	.Linfo_string2
	.word	.Linfo_string3
	.word	.Linfo_string4
	.word	.Linfo_string5
	.word	.Linfo_string6
	.word	.Linfo_string7
	.word	.Linfo_string8
	.word	.Linfo_string9
	.word	.Linfo_string10
	.word	.Linfo_string11
	.word	.Linfo_string12
	.word	.Linfo_string13
	.word	.Linfo_string14
	.word	.Linfo_string15
	.word	.Linfo_string16
	.word	.Linfo_string17
	.word	.Linfo_string18
	.word	.Linfo_string19
	.word	.Linfo_string20
	.word	.Linfo_string21
	.word	.Linfo_string22
	.word	.Linfo_string23
	.word	.Linfo_string24
	.word	.Linfo_string25
	.word	.Linfo_string26
	.word	.Linfo_string27
	.word	.Linfo_string28
	.word	.Linfo_string29
	.word	.Linfo_string30
	.word	.Linfo_string31
	.word	.Linfo_string32
	.word	.Linfo_string33
	.section	.debug_addr,"",@progbits
	.word	.Ldebug_addr_end0-.Ldebug_addr_start0 # Length of contribution
.Ldebug_addr_start0:
	.half	5                               # DWARF version number
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
.Laddr_table_base0:
	.word	seed
	.word	heap_ptr
	.word	heap_end
	.word	heap_requested
	.word	.Lfunc_begin0
	.word	.Lfunc_begin1
	.word	.Lfunc_begin2
	.word	.Lfunc_begin3
	.word	.Lfunc_begin4
	.word	.Lfunc_begin5
	.word	.Ltmp19
	.word	.Lfunc_begin6
	.word	.Ltmp49
	.word	.Lfunc_begin7
.Ldebug_addr_end0:
	.ident	"clang version 19.1.7 (https://github.com/PhilippvK/llvm-project.git f8fcd61d1cd23a0ba4412cc6ab878a57ecfd1e4e)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
