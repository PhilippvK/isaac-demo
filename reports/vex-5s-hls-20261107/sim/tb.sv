`timescale 1ns/1ps
module tb;
 reg clk=0, rst=1;
 always #5 clk=~clk;
 initial begin repeat(20) @(posedge clk); rst<=0; end
 wire [31:0] ia,da,dw;wire [2:0] ds;wire [1:0] it,dt;wire dwrite;
 reg [31:0] ip=0,dp=0;reg [2:0] dsize=0;reg pending_write=0;
 reg [31:0] ram[0:65535];
 reg [4095:0] firmware;
 reg [31:0] line=0;
 reg [31:0] byte_mask;
 integer ticks=0,line_len=0,data_wait=0,delay_left=0;
 wire dready=delay_left==0;
 reg [31:0] native_start=0,native_end=0,ise_start=0,ise_end=0;
 integer native_count=0,ise_count=0,ise_ops=0,native_tick=0,ise_tick=0;
 initial begin
  if($value$plusargs("data_wait=%d",data_wait)) begin end
  if($value$plusargs("native_start=%h",native_start)) begin end
  if($value$plusargs("native_end=%h",native_end)) begin end
  if($value$plusargs("ise_start=%h",ise_start)) begin end
  if($value$plusargs("ise_end=%h",ise_end)) begin end
 end
 always @(posedge clk) if(!rst && dut.VexRiscv_inst.writeBack_arbitration_isFiring) begin
  if(dut.VexRiscv_inst.writeBack_PC>=native_start && dut.VexRiscv_inst.writeBack_PC<native_end) begin
   if(native_count==0) native_tick=ticks;
   native_count=native_count+1;
   if(dut.VexRiscv_inst.writeBack_INSTRUCTION==32'h00008067) begin
    $display("ISAAC_KERNEL native instructions=%0d cycles=%0d",native_count,ticks-native_tick+1);
    native_count=0;
   end
  end
  if(dut.VexRiscv_inst.writeBack_PC>=ise_start && dut.VexRiscv_inst.writeBack_PC<ise_end) begin
   if(ise_count==0) begin ise_tick=ticks;ise_ops=0;end
   ise_count=ise_count+1;
   if(dut.VexRiscv_inst.writeBack_INSTRUCTION[6:0]==7'h0b) ise_ops=ise_ops+1;
   if(dut.VexRiscv_inst.writeBack_INSTRUCTION==32'h00008067) begin
    $display("ISAAC_KERNEL ise instructions=%0d cycles=%0d ise_ops=%0d",ise_count,ticks-ise_tick+1,ise_ops);
    ise_count=0;
   end
  end
 end
 initial begin
  if (!$value$plusargs("firmware=%s",firmware)) $fatal(1,"Missing firmware");
  $readmemh(firmware,ram);
 end
 wire [31:0] ir=ram[ip[17:2]];
 wire [31:0] dr=dp[31:18]==14'h2000 ? ram[dp[17:2]] : (dp==32'h60000010 ? ticks : 32'b0);
 top dut(.clk(clk),.rst(rst),.debugReset(rst),
 .debug_bus_cmd_valid(1'b0),.debug_bus_cmd_payload_wr(1'b0),
 .debug_bus_cmd_payload_address(8'b0),.debug_bus_cmd_payload_data(32'b0),
 .debug_bus_cmd_ready(),.debug_bus_rsp_data(),.debug_resetOut(),
 .timerInterrupt(1'b0),.externalInterrupt(1'b0),.softwareInterrupt(1'b0),
 .iBusAhbLite3_HADDR(ia),.iBusAhbLite3_HWRITE(),.iBusAhbLite3_HSIZE(),
 .iBusAhbLite3_HBURST(),.iBusAhbLite3_HPROT(),.iBusAhbLite3_HTRANS(it),
 .iBusAhbLite3_HMASTLOCK(),.iBusAhbLite3_HWDATA(),
 .iBusAhbLite3_HRDATA(ir),.iBusAhbLite3_HREADY(1'b1),.iBusAhbLite3_HRESP(1'b0),
 .dBusAhbLite3_HADDR(da),.dBusAhbLite3_HWRITE(dwrite),.dBusAhbLite3_HSIZE(ds),
 .dBusAhbLite3_HBURST(),.dBusAhbLite3_HPROT(),.dBusAhbLite3_HTRANS(dt),
 .dBusAhbLite3_HMASTLOCK(),.dBusAhbLite3_HWDATA(dw),
 .dBusAhbLite3_HRDATA(dr),.dBusAhbLite3_HREADY(dready),.dBusAhbLite3_HRESP(1'b0));
 always @(posedge clk) begin
  if(rst) begin ip<=0;dp<=0;pending_write<=0;end
  else begin
   ticks<=ticks+1;
   if(ticks==2000000) $fatal(1,"ISAAC_SIM_TIMEOUT pc=%h",ia);
   if(it[1]) ip<=ia;
   if(dready && dt[1]) begin dp<=da;dsize<=ds;delay_left<=data_wait;end
   else if(delay_left>0) delay_left<=delay_left-1;
   pending_write<=dready && dt[1] && dwrite;
   if(pending_write) begin
    if(dp[31:18]==14'h2000) begin
     byte_mask=(dsize==2) ? 32'hffffffff : ((dsize==1 ? 32'hffff : 32'hff) << (8*dp[1:0]));
     ram[dp[17:2]] <= (ram[dp[17:2]] & ~byte_mask) | (dw & byte_mask);
    end
    else if(dp==32'h60000004) begin
     $write("%c",dw[7:0]);
     if(dw[7:0]==10) begin
      if(line_len==4 && line=="PASS") begin $display("ISAAC_SIM_PASS cycles=%0d",ticks);$finish;end
      if(line_len==4 && line=="FAIL") $fatal(1,"ISAAC_SIM_FAIL");
      line=0;line_len=0;
     end
     else if(dw[7:0]!=13) begin line={line[23:0],dw[7:0]};line_len=line_len+1;end
    end
    else if(dp!=32'h6000000c) $fatal(1,"Unmapped write %h",dp);
   end
  end
 end
endmodule
