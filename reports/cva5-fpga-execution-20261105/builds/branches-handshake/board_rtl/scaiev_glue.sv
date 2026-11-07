//SCAIE-V: Hazard Unit for decoupled instructions.
//Prevents multi-cycle ISAX instructions 

module scaiev_glue
    import cva5_config::*;
    import riscv_types::*;
    import cva5_types::*;
    import scaiev_types::*;
    import scaiev_config::*;

    # (
        parameter cpu_config_t CONFIG = EXAMPLE_CONFIG
    )

    (
        input logic clk,
        input logic rst,

        scaiev_interface.scal scaiev,
        output logic [12:0] WrRD_spawn_issue_addr_o
    , output logic  RdFlush_1_o,// ISAX
    
    output logic  RdFlush_3_o,// ISAX
    
    output logic  RdFlush_2_o,// ISAX
    
    input logic  WrPC_validReq_2_i,// ISAX
    
    output logic [32 -1 : 0] RdPC_2_o,// ISAX
    
    output logic  RdStall_1_o,// ISAX
    
    output logic  RdStall_3_o,// ISAX
    
    output logic  RdStall_2_o,// ISAX
    
    output logic [32 -1 : 0] RdInstr_1_o,// ISAX
    
    output logic [32 -1 : 0] RdInstr_2_o,// ISAX
    
    input logic [32 -1 : 0] WrPC_2_i,// ISAX
    
    input logic  WrFlush_1_i,// ISAX
    
    output logic  RdInStageValid_1_o,// ISAX
    
    output logic  RdInStageValid_3_o,// ISAX
    
    output logic  RdInStageValid_2_o,// ISAX
    
    output logic [32 -1 : 0] RdRS1_2_o,// ISAX
    
    output logic [32 -1 : 0] RdRS2_2_o,// ISAX
    
    input logic  RdIValid_FUSED_BGEU_1_i,// ISAX
    
    input logic  RdIValid_FUSED_BGEU_3_i,// ISAX
    
    input logic  RdIValid_FUSED_BNE_1_i,// ISAX
    
    input logic  RdIValid_FUSED_BNE_3_i,// ISAX
    
    input logic  RdIValid_FUSED_BLT_1_i,// ISAX
    
    input logic  RdIValid_FUSED_BLT_3_i,// ISAX
    
    input logic  RdIValid_FUSED_BLTU_1_i,// ISAX
    
    input logic  RdIValid_FUSED_BLTU_3_i,// ISAX
    
    input logic  RdIValid_FUSED_BEQ_1_i,// ISAX
    
    input logic  RdIValid_FUSED_BEQ_3_i,// ISAX
    
    input logic  RdIValid_FUSED_BGE_1_i,// ISAX
    
    input logic  RdIValid_FUSED_BGE_3_i,// ISAX
    
    output logic  RdPipeInto_stage_executesv1_2_o,// ISAX
    
    output logic  RdPipeInto_stage_executecva_2_o,// ISAX
    
    output logic  glueToSCAL_IValid_cond_all_1_o,// ISAX
    
    output logic  glueToSCAL_IValid_cond_all_2_o,// ISAX
    
    output logic  glueToSCAL_IValid_cond_all_3_o,// ISAX
    
    output logic [13 -1 : 0] glueToSCAL_WrRD_spawn_addr_2_o,// ISAX
    
    output logic [13 -1 : 0] glueToSCAL_WrRD_spawn_addr_1_o// ISAX
    
    );
    logic decode_wrReg_hold;
    logic decode_rdReg_RD;
    logic decode_isRepeated_RdRD;
    logic issue_isFirst_RdRD;
    logic execute_isFirst_RdRD;
    logic issue_stall_before_mem;
    logic execute_stall_mem;
    logic mem_read_pending;
    logic set_mem_read_pending;
    logic fetch_wrPCValid_r;
    logic [31:0] fetch_wrPC_r;
    logic issue_stall_before_cf;
    logic wrPC_after_fetch_valid;
    logic [31:0] wrPC_after_fetch;

    logic hazard_unit_scaiev_decode_stall_set;

    //Indicates if an ISAX instruction has entered decode and is not overridden.
    wire decode_valid_regular = scaiev.decode_valid && !(scaiev.decode_wrReg || scaiev.decode_rdReg);

    //Condition 'is ISAX that will use scaiev.decode_wrReg', to be set correctly by SCAIE-V.
    wire decode_is_isax_decoupled_wb = 0;
    //Condition 'is ISAX that will use scaiev.rf_wrReg in Issue and not flushed/stalled', to be set correctly by SCAIE-V.
    wire issue_is_isax_decoupled_wb = !scaiev.issue_isStalling && !scaiev.issue_stall && (0);
    //Condition 'unlock all registers' (e.g. 'all WrRD_spawn ISAXes killed').
    wire unlock_all_registers = 0;
    //Condition 'inject-based writeback cancelled' (only unlock, don't write)
    logic decode_wrReg_cancel;

    generate if (ENABLE_SCAIEV_REGHAZARD) begin
        
        logic [4:0] rd_last_locked;
        logic rd_inuse_bitmap [32];
        always_ff @(posedge clk) begin
            if (scaiev.issue_isFlushing && rd_last_locked != '0) begin
                //Unlock register that was locked speculatively.
                rd_inuse_bitmap[rd_last_locked] <= 0;
            end
            if (scaiev.issue_isFlushing || scaiev.issue_valid && !scaiev.issue_stall && !scaiev.issue_isStalling) begin
                //Reset speculative lock register ID, as the corresponding decoupled instruction can no longer be flushed.
                rd_last_locked <= '0;
            end
            if (rst || unlock_all_registers) begin
                //Unlock all registers.
                for (int i = 0; i < 32; i=i+1)
                    rd_inuse_bitmap[i] <= 0;
            end
            else if (decode_valid_regular && decode_is_isax_decoupled_wb && scaiev.decode_RD_id != '0
                && !scaiev.decode_stall && !scaiev.decode_flush && !scaiev.decode_isStalling && !scaiev.decode_isFlushing) begin
                //Lock register (speculatively).
                //-> The check for !scaiev.decode_stall ensures that !rd_conflict, i.e. RD is not locked already.
                rd_inuse_bitmap[scaiev.decode_RD_id] <= '1;
                rd_last_locked <= scaiev.decode_RD_id;
            end
            else if ((scaiev.decode_wrReg && !scaiev.decode_stall || decode_wrReg_cancel) && scaiev.decode_wrReg_RD != '0 ) begin
                //Unlock register.
                rd_inuse_bitmap[scaiev.decode_wrReg_RD] <= 0;
            end
        end

        logic rs1_conflict;
        logic rs2_conflict;
        logic rd_as_rs_conflict;
        logic rd_conflict;

        always_comb begin
            rs1_conflict = scaiev.decode_RS1_valid && rd_inuse_bitmap[scaiev.decode_RS1_id]; //Read-after-Write
            rs2_conflict = scaiev.decode_RS2_valid && rd_inuse_bitmap[scaiev.decode_RS2_id]; //Read-after-Write
            rd_as_rs_conflict = scaiev.decode_RD_AS_RS_valid && rd_inuse_bitmap[scaiev.decode_RD_AS_RS_id]; //Read-after-Write
            rd_conflict  = scaiev.decode_RD_valid  && rd_inuse_bitmap[scaiev.decode_RD_id];  //Write-after-Write
            hazard_unit_scaiev_decode_stall_set = decode_valid_regular && (rs1_conflict || rs2_conflict || rd_as_rs_conflict || rd_conflict);
        end
    end
    else begin //!ENABLE_SCAIEV_REGHAZARD
        assign hazard_unit_scaiev_decode_stall_set = 0;
    end endgenerate

    logic explicit_free_reg;
    logic [5:0] explicit_free_reg_addr;

    generate if (ENABLE_DECOUPLED_WRITEBACK && ENABLE_DECOUPLED_WRITEBACK_WAW) begin
        //TODO: isaxkill behaviour
        // -> Instead of plainly zeroing the inuse flag here, also need to free the register in CVA5!
        // -> Need to send a kill command to each ISAX (which interface?)
        // -> Stall isaxkill in Issue until all ISAXes are killed

        //Logic to prevent certain kind of WaW hazard: premature deallocation of decoupled instruction's destination register.
        //-> Later instruction that overrides physical register could finish sooner and free a register that still is to be written to.

        //Indicates whether some ISAX will write the respective physical register.
        //While set, prevent retiring instructions from adding the register to the free FIFO.
        logic [63:0] phys_inuse_by_isax;
        //Indicates whether a logical destination register was prevented from being freed,
        // and still has to be freed by the ISAX on retirement (in addition to the previous register).
        logic [63:0] phys_should_be_freed_by_isax;

        always_ff @(posedge clk) begin
            scaiev.renamer_addtofree_skip = 0;
            if (rst || unlock_all_registers) begin
                explicit_free_reg <= 0;
                explicit_free_reg_addr <= 'X;
                phys_inuse_by_isax <= '0;
                phys_should_be_freed_by_isax <= '0;
            end
            else begin : waw_logic_scope
                logic [63:0] next_phys_inuse_by_isax;
                logic [63:0] next_phys_should_be_freed_by_isax;
                next_phys_inuse_by_isax = phys_inuse_by_isax;
                next_phys_should_be_freed_by_isax = phys_should_be_freed_by_isax;
                
                explicit_free_reg <= explicit_free_reg && !scaiev.rf_ready;
                if (scaiev.rf_wrReg) begin
                    next_phys_inuse_by_isax[scaiev.rf_wrReg_phys_RD] = 1'b0; //Write port A2
                    next_phys_should_be_freed_by_isax[scaiev.rf_wrReg_phys_RD] = 1'b0; //Write port B2
                    if (!scaiev.rf_wrReg_cancel && phys_should_be_freed_by_isax[scaiev.rf_wrReg_phys_RD]) begin //Read port B1
                        // -> Inject register free for scaiev.rf_wrReg_phys_RD (e.g. repeat identical writeback next cycle)
                        explicit_free_reg <= 1;
                        explicit_free_reg_addr <= scaiev.rf_wrReg_phys_RD;
                    end
                end
                
                if (issue_is_isax_decoupled_wb) begin
                    next_phys_inuse_by_isax[scaiev.issue_phys_RD_decoupled] = 1'b1; //Write port A1
                end
                if (phys_inuse_by_isax[scaiev.renamer_addtofree_reg] == 1'b1) begin //Read port A1
                    scaiev.renamer_addtofree_skip = 1'b1;
                    if (scaiev.renamer_addtofree_valid)
                        next_phys_should_be_freed_by_isax[scaiev.renamer_addtofree_reg] = 1'b1; //Write port B1
                end
                phys_inuse_by_isax <= next_phys_inuse_by_isax;
                phys_should_be_freed_by_isax <= next_phys_should_be_freed_by_isax;
            end
        end

    end
    else begin // !(ENABLE_DECOUPLED_WRITEBACK && ENABLE_DECOUPLED_WRITEBACK_WAW)
        assign explicit_free_reg = 0;
        assign explicit_free_reg_addr = '0;
    end endgenerate
    assign WrRD_spawn_issue_addr_o = {scaiev.issue_prev_phys_RD_decoupled, scaiev.issue_phys_RD_decoupled};

    

wire ISAX_wrPCValid_3_s = 0;
assign RdFlush_1_o = scaiev.decode_isFlushing_internal;

assign RdFlush_3_o = 0;

assign RdFlush_2_o = scaiev.issue_isFlushing_internal;

assign RdPC_2_o = scaiev.issue_PC;

assign RdStall_1_o = scaiev.decode_isStalling || hazard_unit_scaiev_decode_stall_set || (decode_rdReg_RD && !decode_isRepeated_RdRD);

assign RdStall_3_o = scaiev.execute_isStalling_reason_core || execute_stall_mem || execute_isFirst_RdRD;

assign RdStall_2_o = scaiev.issue_isStalling || scaiev.issue_injectLS_potentiallyValid || scaiev.execute_injectLS_potentiallyValid || issue_stall_before_mem || issue_stall_before_cf || issue_isFirst_RdRD;

assign RdInstr_1_o = scaiev.decode_Instr;

assign RdInstr_2_o = scaiev.issue_Instr;

assign RdInStageValid_1_o = scaiev.decode_valid;

assign RdInStageValid_3_o = scaiev.execute_valid;

assign RdInStageValid_2_o = scaiev.issue_valid;

assign RdRS1_2_o = scaiev.issue_RS1;

assign RdRS2_2_o = scaiev.issue_RS2;

assign scaiev.decode_isSCAIEV = RdIValid_FUSED_BGEU_1_i || RdIValid_FUSED_BNE_1_i || RdIValid_FUSED_BLT_1_i || RdIValid_FUSED_BLTU_1_i || RdIValid_FUSED_BEQ_1_i || RdIValid_FUSED_BGE_1_i;
assign scaiev.decode_isSCAIEV_stdencoding = 1'b0;
assign scaiev.decode_isSCAIEV_usesRS1 = RdIValid_FUSED_BGEU_1_i || RdIValid_FUSED_BNE_1_i || RdIValid_FUSED_BLT_1_i || RdIValid_FUSED_BLTU_1_i || RdIValid_FUSED_BEQ_1_i || RdIValid_FUSED_BGE_1_i;
assign scaiev.decode_isSCAIEV_usesRS2 = RdIValid_FUSED_BGEU_1_i || RdIValid_FUSED_BNE_1_i || RdIValid_FUSED_BLT_1_i || RdIValid_FUSED_BLTU_1_i || RdIValid_FUSED_BEQ_1_i || RdIValid_FUSED_BGE_1_i;
assign scaiev.decode_isSCAIEV_usesRD_AS_RS = 1'b0;
assign scaiev.decode_isSCAIEV_usesRD = 1'b0;

assign scaiev.decode_isSCAIEV_usesRD_decoupled = 1'b0;

assign glueToSCAL_IValid_cond_all_1_o = scaiev.decode_valid && !scaiev.decode_wrReg && !scaiev.decode_rdReg;
assign glueToSCAL_IValid_cond_all_2_o = scaiev.issue_valid;
assign glueToSCAL_IValid_cond_all_3_o = scaiev.execute_valid;
assign decode_isRepeated_RdRD = 1'b0;
assign decode_rdReg_RD = 1'b0;
assign issue_isFirst_RdRD = 1'b0;
assign execute_isFirst_RdRD = 1'b0;
assign scaiev.decode_repeat_next = 1'b0;
assign scaiev.decode_rdReg = 1'b0;
assign scaiev.decode_rdReg_RS1 = 5'd0;
assign scaiev.decode_rdReg_RS2 = 5'd0;
assign scaiev.decode_skip_wb = 1'b0;
assign scaiev.decode_RS1_override = 1'b0;
assign scaiev.decode_RS2_override = 1'b0;
assign scaiev.decode_RD_AS_RS_override = 1'b0;
assign decode_wrReg_hold = 1'b0;
assign scaiev.fetch_stall = 0;

assign scaiev.decode_stall = hazard_unit_scaiev_decode_stall_set || 0;

assign scaiev.issue_stall = scaiev.issue_injectLS_potentiallyValid || scaiev.execute_injectLS_potentiallyValid || issue_stall_before_mem || issue_stall_before_cf || 0;

assign scaiev.execute_stall = execute_stall_mem || 0;

assign scaiev.execute_flush = 1'b0;

assign scaiev.issue_flush = 1'b0;

assign scaiev.decode_flush = WrFlush_1_i && !scaiev.issue_isStalling && !scaiev.issue_stall;

assign scaiev.fetch_flush = fetch_wrPCValid_r;

assign scaiev.execute_wrRD = 1'b0;
assign scaiev.execute_wrRD_data = 'X;
assign glueToSCAL_WrRD_spawn_addr_2_o = {scaiev.issue_prev_phys_RD_decoupled, scaiev.issue_phys_RD_decoupled};
assign glueToSCAL_WrRD_spawn_addr_1_o = {scaiev.decode_prev_phys_RD_decoupled, scaiev.decode_phys_RD_decoupled};
always_comb begin
        scaiev.rf_wrReg = 1'b0;
        scaiev.rf_wrReg_cancel = 1'b0;
        scaiev.rf_wrReg_phys_RD = 'X;
        scaiev.rf_wrReg_prev_phys_RD = 'X;
        scaiev.rf_wrReg_data = 'X;
        scaiev.rf_isDecoupledWB = 0;
end
assign scaiev.decode_wrReg = 1'b0;
assign decode_wrReg_cancel = 1'b0;
assign scaiev.decode_wrReg_RD = 5'd0;
assign scaiev.decode_wrReg_data = 32'd0;
assign issue_stall_before_mem = 0;
assign execute_stall_mem = 0;
assign mem_read_pending = 0;

always_comb begin
        scaiev.execute_injectLS_potentiallyValid = 1'b0;
        scaiev.execute_injectLS_valid = 1'b0;
        scaiev.execute_injectLS_rnw = 'X;
        scaiev.execute_injectLS_relaxedOrdering = 'X;
        scaiev.execute_injectLS_addr = 'X;
        scaiev.execute_injectLS_storeVal = 'X;
        set_mem_read_pending = 1'b0;
end
assign scaiev.issue_injectLS_potentiallyValid = 1'b0;
assign scaiev.issue_injectLS_valid = 1'b0;
assign scaiev.issue_injectLS_rnw = 1'b0;
assign scaiev.issue_injectLS_relaxedOrdering = 1'b0;
assign scaiev.issue_injectLS_addr = '0;
assign scaiev.issue_injectLS_storeVal = '0;
assign issue_stall_before_cf = 0;
always_ff @(posedge clk) begin
    if (rst) begin
        fetch_wrPCValid_r <= 1'b0;
        fetch_wrPC_r <= 'X;
    end
    else begin
        if ((scaiev.fetch_stall || scaiev.fetch_isStalling) && wrPC_after_fetch_valid) begin
            fetch_wrPC_r <= wrPC_after_fetch;
            fetch_wrPCValid_r <= 1'b1;
        end
        if (!(scaiev.fetch_stall || scaiev.fetch_isStalling)) begin
            fetch_wrPCValid_r <= 1'b0;
        end
    end
end
always_comb begin
    wrPC_after_fetch_valid = fetch_wrPCValid_r;
    wrPC_after_fetch = fetch_wrPC_r;
    scaiev.fetch_wrPCValid = fetch_wrPCValid_r;
    scaiev.fetch_wrPC = fetch_wrPC_r;
    if (WrPC_validReq_2_i && !scaiev.issue_isStalling && !scaiev.issue_stall) begin
        scaiev.fetch_wrPCValid = 1'b1;
        scaiev.fetch_wrPC = WrPC_2_i;
        wrPC_after_fetch_valid = 1'b1;
        wrPC_after_fetch = WrPC_2_i;
    end
end
assign RdPipeInto_stage_executesv1_2_o = scaiev.issue_isSCAIEV;

assign RdPipeInto_stage_executecva_2_o = !scaiev.issue_isSCAIEV;

assign scaiev.execute_deq = 0;
assign scaiev.execute_commitNow = 1'b0;
assign scaiev.execute_commitNow_ID = '0;
assign scaiev.execute_commitNow_expects_rd = 1'b0;
endmodule
