module @XMemoryCRC32 {
  coredsl.register core_x @X[32] : ui32
  coredsl.addrspace core_mem @MEM : (ui32) -> ui8
  coredsl.instruction @CUSTOM17 {lil.enc_immediates = [[["%TREENAIL_WAS_HERE_rs2_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rs1_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rd_4_0", 4, 0, 0]]]} ("0", "1", "1", "1", "0", "1", "1", %TREENAIL_WAS_HERE_rs2_4_0 : ui5, %TREENAIL_WAS_HERE_rs1_4_0 : ui5, "0", "0", "0", %TREENAIL_WAS_HERE_rd_4_0 : ui5, "0", "0", "0", "1", "0", "1", "1") {
    %rs2 = coredsl.cast %TREENAIL_WAS_HERE_rs2_4_0 : ui5 to ui5
    %rs1 = coredsl.cast %TREENAIL_WAS_HERE_rs1_4_0 : ui5 to ui5
    %rd = coredsl.cast %TREENAIL_WAS_HERE_rd_4_0 : ui5 to ui5
    %0 = coredsl.get @X[%rs1 : ui5] : ui32
    %1 = coredsl.get @X[%rs2 : ui5] : ui32
    %2 = coredsl.cast %1 : ui32 to si32
    %3 = hwarith.constant 255 : ui8
    %4 = coredsl.cast %3 : ui8 to ui32
    %5 = coredsl.and %0, %4 : ui32, ui32
    %6 = hwarith.constant 2 : ui2
    %7 = coredsl.cast %6 : ui2 to ui32
    %8 = coredsl.shift_left %5, %7 : ui32, ui32
    %9 = coredsl.cast %8 : ui32 to si32
    %10 = hwarith.add %2, %9 : (si32, si32) -> si33
    %11 = coredsl.cast %10 : si33 to ui32
    %12 = hwarith.constant 0 : ui1
    %13 = coredsl.cast %12 : ui1 to si32
    %14 = hwarith.add %11, %13 : (ui32, si32) -> si34
    %15 = coredsl.cast %14 : si34 to ui32
    %16 = coredsl.get @MEM[%15 : ui32, 3:0] : ui32
    %17 = coredsl.cast %16 : ui32 to si32
    %18 = coredsl.cast %17 : si32 to ui32
    %19 = hwarith.constant 0 : ui1
    %21 = hwarith.icmp ne %rd, %19 : ui5, ui1
    %20 = hwarith.cast %21 : (i1) -> ui1
    %22 = coredsl.cast %20 : ui1 to i1
    scf.if %22 {
      coredsl.set @X[%rd : ui5] = %18 : ui32
    }
    coredsl.end
  }
  coredsl.instruction @CUSTOM43 {lil.enc_immediates = [[["%TREENAIL_WAS_HERE_rs2_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rs1_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rd_4_0", 4, 0, 0]]]} ("1", "1", "1", "1", "1", "1", "0", %TREENAIL_WAS_HERE_rs2_4_0 : ui5, %TREENAIL_WAS_HERE_rs1_4_0 : ui5, "1", "0", "1", %TREENAIL_WAS_HERE_rd_4_0 : ui5, "0", "0", "0", "1", "0", "1", "1") {
    %rs2 = coredsl.cast %TREENAIL_WAS_HERE_rs2_4_0 : ui5 to ui5
    %rs1 = coredsl.cast %TREENAIL_WAS_HERE_rs1_4_0 : ui5 to ui5
    %rd = coredsl.cast %TREENAIL_WAS_HERE_rd_4_0 : ui5 to ui5
    %0 = coredsl.get @X[%rs1 : ui5] : ui32
    %1 = coredsl.get @X[%rs2 : ui5] : ui32
    %2 = coredsl.cast %1 : ui32 to si32
    %3 = hwarith.constant 2 : ui2
    %4 = coredsl.cast %3 : ui2 to ui32
    %5 = coredsl.shift_left %0, %4 : ui32, ui32
    %6 = coredsl.cast %5 : ui32 to si32
    %7 = hwarith.add %2, %6 : (si32, si32) -> si33
    %8 = coredsl.cast %7 : si33 to ui32
    %9 = hwarith.constant 0 : ui1
    %10 = coredsl.cast %9 : ui1 to si32
    %11 = hwarith.add %8, %10 : (ui32, si32) -> si34
    %12 = coredsl.cast %11 : si34 to ui32
    %13 = coredsl.get @MEM[%12 : ui32, 3:0] : ui32
    %14 = coredsl.cast %13 : ui32 to si32
    %15 = coredsl.cast %14 : si32 to ui32
    %16 = hwarith.constant 0 : ui1
    %18 = hwarith.icmp ne %rd, %16 : ui5, ui1
    %17 = hwarith.cast %18 : (i1) -> ui1
    %19 = coredsl.cast %17 : ui1 to i1
    scf.if %19 {
      coredsl.set @X[%rd : ui5] = %15 : ui32
    }
    coredsl.end
  }
  coredsl.instruction @CUSTOM44 {lil.enc_immediates = [[["%TREENAIL_WAS_HERE_rs2_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rs1_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rd_4_0", 4, 0, 0]]]} ("1", "0", "1", "0", "0", "0", "1", %TREENAIL_WAS_HERE_rs2_4_0 : ui5, %TREENAIL_WAS_HERE_rs1_4_0 : ui5, "1", "0", "1", %TREENAIL_WAS_HERE_rd_4_0 : ui5, "0", "0", "0", "1", "0", "1", "1") {
    %rs2 = coredsl.cast %TREENAIL_WAS_HERE_rs2_4_0 : ui5 to ui5
    %rs1 = coredsl.cast %TREENAIL_WAS_HERE_rs1_4_0 : ui5 to ui5
    %rd = coredsl.cast %TREENAIL_WAS_HERE_rd_4_0 : ui5 to ui5
    %0 = coredsl.get @X[%rs1 : ui5] : ui32
    %1 = coredsl.get @X[%rs2 : ui5] : ui32
    %2 = hwarith.constant 0 : ui1
    %3 = coredsl.cast %2 : ui1 to si32
    %4 = hwarith.add %0, %3 : (ui32, si32) -> si34
    %5 = coredsl.cast %4 : si34 to ui32
    %6 = coredsl.get @MEM[%5 : ui32, 3:0] : ui32
    %7 = coredsl.cast %6 : ui32 to si32
    %8 = coredsl.cast %7 : si32 to ui32
    %9 = hwarith.constant 8 : ui4
    %10 = coredsl.cast %9 : ui4 to ui32
    %11 = coredsl.shift_right %1, %10 : ui32, ui32
    %12 = coredsl.xor %8, %11 : ui32, ui32
    %13 = hwarith.constant 0 : ui1
    %15 = hwarith.icmp ne %rd, %13 : ui5, ui1
    %14 = hwarith.cast %15 : (i1) -> ui1
    %16 = coredsl.cast %14 : ui1 to i1
    scf.if %16 {
      coredsl.set @X[%rd : ui5] = %12 : ui32
    }
    coredsl.end
  }
  coredsl.instruction @CUSTOM76 {lil.enc_immediates = [[["%TREENAIL_WAS_HERE_rs2_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rs1_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rd_4_0", 4, 0, 0]]]} ("1", "1", "1", "1", "1", "1", "1", %TREENAIL_WAS_HERE_rs2_4_0 : ui5, %TREENAIL_WAS_HERE_rs1_4_0 : ui5, "1", "0", "1", %TREENAIL_WAS_HERE_rd_4_0 : ui5, "0", "0", "0", "1", "0", "1", "1") {
    %rs2 = coredsl.cast %TREENAIL_WAS_HERE_rs2_4_0 : ui5 to ui5
    %rs1 = coredsl.cast %TREENAIL_WAS_HERE_rs1_4_0 : ui5 to ui5
    %rd = coredsl.cast %TREENAIL_WAS_HERE_rd_4_0 : ui5 to ui5
    %0 = coredsl.get @X[%rs1 : ui5] : ui32
    %1 = coredsl.get @X[%rs2 : ui5] : ui32
    %2 = coredsl.cast %1 : ui32 to si32
    %3 = coredsl.cast %0 : ui32 to si32
    %4 = hwarith.add %2, %3 : (si32, si32) -> si33
    %5 = coredsl.cast %4 : si33 to ui32
    %6 = hwarith.constant 0 : ui1
    %7 = coredsl.cast %6 : ui1 to si32
    %8 = hwarith.add %5, %7 : (ui32, si32) -> si34
    %9 = coredsl.cast %8 : si34 to ui32
    %10 = coredsl.get @MEM[%9 : ui32, 3:0] : ui32
    %11 = coredsl.cast %10 : ui32 to si32
    %12 = coredsl.cast %11 : si32 to ui32
    %13 = hwarith.constant 0 : ui1
    %15 = hwarith.icmp ne %rd, %13 : ui5, ui1
    %14 = hwarith.cast %15 : (i1) -> ui1
    %16 = coredsl.cast %14 : ui1 to i1
    scf.if %16 {
      coredsl.set @X[%rd : ui5] = %12 : ui32
    }
    coredsl.end
  }
  coredsl.instruction @CUSTOM78 {lil.enc_immediates = [[["%TREENAIL_WAS_HERE_rs2_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rs1_4_0", 4, 0, 0]], [["%TREENAIL_WAS_HERE_rd_4_0", 4, 0, 0]]]} ("0", "1", "0", "0", "0", "0", "0", %TREENAIL_WAS_HERE_rs2_4_0 : ui5, %TREENAIL_WAS_HERE_rs1_4_0 : ui5, "0", "1", "1", %TREENAIL_WAS_HERE_rd_4_0 : ui5, "0", "0", "0", "1", "0", "1", "1") {
    %rs2 = coredsl.cast %TREENAIL_WAS_HERE_rs2_4_0 : ui5 to ui5
    %rs1 = coredsl.cast %TREENAIL_WAS_HERE_rs1_4_0 : ui5 to ui5
    %rd = coredsl.cast %TREENAIL_WAS_HERE_rd_4_0 : ui5 to ui5
    %0 = coredsl.get @X[%rs1 : ui5] : ui32
    %1 = coredsl.get @X[%rs2 : ui5] : ui32
    %2 = hwarith.constant 0 : ui1
    %3 = coredsl.cast %2 : ui1 to si32
    %4 = hwarith.add %0, %3 : (ui32, si32) -> si34
    %5 = coredsl.cast %4 : si34 to ui32
    %6 = coredsl.get @MEM[%5 : ui32, 3:0] : ui32
    %7 = coredsl.cast %6 : ui32 to si32
    %8 = coredsl.cast %7 : si32 to ui32
    %9 = coredsl.xor %8, %1 : ui32, ui32
    %10 = hwarith.constant 0 : ui1
    %12 = hwarith.icmp ne %rd, %10 : ui5, ui1
    %11 = hwarith.cast %12 : (i1) -> ui1
    %13 = coredsl.cast %11 : ui1 to i1
    scf.if %13 {
      coredsl.set @X[%rd : ui5] = %9 : ui32
    }
    coredsl.end
  }
}
