/*
 * Copyright © 2017-2019 Eric Matthews,  Lesley Shannon
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Initial code developed under the supervision of Dr. Lesley Shannon,
 * Reconfigurable Computing Lab, Simon Fraser University.
 *
 * Author(s):
 *             <>
 */

module scaiev_unit

    import cva5_config::*;
    import riscv_types::*;
    import cva5_types::*;
    import scaiev_types::*;

    (
        input logic clk,
        input logic rst,

        scaiev_interface.core scaiev,

        input scaiev_inputs_t scaiev_inputs,
        unit_issue_interface.unit issue,
        unit_writeback_interface.unit wb,
        
        output load_store_inputs_t ls_inputs_scaiev,
        unit_issue_interface.decode ls_issue_scaiev,
        unit_writeback_interface.wb ls_wb_scaiev,
        output logic ls_issue_scaiev_stage,
        input logic ls_wb_scaiev_stage,
        
        input logic ls_exception_valid,
        input id_t ls_exception_id,
        
        output logic stall_issue,
        
        //If set: Synchronously flushes fetch and issue.
        //If this is set one stage after issue, issue should be stalled during branch_flush to prevent following instruction from entering the unit.
        output logic branch_flush,
        output branch_results_t br_results,
        output logic br_results_override
    );

    logic [XLEN-1:0] execute_rs1;
    logic [XLEN-1:0] execute_rs2;
    logic [XLEN-1:0] execute_rd_as_rs;
    logic [XLEN-1:0] execute_instruction;
    logic [XLEN-1:0] execute_pc;

    id_t execute_id;
    id_t execute_id_or_counter;
    logic execute_valid;

    //Separate counters to be able to show SCAIE-V 'unique' IDs despite the non-writeback IDs being freed immediately.
    id_t execute_nonrd_idcounter_next;
    id_t execute_nonrd_idcounter_min;
    logic execute_stall_idcounter_full;

    logic execute_expects_rd;
    logic execute_rd_valid;
    logic [XLEN-1:0] execute_rd_data;

    logic execute_stall;
    logic execute_missingWriteback;
    
    //Note: wrRD is currently passed back to writeback combinationally, unless the ISAX requests an execute stall.
    //-> Make sure this is okay for timing closure, otherwise remove this 'bypass' path and move wb.* assignment to next stage.

    assign execute_missingWriteback = execute_expects_rd && !execute_rd_valid && !scaiev.execute_wrRD;
    assign execute_stall_idcounter_full = (!execute_expects_rd && execute_nonrd_idcounter_next == execute_nonrd_idcounter_min);
    assign execute_stall = scaiev.execute_stall || execute_missingWriteback && !scaiev.execute_deq || execute_stall_idcounter_full;
    assign scaiev.execute_isStalling_reason_isax = execute_missingWriteback;
    assign scaiev.execute_isStalling_reason_core = (wb.done && !scaiev.execute_commitNow && !wb.ack) || !execute_valid || execute_stall_idcounter_full;
    assign scaiev.execute_isStalling = scaiev.execute_isStalling_reason_isax || scaiev.execute_isStalling_reason_core;

    assign issue.ready = !execute_valid || !(execute_stall || (wb.done && !scaiev.execute_commitNow && !wb.ack));

    always @(posedge clk) begin
        if (rst) begin 
            execute_rs1 <= 'x;
            execute_rs2 <= 'x;
            execute_rd_as_rs <= 'x;
            execute_instruction <= 'x;
            execute_pc <= 'x;
            execute_id <= 'x;
            execute_id_or_counter <= 'x;
            execute_expects_rd <= 'x;
            execute_valid <= 0;
            execute_nonrd_idcounter_next <= 0;
        end
        else if (issue.ready) begin
            execute_rs1 <= scaiev_inputs.rs1;
            execute_rs2 <= scaiev_inputs.rs2;
            execute_rd_as_rs <= scaiev_inputs.rd_as_rs;
            execute_instruction <= scaiev_inputs.instruction;
            execute_pc <= scaiev_inputs.pc;
            execute_id <= issue.id;
            execute_id_or_counter <= issue.id;
            execute_expects_rd <= issue.new_request && scaiev_inputs.uses_rd;
            if (issue.new_request && !scaiev_inputs.uses_rd) begin
                execute_id_or_counter <= execute_nonrd_idcounter_next;
                execute_nonrd_idcounter_next <= execute_nonrd_idcounter_next + 1;
            end
            execute_valid <= issue.new_request;
        end
        else if (scaiev.execute_deq) begin
            execute_rs1 <= 'x;
            execute_rs2 <= 'x;
            execute_rd_as_rs <= 'x;
            execute_instruction <= 'x;
            execute_pc <= 'x;
            execute_id <= 'x;
            execute_id_or_counter <= 'x;
            execute_expects_rd <= 'x;
            execute_valid <= 0;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            execute_nonrd_idcounter_min <= 0;
        end
        else if (scaiev.execute_commitNow
                ? !scaiev.execute_commitNow_expects_rd
                : (execute_valid && !execute_expects_rd && !execute_stall)) begin
            execute_nonrd_idcounter_min <= execute_nonrd_idcounter_min + 1;
        end
    end

    assign scaiev.execute_PC = execute_pc;
    assign scaiev.execute_Instr = execute_instruction;
    assign scaiev.execute_RS1 = execute_rs1;
    assign scaiev.execute_RS2 = execute_rs2;
    assign scaiev.execute_RD_AS_RS = execute_rd_as_rs;
    assign scaiev.execute_ID = execute_id;
    assign scaiev.execute_ID_or_counter = execute_id_or_counter;
    assign scaiev.execute_expects_rd = execute_expects_rd;
    assign scaiev.execute_valid = execute_valid && !execute_stall_idcounter_full;

    always @(posedge clk) begin
        if (rst || issue.ready) begin
            execute_rd_valid <= 0;
            execute_rd_data <= 'x;
        end
        else if (scaiev.execute_wrRD) begin
            execute_rd_valid <= 1;
            execute_rd_data <= scaiev.execute_wrRD_data;
        end
    end
    
    logic ls_wb_ack_r;
    always_ff @(posedge clk) begin
        ls_wb_ack_r <= ls_wb_scaiev.done;
    end
    
    assign ls_wb_scaiev.ack = ls_wb_ack_r;
    
    assign ls_inputs_scaiev.rs1 = scaiev.execute_injectLS_potentiallyValid ? scaiev.execute_injectLS_addr : scaiev.issue_injectLS_addr;
    assign ls_inputs_scaiev.rs2 = scaiev.execute_injectLS_potentiallyValid ? scaiev.execute_injectLS_storeVal : scaiev.issue_injectLS_storeVal;
    assign ls_inputs_scaiev.offset = '0;
    // ISAAC scaiev2 allocation preserves the source memory funct3.
    // This selects byte/halfword lanes and load signedness just like native LS.
    assign ls_inputs_scaiev.fn3 = scaiev.execute_injectLS_potentiallyValid
        ? scaiev.execute_Instr[14:12] : scaiev_inputs.instruction[14:12];
    assign ls_inputs_scaiev.load = scaiev.execute_injectLS_potentiallyValid ? scaiev.execute_injectLS_rnw : scaiev.issue_injectLS_rnw;
    assign ls_inputs_scaiev.store = ~(scaiev.execute_injectLS_potentiallyValid ? scaiev.execute_injectLS_rnw : scaiev.issue_injectLS_rnw);
    assign ls_inputs_scaiev.fence = 0;
    assign ls_inputs_scaiev.forwarded_store = 0;
    assign ls_inputs_scaiev.relaxed_load_ordering = scaiev.execute_injectLS_potentiallyValid ? scaiev.execute_injectLS_relaxedOrdering : scaiev.issue_injectLS_potentiallyValid;
    assign ls_inputs_scaiev.store_forward_id = 'x;
    assign ls_inputs_scaiev.amo.is_lr = 0;
    assign ls_inputs_scaiev.amo.is_sc = 0;
    assign ls_inputs_scaiev.amo.is_amo = 0;
    assign ls_inputs_scaiev.amo.op = 'x;
    
    assign ls_issue_scaiev.possible_issue = scaiev.execute_injectLS_potentiallyValid || scaiev.issue_injectLS_potentiallyValid;
    assign ls_issue_scaiev.new_request = (scaiev.execute_injectLS_valid || scaiev.issue_injectLS_valid) && ls_issue_scaiev.ready;
    assign ls_issue_scaiev.id = scaiev.execute_injectLS_potentiallyValid ? execute_id : issue.id;
    assign ls_issue_scaiev_stage = scaiev.execute_injectLS_potentiallyValid ? 1'd1 : 1'd0;

    assign scaiev.injectLS_ready = ls_issue_scaiev.ready;
    assign scaiev.issue_injectLS_done = ls_wb_scaiev.done && ls_wb_scaiev_stage == 1'd0;
    assign scaiev.execute_injectLS_done = ls_wb_scaiev.done && ls_wb_scaiev_stage == 1'd1;
    assign scaiev.injectLS_readData = ls_wb_scaiev.rd;

    
    assign branch_flush = 0;
    
    assign br_results.id = 'X;
    assign br_results.pc_id = 'X;
    assign br_results.valid = 0;
    assign br_results.pc = 'X;
    assign br_results.target_pc = 'X;
    assign br_results.branch_taken = 0;
    assign br_results.is_branch = 0;
    assign br_results.is_return = 0;
    assign br_results.is_call = 0;
    
    assign br_results_override = 0;
    
    assign stall_issue = 0; //Currently unused (in contrast to scaiev.issue_stall).
    
    assign wb.rd = scaiev.execute_wrRD ? scaiev.execute_wrRD_data : execute_rd_data;
    assign wb.done = scaiev.execute_commitNow
        ? (scaiev.execute_commitNow_expects_rd && (execute_rd_valid || scaiev.execute_wrRD))
        : (execute_valid && execute_expects_rd && !(execute_stall || execute_missingWriteback));
    assign wb.id = scaiev.execute_commitNow ? scaiev.execute_commitNow_ID : execute_id;

    assign scaiev.execute_commitNow_resp = !scaiev.execute_commitNow_expects_rd || (wb.done && wb.ack);

endmodule
