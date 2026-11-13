// Open replacement for the Vex shell's 256 KiB block-memory generator IP.
// Port A is instruction read-only; port B has byte write enables.
// Same-clock synchronous reads and write-first port-B behavior.
module blk_mem_gen_0 (
 input clka, ena, input [3:0] wea, input [15:0] addra,
 input [31:0] dina, output reg [31:0] douta,
 input clkb, enb, input [3:0] web, input [15:0] addrb,
 input [31:0] dinb, output reg [31:0] doutb
);
 (* ram_style = "block" *) reg [31:0] memory [0:65535];
 initial $readmemh("firmware.hex", memory);
 always @(posedge clka) if (ena) douta <= memory[addra];
 genvar lane;
 generate for (lane=0; lane<4; lane=lane+1) begin: bytes
  always @(posedge clkb) if (enb) begin
   if (web[lane]) begin
    memory[addrb][lane*8 +: 8] <= dinb[lane*8 +: 8];
    doutb[lane*8 +: 8] <= dinb[lane*8 +: 8];
   end else doutb[lane*8 +: 8] <= memory[addrb][lane*8 +: 8];
  end
 end endgenerate
endmodule
