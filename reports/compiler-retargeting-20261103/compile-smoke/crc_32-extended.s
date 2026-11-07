	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_f2p2_d2p2_zicsr2p0_zmmul1p0_xisaac1p0"
	.file	"crc_32.c"
	.file	0 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/temp/sessions/367/runs/0/mlif/lib/embench" "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/benchmarks/embench/src/crc32/crc_32.c" md5 0x3ea56eddf4026cb0a8f7a63a4882ef9f
	.file	1 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/src/benchmarks/embench/src/crc32/crc_32.c" md5 0x3ea56eddf4026cb0a8f7a63a4882ef9f
	.section	.text.crc32pseudo,"ax",@progbits
	.globl	crc32pseudo                     # -- Begin function crc32pseudo
	.p2align	2
	.type	crc32pseudo,@function
crc32pseudo:                            # @crc32pseudo
.Lfunc_begin0:
	.loc	1 152 0                         # deps/src/benchmarks/embench/src/crc32/crc_32.c:152:0
	.cfi_sections .debug_frame
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -16
	.cfi_def_cfa_offset 16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	sw	s1, 4(sp)                       # 4-byte Folded Spill
	sw	s2, 0(sp)                       # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	.cfi_offset s1, -12
	.cfi_offset s2, -16
	li	s0, -1
	li	s1, 1024
.Ltmp0:
	#DEBUG_VALUE: crc32pseudo:i <- 0
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- -1
	lui	s2, %hi(crc_32_tab)
	addi	s2, s2, %lo(crc_32_tab)
.Ltmp1:
.LBB_END0_0:
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- $x8
	#DEBUG_VALUE: crc32pseudo:i <- [DW_OP_consts 1024, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_stack_value] $x9
	.loc	1 160 18 prologue_end           # deps/src/benchmarks/embench/src/crc32/crc_32.c:160:18
	call	rand_beebs
.Ltmp2:
	custom17	a0, a0, s0
	custom20	a0, a0, s2
	lw	a0, 0(a0)
.Ltmp3:
	.loc	1 158 17                        # deps/src/benchmarks/embench/src/crc32/crc_32.c:158:17
	addi	s1, s1, -1
.Ltmp4:
	.loc	1 160 18                        # deps/src/benchmarks/embench/src/crc32/crc_32.c:160:18
	custom19	s0, a0, s0
.Ltmp5:
	#DEBUG_VALUE: crc32pseudo:i <- [DW_OP_consts 1024, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_consts 1, DW_OP_plus, DW_OP_stack_value] $x9
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- $x8
	.loc	1 158 3                         # deps/src/benchmarks/embench/src/crc32/crc_32.c:158:3
	bnez	s1, .LBB0_1
.Ltmp6:
.LBB_END0_1:
.LBB0_2:
	#DEBUG_VALUE: crc32pseudo:i <- [DW_OP_consts 1024, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_consts 1, DW_OP_plus, DW_OP_stack_value] $x9
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- $x8
	.loc	1 163 10                        # deps/src/benchmarks/embench/src/crc32/crc_32.c:163:10
	not	a0, s0
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
.Ltmp7:
	.loc	1 0 10 is_stmt 0                # deps/src/benchmarks/embench/src/crc32/crc_32.c:0:10
	lw	s1, 4(sp)                       # 4-byte Folded Reload
.Ltmp8:
	lw	s2, 0(sp)                       # 4-byte Folded Reload
	.loc	1 163 3 epilogue_begin          # deps/src/benchmarks/embench/src/crc32/crc_32.c:163:3
	addi	sp, sp, 16
	ret
.Ltmp9:
.LBB_END0_2:
.Lfunc_end0:
	.size	crc32pseudo, .Lfunc_end0-crc32pseudo
	.cfi_endproc
	.file	2 "/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu" "deps/src/benchmarks/embench/support/beebsc.h" md5 0x8632a88600182a29557f1df7f82169aa
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.crc32pseudo
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin0                   # function address
	.byte	3                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin0-.Lfunc_begin0
	.uleb128 .LBB_END0_0-.Lfunc_begin0
	.byte	8
	.byte	1                               # BB id
	.uleb128 .LBB0_1-.LBB_END0_0
	.uleb128 .LBB_END0_1-.LBB0_1
	.byte	8
	.byte	2                               # BB id
	.uleb128 .LBB0_2-.LBB_END0_1
	.uleb128 .LBB_END0_2-.LBB0_2
	.byte	1
	.section	.text.crc32pseudo,"ax",@progbits
                                        # -- End function
	.section	.text.initialise_benchmark,"ax",@progbits
	.globl	initialise_benchmark            # -- Begin function initialise_benchmark
	.p2align	2
	.type	initialise_benchmark,@function
initialise_benchmark:                   # @initialise_benchmark
.Lfunc_begin1:
	.cfi_startproc
# %bb.0:
	.loc	1 169 1 prologue_end is_stmt 1  # deps/src/benchmarks/embench/src/crc32/crc_32.c:169:1
	ret
.Ltmp10:
.LBB_END1_0:
.Lfunc_end1:
	.size	initialise_benchmark, .Lfunc_end1-initialise_benchmark
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.initialise_benchmark
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin1                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin1-.Lfunc_begin1
	.uleb128 .LBB_END1_0-.Lfunc_begin1
	.byte	1
	.section	.text.initialise_benchmark,"ax",@progbits
                                        # -- End function
	.section	.text.warm_caches,"ax",@progbits
	.globl	warm_caches                     # -- Begin function warm_caches
	.p2align	2
	.type	warm_caches,@function
warm_caches:                            # @warm_caches
.Lfunc_begin2:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: warm_caches:heat <- $x10
	.loc	1 177 14 prologue_end           # deps/src/benchmarks/embench/src/crc32/crc_32.c:177:14
	tail	benchmark_body
.Ltmp11:
.LBB_END2_0:
.Lfunc_end2:
	.size	warm_caches, .Lfunc_end2-warm_caches
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.warm_caches
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin2                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin2-.Lfunc_begin2
	.uleb128 .LBB_END2_0-.Lfunc_begin2
	.byte	3
	.section	.text.warm_caches,"ax",@progbits
                                        # -- End function
	.section	.text.benchmark_body,"ax",@progbits
	.p2align	2                               # -- Begin function benchmark_body
	.type	benchmark_body,@function
benchmark_body:                         # @benchmark_body
.Lfunc_begin3:
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: benchmark_body:rpt <- $x10
	#DEBUG_VALUE: benchmark_body:i <- 0
	#DEBUG_VALUE: benchmark_body:rpt <- $x10
	.loc	1 196 3 prologue_end            # deps/src/benchmarks/embench/src/crc32/crc_32.c:196:3
	blez	a0, .LBB3_6
.Ltmp12:
.LBB_END3_0:
.LBB3_1:
	#DEBUG_VALUE: benchmark_body:i <- 0
	#DEBUG_VALUE: benchmark_body:rpt <- $x10
	addi	sp, sp, -32
	.cfi_def_cfa_offset 32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	sw	s1, 20(sp)                      # 4-byte Folded Spill
	sw	s2, 16(sp)                      # 4-byte Folded Spill
	sw	s3, 12(sp)                      # 4-byte Folded Spill
	sw	s4, 8(sp)                       # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	.cfi_offset s1, -12
	.cfi_offset s2, -16
	.cfi_offset s3, -20
	.cfi_offset s4, -24
	mv	s0, a0
.Ltmp13:
	#DEBUG_VALUE: benchmark_body:rpt <- $x8
	.loc	1 0 3 is_stmt 0                 # deps/src/benchmarks/embench/src/crc32/crc_32.c:0:3
	li	s1, 0
	lui	s2, %hi(crc_32_tab)
	addi	s2, s2, %lo(crc_32_tab)
.Ltmp14:
.LBB_END3_1:
.LBB3_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_3 Depth 2
	#DEBUG_VALUE: benchmark_body:rpt <- $x8
	#DEBUG_VALUE: benchmark_body:i <- $x9
	.loc	1 198 7 is_stmt 1               # deps/src/benchmarks/embench/src/crc32/crc_32.c:198:7
	li	a0, 0
	call	srand_beebs
.Ltmp15:
	.loc	1 0 7 is_stmt 0                 # deps/src/benchmarks/embench/src/crc32/crc_32.c:0:7
	li	s3, -1
	li	s4, 1024
	#DEBUG_VALUE: crc32pseudo:i <- 0
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- -1
.Ltmp16:
.LBB_END3_2:
.LBB3_3:                                #   Parent Loop BB3_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#DEBUG_VALUE: benchmark_body:i <- $x9
	#DEBUG_VALUE: benchmark_body:rpt <- $x8
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- $x19
	#DEBUG_VALUE: crc32pseudo:i <- [DW_OP_consts 1024, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_stack_value] $x20
	.loc	1 160 18 is_stmt 1              # deps/src/benchmarks/embench/src/crc32/crc_32.c:160:18
	call	rand_beebs
.Ltmp17:
	custom17	a0, a0, s3
	custom20	a0, a0, s2
	lw	a0, 0(a0)
.Ltmp18:
	.loc	1 158 17                        # deps/src/benchmarks/embench/src/crc32/crc_32.c:158:17
	addi	s4, s4, -1
.Ltmp19:
	.loc	1 160 18                        # deps/src/benchmarks/embench/src/crc32/crc_32.c:160:18
	custom19	s3, a0, s3
.Ltmp20:
	#DEBUG_VALUE: crc32pseudo:i <- [DW_OP_consts 1024, DW_OP_minus, DW_OP_consts 18446744073709551615, DW_OP_div, DW_OP_consts 1, DW_OP_plus, DW_OP_stack_value] $x20
	#DEBUG_VALUE: crc32pseudo:oldcrc32 <- $x19
	.loc	1 158 3                         # deps/src/benchmarks/embench/src/crc32/crc_32.c:158:3
	bnez	s4, .LBB3_3
.Ltmp21:
.LBB_END3_3:
.LBB3_4:                                #   in Loop: Header=BB3_2 Depth=1
	#DEBUG_VALUE: benchmark_body:i <- $x9
	#DEBUG_VALUE: benchmark_body:rpt <- $x8
	#DEBUG_VALUE: benchmark_body:r <- [DW_OP_constu 18446744073709551615, DW_OP_xor, DW_OP_stack_value] $x19
	.loc	1 196 25                        # deps/src/benchmarks/embench/src/crc32/crc_32.c:196:25
	addi	s1, s1, 1
.Ltmp22:
	#DEBUG_VALUE: benchmark_body:i <- $x9
	.loc	1 196 3 is_stmt 0               # deps/src/benchmarks/embench/src/crc32/crc_32.c:196:3
	bne	s1, s0, .LBB3_2
.Ltmp23:
.LBB_END3_4:
.LBB3_5:
	#DEBUG_VALUE: benchmark_body:r <- [DW_OP_constu 18446744073709551615, DW_OP_xor, DW_OP_stack_value] $x19
	#DEBUG_VALUE: benchmark_body:i <- $x9
	#DEBUG_VALUE: benchmark_body:rpt <- $x8
	.loc	1 202 19 is_stmt 1              # deps/src/benchmarks/embench/src/crc32/crc_32.c:202:19
	not	a0, s3
	slli	a0, a0, 17
	srli	a0, a0, 17
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
.Ltmp24:
	.loc	1 0 19 is_stmt 0                # deps/src/benchmarks/embench/src/crc32/crc_32.c:0:19
	lw	s1, 20(sp)                      # 4-byte Folded Reload
.Ltmp25:
	lw	s2, 16(sp)                      # 4-byte Folded Reload
	lw	s3, 12(sp)                      # 4-byte Folded Reload
.Ltmp26:
	lw	s4, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 32
	.loc	1 202 3                         # deps/src/benchmarks/embench/src/crc32/crc_32.c:202:3
	ret
.LBB_END3_5:
.LBB3_6:
.Ltmp27:
	#DEBUG_VALUE: benchmark_body:i <- 0
	#DEBUG_VALUE: benchmark_body:rpt <- $x10
	.loc	1 0 3                           # deps/src/benchmarks/embench/src/crc32/crc_32.c:0:3
	li	a0, 0
.Ltmp28:
	.loc	1 202 3                         # deps/src/benchmarks/embench/src/crc32/crc_32.c:202:3
	ret
.Ltmp29:
.LBB_END3_6:
.Lfunc_end3:
	.size	benchmark_body, .Lfunc_end3-benchmark_body
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.benchmark_body
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin3                   # function address
	.byte	7                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin3-.Lfunc_begin3
	.uleb128 .LBB_END3_0-.Lfunc_begin3
	.byte	8
	.byte	1                               # BB id
	.uleb128 .LBB3_1-.LBB_END3_0
	.uleb128 .LBB_END3_1-.LBB3_1
	.byte	8
	.byte	2                               # BB id
	.uleb128 .LBB3_2-.LBB_END3_1
	.uleb128 .LBB_END3_2-.LBB3_2
	.byte	8
	.byte	3                               # BB id
	.uleb128 .LBB3_3-.LBB_END3_2
	.uleb128 .LBB_END3_3-.LBB3_3
	.byte	8
	.byte	4                               # BB id
	.uleb128 .LBB3_4-.LBB_END3_3
	.uleb128 .LBB_END3_4-.LBB3_4
	.byte	8
	.byte	5                               # BB id
	.uleb128 .LBB3_5-.LBB_END3_4
	.uleb128 .LBB_END3_5-.LBB3_5
	.byte	1
	.byte	7                               # BB id
	.uleb128 .LBB3_6-.LBB_END3_5
	.uleb128 .LBB_END3_6-.LBB3_6
	.byte	1
	.section	.text.benchmark_body,"ax",@progbits
                                        # -- End function
	.section	.text.benchmark,"ax",@progbits
	.globl	benchmark                       # -- Begin function benchmark
	.p2align	2
	.type	benchmark,@function
benchmark:                              # @benchmark
.Lfunc_begin4:
	.cfi_startproc
# %bb.0:
	.loc	1 186 10 prologue_end is_stmt 1 # deps/src/benchmarks/embench/src/crc32/crc_32.c:186:10
	li	a0, 170
.Ltmp30:
	tail	benchmark_body
.Ltmp31:
.LBB_END4_0:
.Lfunc_end4:
	.size	benchmark, .Lfunc_end4-benchmark
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.benchmark
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin4                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin4-.Lfunc_begin4
	.uleb128 .LBB_END4_0-.Lfunc_begin4
	.byte	3
	.section	.text.benchmark,"ax",@progbits
                                        # -- End function
	.section	.text.verify_benchmark,"ax",@progbits
	.globl	verify_benchmark                # -- Begin function verify_benchmark
	.p2align	2
	.type	verify_benchmark,@function
verify_benchmark:                       # @verify_benchmark
.Lfunc_begin5:
	.loc	1 208 0                         # deps/src/benchmarks/embench/src/crc32/crc_32.c:208:0
	.cfi_startproc
# %bb.0:
	#DEBUG_VALUE: verify_benchmark:r <- $x10
	lui	a1, 3
	addi	a1, a1, -855
.Ltmp32:
	.loc	1 209 16 prologue_end           # deps/src/benchmarks/embench/src/crc32/crc_32.c:209:16
	xor	a0, a0, a1
.Ltmp33:
	seqz	a0, a0
	.loc	1 209 3 is_stmt 0               # deps/src/benchmarks/embench/src/crc32/crc_32.c:209:3
	ret
.Ltmp34:
.LBB_END5_0:
.Lfunc_end5:
	.size	verify_benchmark, .Lfunc_end5-verify_benchmark
	.cfi_endproc
	.section	.llvm_bb_addr_map,"o",@llvm_bb_addr_map,.text.verify_benchmark
	.byte	2                               # version
	.byte	0                               # feature
	.word	.Lfunc_begin5                   # function address
	.byte	1                               # number of basic blocks
	.byte	0                               # BB id
	.uleb128 .Lfunc_begin5-.Lfunc_begin5
	.uleb128 .LBB_END5_0-.Lfunc_begin5
	.byte	1
	.section	.text.verify_benchmark,"ax",@progbits
                                        # -- End function
	.type	crc_32_tab,@object              # @crc_32_tab
	.section	.rodata.crc_32_tab,"a",@progbits
	.p2align	2, 0x0
crc_32_tab:
	.word	0                               # 0x0
	.word	1996959894                      # 0x77073096
	.word	3993919788                      # 0xee0e612c
	.word	2567524794                      # 0x990951ba
	.word	124634137                       # 0x76dc419
	.word	1886057615                      # 0x706af48f
	.word	3915621685                      # 0xe963a535
	.word	2657392035                      # 0x9e6495a3
	.word	249268274                       # 0xedb8832
	.word	2044508324                      # 0x79dcb8a4
	.word	3772115230                      # 0xe0d5e91e
	.word	2547177864                      # 0x97d2d988
	.word	162941995                       # 0x9b64c2b
	.word	2125561021                      # 0x7eb17cbd
	.word	3887607047                      # 0xe7b82d07
	.word	2428444049                      # 0x90bf1d91
	.word	498536548                       # 0x1db71064
	.word	1789927666                      # 0x6ab020f2
	.word	4089016648                      # 0xf3b97148
	.word	2227061214                      # 0x84be41de
	.word	450548861                       # 0x1adad47d
	.word	1843258603                      # 0x6ddde4eb
	.word	4107580753                      # 0xf4d4b551
	.word	2211677639                      # 0x83d385c7
	.word	325883990                       # 0x136c9856
	.word	1684777152                      # 0x646ba8c0
	.word	4251122042                      # 0xfd62f97a
	.word	2321926636                      # 0x8a65c9ec
	.word	335633487                       # 0x14015c4f
	.word	1661365465                      # 0x63066cd9
	.word	4195302755                      # 0xfa0f3d63
	.word	2366115317                      # 0x8d080df5
	.word	997073096                       # 0x3b6e20c8
	.word	1281953886                      # 0x4c69105e
	.word	3579855332                      # 0xd56041e4
	.word	2724688242                      # 0xa2677172
	.word	1006888145                      # 0x3c03e4d1
	.word	1258607687                      # 0x4b04d447
	.word	3524101629                      # 0xd20d85fd
	.word	2768942443                      # 0xa50ab56b
	.word	901097722                       # 0x35b5a8fa
	.word	1119000684                      # 0x42b2986c
	.word	3686517206                      # 0xdbbbc9d6
	.word	2898065728                      # 0xacbcf940
	.word	853044451                       # 0x32d86ce3
	.word	1172266101                      # 0x45df5c75
	.word	3705015759                      # 0xdcd60dcf
	.word	2882616665                      # 0xabd13d59
	.word	651767980                       # 0x26d930ac
	.word	1373503546                      # 0x51de003a
	.word	3369554304                      # 0xc8d75180
	.word	3218104598                      # 0xbfd06116
	.word	565507253                       # 0x21b4f4b5
	.word	1454621731                      # 0x56b3c423
	.word	3485111705                      # 0xcfba9599
	.word	3099436303                      # 0xb8bda50f
	.word	671266974                       # 0x2802b89e
	.word	1594198024                      # 0x5f058808
	.word	3322730930                      # 0xc60cd9b2
	.word	2970347812                      # 0xb10be924
	.word	795835527                       # 0x2f6f7c87
	.word	1483230225                      # 0x58684c11
	.word	3244367275                      # 0xc1611dab
	.word	3060149565                      # 0xb6662d3d
	.word	1994146192                      # 0x76dc4190
	.word	31158534                        # 0x1db7106
	.word	2563907772                      # 0x98d220bc
	.word	4023717930                      # 0xefd5102a
	.word	1907459465                      # 0x71b18589
	.word	112637215                       # 0x6b6b51f
	.word	2680153253                      # 0x9fbfe4a5
	.word	3904427059                      # 0xe8b8d433
	.word	2013776290                      # 0x7807c9a2
	.word	251722036                       # 0xf00f934
	.word	2517215374                      # 0x9609a88e
	.word	3775830040                      # 0xe10e9818
	.word	2137656763                      # 0x7f6a0dbb
	.word	141376813                       # 0x86d3d2d
	.word	2439277719                      # 0x91646c97
	.word	3865271297                      # 0xe6635c01
	.word	1802195444                      # 0x6b6b51f4
	.word	476864866                       # 0x1c6c6162
	.word	2238001368                      # 0x856530d8
	.word	4066508878                      # 0xf262004e
	.word	1812370925                      # 0x6c0695ed
	.word	453092731                       # 0x1b01a57b
	.word	2181625025                      # 0x8208f4c1
	.word	4111451223                      # 0xf50fc457
	.word	1706088902                      # 0x65b0d9c6
	.word	314042704                       # 0x12b7e950
	.word	2344532202                      # 0x8bbeb8ea
	.word	4240017532                      # 0xfcb9887c
	.word	1658658271                      # 0x62dd1ddf
	.word	366619977                       # 0x15da2d49
	.word	2362670323                      # 0x8cd37cf3
	.word	4224994405                      # 0xfbd44c65
	.word	1303535960                      # 0x4db26158
	.word	984961486                       # 0x3ab551ce
	.word	2747007092                      # 0xa3bc0074
	.word	3569037538                      # 0xd4bb30e2
	.word	1256170817                      # 0x4adfa541
	.word	1037604311                      # 0x3dd895d7
	.word	2765210733                      # 0xa4d1c46d
	.word	3554079995                      # 0xd3d6f4fb
	.word	1131014506                      # 0x4369e96a
	.word	879679996                       # 0x346ed9fc
	.word	2909243462                      # 0xad678846
	.word	3663771856                      # 0xda60b8d0
	.word	1141124467                      # 0x44042d73
	.word	855842277                       # 0x33031de5
	.word	2852801631                      # 0xaa0a4c5f
	.word	3708648649                      # 0xdd0d7cc9
	.word	1342533948                      # 0x5005713c
	.word	654459306                       # 0x270241aa
	.word	3188396048                      # 0xbe0b1010
	.word	3373015174                      # 0xc90c2086
	.word	1466479909                      # 0x5768b525
	.word	544179635                       # 0x206f85b3
	.word	3110523913                      # 0xb966d409
	.word	3462522015                      # 0xce61e49f
	.word	1591671054                      # 0x5edef90e
	.word	702138776                       # 0x29d9c998
	.word	2966460450                      # 0xb0d09822
	.word	3352799412                      # 0xc7d7a8b4
	.word	1504918807                      # 0x59b33d17
	.word	783551873                       # 0x2eb40d81
	.word	3082640443                      # 0xb7bd5c3b
	.word	3233442989                      # 0xc0ba6cad
	.word	3988292384                      # 0xedb88320
	.word	2596254646                      # 0x9abfb3b6
	.word	62317068                        # 0x3b6e20c
	.word	1957810842                      # 0x74b1d29a
	.word	3939845945                      # 0xead54739
	.word	2647816111                      # 0x9dd277af
	.word	81470997                        # 0x4db2615
	.word	1943803523                      # 0x73dc1683
	.word	3814918930                      # 0xe3630b12
	.word	2489596804                      # 0x94643b84
	.word	225274430                       # 0xd6d6a3e
	.word	2053790376                      # 0x7a6a5aa8
	.word	3826175755                      # 0xe40ecf0b
	.word	2466906013                      # 0x9309ff9d
	.word	167816743                       # 0xa00ae27
	.word	2097651377                      # 0x7d079eb1
	.word	4027552580                      # 0xf00f9344
	.word	2265490386                      # 0x8708a3d2
	.word	503444072                       # 0x1e01f268
	.word	1762050814                      # 0x6906c2fe
	.word	4150417245                      # 0xf762575d
	.word	2154129355                      # 0x806567cb
	.word	426522225                       # 0x196c3671
	.word	1852507879                      # 0x6e6b06e7
	.word	4275313526                      # 0xfed41b76
	.word	2312317920                      # 0x89d32be0
	.word	282753626                       # 0x10da7a5a
	.word	1742555852                      # 0x67dd4acc
	.word	4189708143                      # 0xf9b9df6f
	.word	2394877945                      # 0x8ebeeff9
	.word	397917763                       # 0x17b7be43
	.word	1622183637                      # 0x60b08ed5
	.word	3604390888                      # 0xd6d6a3e8
	.word	2714866558                      # 0xa1d1937e
	.word	953729732                       # 0x38d8c2c4
	.word	1340076626                      # 0x4fdff252
	.word	3518719985                      # 0xd1bb67f1
	.word	2797360999                      # 0xa6bc5767
	.word	1068828381                      # 0x3fb506dd
	.word	1219638859                      # 0x48b2364b
	.word	3624741850                      # 0xd80d2bda
	.word	2936675148                      # 0xaf0a1b4c
	.word	906185462                       # 0x36034af6
	.word	1090812512                      # 0x41047a60
	.word	3747672003                      # 0xdf60efc3
	.word	2825379669                      # 0xa867df55
	.word	829329135                       # 0x316e8eef
	.word	1181335161                      # 0x4669be79
	.word	3412177804                      # 0xcb61b38c
	.word	3160834842                      # 0xbc66831a
	.word	628085408                       # 0x256fd2a0
	.word	1382605366                      # 0x5268e236
	.word	3423369109                      # 0xcc0c7795
	.word	3138078467                      # 0xbb0b4703
	.word	570562233                       # 0x220216b9
	.word	1426400815                      # 0x5505262f
	.word	3317316542                      # 0xc5ba3bbe
	.word	2998733608                      # 0xb2bd0b28
	.word	733239954                       # 0x2bb45a92
	.word	1555261956                      # 0x5cb36a04
	.word	3268935591                      # 0xc2d7ffa7
	.word	3050360625                      # 0xb5d0cf31
	.word	752459403                       # 0x2cd99e8b
	.word	1541320221                      # 0x5bdeae1d
	.word	2607071920                      # 0x9b64c2b0
	.word	3965973030                      # 0xec63f226
	.word	1969922972                      # 0x756aa39c
	.word	40735498                        # 0x26d930a
	.word	2617837225                      # 0x9c0906a9
	.word	3943577151                      # 0xeb0e363f
	.word	1913087877                      # 0x72076785
	.word	83908371                        # 0x5005713
	.word	2512341634                      # 0x95bf4a82
	.word	3803740692                      # 0xe2b87a14
	.word	2075208622                      # 0x7bb12bae
	.word	213261112                       # 0xcb61b38
	.word	2463272603                      # 0x92d28e9b
	.word	3855990285                      # 0xe5d5be0d
	.word	2094854071                      # 0x7cdcefb7
	.word	198958881                       # 0xbdbdf21
	.word	2262029012                      # 0x86d3d2d4
	.word	4057260610                      # 0xf1d4e242
	.word	1759359992                      # 0x68ddb3f8
	.word	534414190                       # 0x1fda836e
	.word	2176718541                      # 0x81be16cd
	.word	4139329115                      # 0xf6b9265b
	.word	1873836001                      # 0x6fb077e1
	.word	414664567                       # 0x18b74777
	.word	2282248934                      # 0x88085ae6
	.word	4279200368                      # 0xff0f6a70
	.word	1711684554                      # 0x66063bca
	.word	285281116                       # 0x11010b5c
	.word	2405801727                      # 0x8f659eff
	.word	4167216745                      # 0xf862ae69
	.word	1634467795                      # 0x616bffd3
	.word	376229701                       # 0x166ccf45
	.word	2685067896                      # 0xa00ae278
	.word	3608007406                      # 0xd70dd2ee
	.word	1308918612                      # 0x4e048354
	.word	956543938                       # 0x3903b3c2
	.word	2808555105                      # 0xa7672661
	.word	3495958263                      # 0xd06016f7
	.word	1231636301                      # 0x4969474d
	.word	1047427035                      # 0x3e6e77db
	.word	2932959818                      # 0xaed16a4a
	.word	3654703836                      # 0xd9d65adc
	.word	1088359270                      # 0x40df0b66
	.word	936918000                       # 0x37d83bf0
	.word	2847714899                      # 0xa9bcae53
	.word	3736837829                      # 0xdebb9ec5
	.word	1202900863                      # 0x47b2cf7f
	.word	817233897                       # 0x30b5ffe9
	.word	3183342108                      # 0xbdbdf21c
	.word	3401237130                      # 0xcabac28a
	.word	1404277552                      # 0x53b39330
	.word	615818150                       # 0x24b4a3a6
	.word	3134207493                      # 0xbad03605
	.word	3453421203                      # 0xcdd70693
	.word	1423857449                      # 0x54de5729
	.word	601450431                       # 0x23d967bf
	.word	3009837614                      # 0xb3667a2e
	.word	3294710456                      # 0xc4614ab8
	.word	1567103746                      # 0x5d681b02
	.word	711928724                       # 0x2a6f2b94
	.word	3020668471                      # 0xb40bbe37
	.word	3272380065                      # 0xc30c8ea1
	.word	1510334235                      # 0x5a05df1b
	.word	755167117                       # 0x2d02ef8d
	.size	crc_32_tab, 1024

	.section	.debug_loclists,"",@progbits
	.word	.Ldebug_list_header_end0-.Ldebug_list_header_start0 # Length
.Ldebug_list_header_start0:
	.half	5                               # Version
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
	.word	7                               # Offset entry count
.Lloclists_table_base0:
	.word	.Ldebug_loc0-.Lloclists_table_base0
	.word	.Ldebug_loc1-.Lloclists_table_base0
	.word	.Ldebug_loc2-.Lloclists_table_base0
	.word	.Ldebug_loc3-.Lloclists_table_base0
	.word	.Ldebug_loc4-.Lloclists_table_base0
	.word	.Ldebug_loc5-.Lloclists_table_base0
	.word	.Ldebug_loc6-.Lloclists_table_base0
.Ldebug_loc0:
	.byte	1                               # DW_LLE_base_addressx
	.byte	1                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp0-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp1-.Lfunc_begin0           #   ending offset
	.byte	3                               # Loc expr size
	.byte	17                              # DW_OP_consts
	.byte	0                               # 0
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp1-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp4-.Lfunc_begin0           #   ending offset
	.byte	10                              # Loc expr size
	.byte	121                             # DW_OP_breg9
	.byte	0                               # 0
	.byte	17                              # DW_OP_consts
	.byte	128                             # 1024
	.byte	8                               # 
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	127                             # -1
	.byte	27                              # DW_OP_div
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp5-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp8-.Lfunc_begin0           #   ending offset
	.byte	13                              # Loc expr size
	.byte	121                             # DW_OP_breg9
	.byte	0                               # 0
	.byte	17                              # DW_OP_consts
	.byte	128                             # 1024
	.byte	8                               # 
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	127                             # -1
	.byte	27                              # DW_OP_div
	.byte	17                              # DW_OP_consts
	.byte	1                               # 1
	.byte	34                              # DW_OP_plus
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc1:
	.byte	1                               # DW_LLE_base_addressx
	.byte	1                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp0-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp1-.Lfunc_begin0           #   ending offset
	.byte	3                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	32                              # DW_OP_not
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp1-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp7-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	88                              # DW_OP_reg8
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc2:
	.byte	1                               # DW_LLE_base_addressx
	.byte	5                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Lfunc_begin3-.Lfunc_begin3    #   starting offset
	.uleb128 .Ltmp13-.Lfunc_begin3          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp13-.Lfunc_begin3          #   starting offset
	.uleb128 .Ltmp24-.Lfunc_begin3          #   ending offset
	.byte	1                               # Loc expr size
	.byte	88                              # DW_OP_reg8
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp27-.Lfunc_begin3          #   starting offset
	.uleb128 .Ltmp28-.Lfunc_begin3          #   ending offset
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc3:
	.byte	1                               # DW_LLE_base_addressx
	.byte	5                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Lfunc_begin3-.Lfunc_begin3    #   starting offset
	.uleb128 .Ltmp14-.Lfunc_begin3          #   ending offset
	.byte	3                               # Loc expr size
	.byte	17                              # DW_OP_consts
	.byte	0                               # 0
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp14-.Lfunc_begin3          #   starting offset
	.uleb128 .Ltmp25-.Lfunc_begin3          #   ending offset
	.byte	1                               # Loc expr size
	.byte	89                              # DW_OP_reg9
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp27-.Lfunc_begin3          #   starting offset
	.uleb128 .Lfunc_end3-.Lfunc_begin3      #   ending offset
	.byte	3                               # Loc expr size
	.byte	17                              # DW_OP_consts
	.byte	0                               # 0
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc4:
	.byte	1                               # DW_LLE_base_addressx
	.byte	5                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp16-.Lfunc_begin3          #   starting offset
	.uleb128 .Ltmp19-.Lfunc_begin3          #   ending offset
	.byte	10                              # Loc expr size
	.byte	132                             # DW_OP_breg20
	.byte	0                               # 0
	.byte	17                              # DW_OP_consts
	.byte	128                             # 1024
	.byte	8                               # 
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	127                             # -1
	.byte	27                              # DW_OP_div
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp20-.Lfunc_begin3          #   starting offset
	.uleb128 .Ltmp21-.Lfunc_begin3          #   ending offset
	.byte	13                              # Loc expr size
	.byte	132                             # DW_OP_breg20
	.byte	0                               # 0
	.byte	17                              # DW_OP_consts
	.byte	128                             # 1024
	.byte	8                               # 
	.byte	28                              # DW_OP_minus
	.byte	17                              # DW_OP_consts
	.byte	127                             # -1
	.byte	27                              # DW_OP_div
	.byte	17                              # DW_OP_consts
	.byte	1                               # 1
	.byte	34                              # DW_OP_plus
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc5:
	.byte	1                               # DW_LLE_base_addressx
	.byte	5                               #   base address index
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp21-.Lfunc_begin3          #   starting offset
	.uleb128 .Ltmp26-.Lfunc_begin3          #   ending offset
	.byte	6                               # Loc expr size
	.byte	131                             # DW_OP_breg19
	.byte	0                               # 0
	.byte	48                              # DW_OP_lit0
	.byte	32                              # DW_OP_not
	.byte	39                              # DW_OP_xor
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc6:
	.byte	3                               # DW_LLE_startx_length
	.byte	11                              #   start index
	.uleb128 .Ltmp33-.Lfunc_begin5          #   length
	.byte	1                               # Loc expr size
	.byte	90                              # DW_OP_reg10
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
	.byte	1                               # DW_TAG_array_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	33                              # DW_TAG_subrange_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	55                              # DW_AT_count
	.byte	5                               # DW_FORM_data2
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
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
	.byte	7                               # Abbreviation Code
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
	.byte	8                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
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
	.byte	10                              # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	72                              # DW_TAG_call_site
	.byte	0                               # DW_CHILDREN_no
	.byte	127                             # DW_AT_call_origin
	.byte	19                              # DW_FORM_ref4
	.byte	125                             # DW_AT_call_return_pc
	.byte	27                              # DW_FORM_addrx
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	0                               # DW_CHILDREN_no
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
	.byte	60                              # DW_AT_declaration
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
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
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
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
	.byte	15                              # Abbreviation Code
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
	.byte	16                              # Abbreviation Code
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
	.byte	17                              # Abbreviation Code
	.byte	72                              # DW_TAG_call_site
	.byte	0                               # DW_CHILDREN_no
	.byte	127                             # DW_AT_call_origin
	.byte	19                              # DW_FORM_ref4
	.ascii	"\202\001"                      # DW_AT_call_tail_call
	.byte	25                              # DW_FORM_flag_present
	.ascii	"\201\001"                      # DW_AT_call_pc
	.byte	27                              # DW_FORM_addrx
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	18                              # Abbreviation Code
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
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	19                              # Abbreviation Code
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
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	49                              # DW_AT_abstract_origin
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	23                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	32                              # DW_AT_inline
	.byte	33                              # DW_FORM_implicit_const
	.byte	1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	24                              # Abbreviation Code
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
	.byte	60                              # DW_AT_declaration
	.byte	25                              # DW_FORM_flag_present
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	25                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	26                              # Abbreviation Code
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
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.word	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.half	5                               # DWARF version number
	.byte	1                               # DWARF Unit Type
	.byte	4                               # Address Size (in bytes)
	.word	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	1                               # Abbrev [1] 0xc:0x163 DW_TAG_compile_unit
	.byte	0                               # DW_AT_producer
	.half	29                              # DW_AT_language
	.byte	1                               # DW_AT_name
	.word	.Lstr_offsets_base0             # DW_AT_str_offsets_base
	.word	.Lline_table_start0             # DW_AT_stmt_list
	.byte	2                               # DW_AT_comp_dir
	.word	0                               # DW_AT_low_pc
	.byte	0                               # DW_AT_ranges
	.word	.Laddr_table_base0              # DW_AT_addr_base
	.word	.Lrnglists_table_base0          # DW_AT_rnglists_base
	.word	.Lloclists_table_base0          # DW_AT_loclists_base
	.byte	2                               # Abbrev [2] 0x2b:0xb DW_TAG_variable
	.byte	3                               # DW_AT_name
	.word	54                              # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	103                             # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	0
	.byte	3                               # Abbrev [3] 0x36:0xd DW_TAG_array_type
	.word	67                              # DW_AT_type
	.byte	4                               # Abbrev [4] 0x3b:0x7 DW_TAG_subrange_type
	.word	92                              # DW_AT_type
	.half	256                             # DW_AT_count
	.byte	0                               # End Of Children Mark
	.byte	5                               # Abbrev [5] 0x43:0x5 DW_TAG_const_type
	.word	72                              # DW_AT_type
	.byte	6                               # Abbrev [6] 0x48:0x8 DW_TAG_typedef
	.word	80                              # DW_AT_type
	.byte	6                               # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	52                              # DW_AT_decl_line
	.byte	6                               # Abbrev [6] 0x50:0x8 DW_TAG_typedef
	.word	88                              # DW_AT_type
	.byte	5                               # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	45                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x58:0x4 DW_TAG_base_type
	.byte	4                               # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0x5c:0x4 DW_TAG_base_type
	.byte	7                               # DW_AT_name
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # DW_AT_encoding
	.byte	6                               # Abbrev [6] 0x60:0x8 DW_TAG_typedef
	.word	104                             # DW_AT_type
	.byte	9                               # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	44                              # DW_AT_decl_line
	.byte	7                               # Abbrev [7] 0x68:0x4 DW_TAG_base_type
	.byte	8                               # DW_AT_name
	.byte	8                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	7                               # Abbrev [7] 0x6c:0x4 DW_TAG_base_type
	.byte	10                              # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	9                               # Abbrev [9] 0x70:0x1f DW_TAG_subprogram
	.byte	1                               # DW_AT_low_pc
	.word	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.word	280                             # DW_AT_abstract_origin
	.byte	10                              # Abbrev [10] 0x7c:0x6 DW_TAG_variable
	.byte	0                               # DW_AT_location
	.word	288                             # DW_AT_abstract_origin
	.byte	10                              # Abbrev [10] 0x82:0x6 DW_TAG_variable
	.byte	1                               # DW_AT_location
	.word	296                             # DW_AT_abstract_origin
	.byte	11                              # Abbrev [11] 0x88:0x6 DW_TAG_call_site
	.word	143                             # DW_AT_call_origin
	.byte	2                               # DW_AT_call_return_pc
	.byte	0                               # End Of Children Mark
	.byte	12                              # Abbrev [12] 0x8f:0x8 DW_TAG_subprogram
	.byte	11                              # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	48                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	108                             # DW_AT_type
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	13                              # Abbrev [13] 0x97:0xb DW_TAG_subprogram
	.byte	3                               # DW_AT_low_pc
	.word	.Lfunc_end1-.Lfunc_begin1       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	17                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	167                             # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	14                              # Abbrev [14] 0xa2:0x24 DW_TAG_subprogram
	.byte	4                               # DW_AT_low_pc
	.word	.Lfunc_end2-.Lfunc_begin2       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	18                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	175                             # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_external
	.byte	15                              # Abbrev [15] 0xad:0xa DW_TAG_formal_parameter
	.byte	1                               # DW_AT_location
	.byte	90
	.byte	22                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	175                             # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	16                              # Abbrev [16] 0xb7:0x8 DW_TAG_variable
	.byte	23                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	177                             # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	17                              # Abbrev [17] 0xbf:0x6 DW_TAG_call_site
	.word	198                             # DW_AT_call_origin
                                        # DW_AT_call_tail_call
	.byte	4                               # DW_AT_call_pc
	.byte	0                               # End Of Children Mark
	.byte	18                              # Abbrev [18] 0xc6:0x52 DW_TAG_subprogram
	.byte	5                               # DW_AT_low_pc
	.word	.Lfunc_end3-.Lfunc_begin3       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	19                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	191                             # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	108                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0xd5:0x9 DW_TAG_formal_parameter
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	191                             # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	20                              # Abbrev [20] 0xde:0x9 DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	13                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	193                             # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	20                              # Abbrev [20] 0xe7:0x9 DW_TAG_variable
	.byte	5                               # DW_AT_location
	.byte	25                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	194                             # DW_AT_decl_line
	.word	80                              # DW_AT_type
	.byte	21                              # Abbrev [21] 0xf0:0x1b DW_TAG_inlined_subroutine
	.word	280                             # DW_AT_abstract_origin
	.byte	6                               # DW_AT_low_pc
	.word	.Ltmp21-.Ltmp16                 # DW_AT_high_pc
	.byte	1                               # DW_AT_call_file
	.byte	199                             # DW_AT_call_line
	.byte	11                              # DW_AT_call_column
	.byte	10                              # Abbrev [10] 0xfd:0x6 DW_TAG_variable
	.byte	4                               # DW_AT_location
	.word	288                             # DW_AT_abstract_origin
	.byte	22                              # Abbrev [22] 0x103:0x7 DW_TAG_variable
	.byte	1                               # DW_AT_location
	.byte	99
	.word	296                             # DW_AT_abstract_origin
	.byte	0                               # End Of Children Mark
	.byte	11                              # Abbrev [11] 0x10b:0x6 DW_TAG_call_site
	.word	305                             # DW_AT_call_origin
	.byte	7                               # DW_AT_call_return_pc
	.byte	11                              # Abbrev [11] 0x111:0x6 DW_TAG_call_site
	.word	143                             # DW_AT_call_origin
	.byte	8                               # DW_AT_call_return_pc
	.byte	0                               # End Of Children Mark
	.byte	23                              # Abbrev [23] 0x118:0x19 DW_TAG_subprogram
	.byte	12                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	151                             # DW_AT_decl_line
	.word	80                              # DW_AT_type
                                        # DW_AT_external
                                        # DW_AT_inline
	.byte	16                              # Abbrev [16] 0x120:0x8 DW_TAG_variable
	.byte	13                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	153                             # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	16                              # Abbrev [16] 0x128:0x8 DW_TAG_variable
	.byte	14                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	154                             # DW_AT_decl_line
	.word	80                              # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	24                              # Abbrev [24] 0x131:0xa DW_TAG_subprogram
	.byte	15                              # DW_AT_name
	.byte	2                               # DW_AT_decl_file
	.byte	49                              # DW_AT_decl_line
                                        # DW_AT_prototyped
                                        # DW_AT_declaration
                                        # DW_AT_external
	.byte	25                              # Abbrev [25] 0x135:0x5 DW_TAG_formal_parameter
	.word	315                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	7                               # Abbrev [7] 0x13b:0x4 DW_TAG_base_type
	.byte	16                              # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	26                              # Abbrev [26] 0x13f:0x16 DW_TAG_subprogram
	.byte	9                               # DW_AT_low_pc
	.word	.Lfunc_end4-.Lfunc_begin4       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	20                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	184                             # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	108                             # DW_AT_type
                                        # DW_AT_external
	.byte	17                              # Abbrev [17] 0x14e:0x6 DW_TAG_call_site
	.word	198                             # DW_AT_call_origin
                                        # DW_AT_call_tail_call
	.byte	10                              # DW_AT_call_pc
	.byte	0                               # End Of Children Mark
	.byte	26                              # Abbrev [26] 0x155:0x19 DW_TAG_subprogram
	.byte	11                              # DW_AT_low_pc
	.word	.Lfunc_end5-.Lfunc_begin5       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	82
                                        # DW_AT_call_all_calls
	.byte	21                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	207                             # DW_AT_decl_line
                                        # DW_AT_prototyped
	.word	108                             # DW_AT_type
                                        # DW_AT_external
	.byte	19                              # Abbrev [19] 0x164:0x9 DW_TAG_formal_parameter
	.byte	6                               # DW_AT_location
	.byte	25                              # DW_AT_name
	.byte	1                               # DW_AT_decl_file
	.byte	207                             # DW_AT_decl_line
	.word	108                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_rnglists,"",@progbits
	.word	.Ldebug_list_header_end1-.Ldebug_list_header_start1 # Length
.Ldebug_list_header_start1:
	.half	5                               # Version
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
	.word	1                               # Offset entry count
.Lrnglists_table_base0:
	.word	.Ldebug_ranges0-.Lrnglists_table_base0
.Ldebug_ranges0:
	.byte	3                               # DW_RLE_startx_length
	.byte	1                               #   start index
	.uleb128 .Lfunc_end0-.Lfunc_begin0      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	3                               #   start index
	.uleb128 .Lfunc_end1-.Lfunc_begin1      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	4                               #   start index
	.uleb128 .Lfunc_end2-.Lfunc_begin2      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	5                               #   start index
	.uleb128 .Lfunc_end3-.Lfunc_begin3      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	9                               #   start index
	.uleb128 .Lfunc_end4-.Lfunc_begin4      #   length
	.byte	3                               # DW_RLE_startx_length
	.byte	11                              #   start index
	.uleb128 .Lfunc_end5-.Lfunc_begin5      #   length
	.byte	0                               # DW_RLE_end_of_list
.Ldebug_list_header_end1:
	.section	.debug_str_offsets,"",@progbits
	.word	108                             # Length of String Offsets Set
	.half	5
	.half	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 19.1.7 (https://github.com/PhilippvK/llvm-project.git f8fcd61d1cd23a0ba4412cc6ab878a57ecfd1e4e)" # string offset=0
.Linfo_string1:
	.asciz	"/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/deps/src/benchmarks/embench/src/crc32/crc_32.c" # string offset=110
.Linfo_string2:
	.asciz	"/var/tmp/ga87puy/isaac-demo-new/install/mlonmcu/temp/sessions/367/runs/0/mlif/lib/embench" # string offset=205
.Linfo_string3:
	.asciz	"crc_32_tab"                    # string offset=295
.Linfo_string4:
	.asciz	"unsigned long"                 # string offset=306
.Linfo_string5:
	.asciz	"DWORD"                         # string offset=320
.Linfo_string6:
	.asciz	"UNS_32_BITS"                   # string offset=326
.Linfo_string7:
	.asciz	"__ARRAY_SIZE_TYPE__"           # string offset=338
.Linfo_string8:
	.asciz	"unsigned char"                 # string offset=358
.Linfo_string9:
	.asciz	"BYTE"                          # string offset=372
.Linfo_string10:
	.asciz	"int"                           # string offset=377
.Linfo_string11:
	.asciz	"rand_beebs"                    # string offset=381
.Linfo_string12:
	.asciz	"crc32pseudo"                   # string offset=392
.Linfo_string13:
	.asciz	"i"                             # string offset=404
.Linfo_string14:
	.asciz	"oldcrc32"                      # string offset=406
.Linfo_string15:
	.asciz	"srand_beebs"                   # string offset=415
.Linfo_string16:
	.asciz	"unsigned int"                  # string offset=427
.Linfo_string17:
	.asciz	"initialise_benchmark"          # string offset=440
.Linfo_string18:
	.asciz	"warm_caches"                   # string offset=461
.Linfo_string19:
	.asciz	"benchmark_body"                # string offset=473
.Linfo_string20:
	.asciz	"benchmark"                     # string offset=488
.Linfo_string21:
	.asciz	"verify_benchmark"              # string offset=498
.Linfo_string22:
	.asciz	"heat"                          # string offset=515
.Linfo_string23:
	.asciz	"res"                           # string offset=520
.Linfo_string24:
	.asciz	"rpt"                           # string offset=524
.Linfo_string25:
	.asciz	"r"                             # string offset=528
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
	.section	.debug_addr,"",@progbits
	.word	.Ldebug_addr_end0-.Ldebug_addr_start0 # Length of contribution
.Ldebug_addr_start0:
	.half	5                               # DWARF version number
	.byte	4                               # Address size
	.byte	0                               # Segment selector size
.Laddr_table_base0:
	.word	crc_32_tab
	.word	.Lfunc_begin0
	.word	.Ltmp2
	.word	.Lfunc_begin1
	.word	.Lfunc_begin2
	.word	.Lfunc_begin3
	.word	.Ltmp16
	.word	.Ltmp15
	.word	.Ltmp17
	.word	.Lfunc_begin4
	.word	.Ltmp30
	.word	.Lfunc_begin5
.Ldebug_addr_end0:
	.ident	"clang version 19.1.7 (https://github.com/PhilippvK/llvm-project.git f8fcd61d1cd23a0ba4412cc6ab878a57ecfd1e4e)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.section	.debug_line,"",@progbits
.Lline_table_start0:
