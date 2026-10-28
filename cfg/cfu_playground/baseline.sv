// Baseline firmware contains no custom instructions. Keep the same CFU-capable
// VexRiscv CPU configuration while candidate discovery has no generated CFU yet.
`timescale 1ns/1ps
module Cfu (
  input wire cmd_valid, output wire cmd_ready,
  input wire [9:0] cmd_payload_function_id,
  input wire [31:0] cmd_payload_inputs_0, cmd_payload_inputs_1,
  output wire rsp_valid, input wire rsp_ready,
  output wire [31:0] rsp_payload_outputs_0,
  input wire reset, clk
);
  assign cmd_ready = !reset && rsp_ready;
  assign rsp_valid = !reset && cmd_valid;
  assign rsp_payload_outputs_0 = 32'b0;
endmodule
