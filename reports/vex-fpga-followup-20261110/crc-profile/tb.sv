module IBUF(input I,output O);assign O=I;endmodule
module BUFG(input I,output O);assign O=I;endmodule
module MMCME2_BASE #(parameter CLKIN1_PERIOD=10.0,CLKFBOUT_MULT_F=10.0,DIVCLK_DIVIDE=1,CLKOUT0_DIVIDE_F=50.0,STARTUP_WAIT="FALSE") (input CLKIN1,CLKFBIN,RST,PWRDWN,output CLKFBOUT,CLKOUT0,LOCKED);
assign CLKOUT0=CLKIN1;assign CLKFBOUT=CLKIN1;assign LOCKED=!RST;endmodule
module blk_mem_gen_0(input clka,ena,input [3:0] wea,input [15:0] addra,input [31:0] dina,output reg [31:0] douta,input clkb,enb,input [3:0] web,input [15:0] addrb,input [31:0] dinb,output reg [31:0] doutb);
reg [31:0] mem[0:65535]; initial $readmemh("firmware.hex",mem);
always @(posedge clka) if(ena) douta<=mem[addra];
always @(posedge clkb) if(enb) begin
 for(integer i=0;i<4;i=i+1) if(web[i]) mem[addrb][8*i+:8]<=dinb[8*i+:8];
 doutb<=mem[addrb];
end
endmodule
module tb;
reg clk=0,reset=1;wire tx;integer f;reg [7:0] value;reg finished=0;reg [55:0] tail_bytes=0;integer trace_file;
vex_arty_top dut(.clk100(clk),.reset_button(reset),.uart_rx(1'b1),.uart_tx(tx));
always #5 clk=~clk;
initial begin f=$fopen("uart.bin","wb");repeat(10) @(negedge clk);reset=0;end
initial begin
 forever begin
  @(negedge tx);repeat(87) @(posedge clk);
  for(integer i=0;i<8;i=i+1) begin repeat(174) @(posedge clk);value[i]=tx;end
  repeat(174) @(posedge clk);if(!tx) $fatal(1,"UART stop bit");
  $fwrite(f,"%c",value);
  tail_bytes={tail_bytes[47:0],value};if(tail_bytes==56'h0a504153530d0a) finished=1;
 end
end
initial begin
 wait(finished);wait(!dut.tx_busy);repeat(400) @(posedge clk);
 $fclose(f);
 $display("SHELL_PASS cycles=%d retired=%d",dut.cycles,dut.instructions);$finish;
end
initial trace_file=$fopen("trace.csv","w");
always @(posedge clk) if(!reset && dut.dut.VexRiscv_inst.writeBack_arbitration_isFiring && dut.dut.VexRiscv_inst.writeBack_PC>=32'h800000e4 && dut.dut.VexRiscv_inst.writeBack_PC<32'h800001a8)
 $fwrite(trace_file,"%0d,%08x,%08x,%0d,%0d,%0d,%0d\n",dut.cycles,dut.dut.VexRiscv_inst.writeBack_PC,dut.dut.VexRiscv_inst.writeBack_INSTRUCTION,dut.dut.VexRiscv_inst.execute_arbitration_isStuck,dut.dut.VexRiscv_inst.memory_arbitration_isStuck,dut.dready,dut.dut.isax_RdMem_validReq_CUSTOM0_2_to_scal);
initial begin repeat(30000000) @(posedge clk);$fatal(1,"Timeout");end
endmodule
