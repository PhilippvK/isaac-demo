module sim_top #(parameter DATA_WAIT_STATES=0)(input wire clk, input wire rst, output wire [31:0] retired);
 import "DPI-C" function int unsigned isaac_read(input int unsigned addr);
 import "DPI-C" function void isaac_write(input int unsigned addr, input int unsigned data, input int unsigned mask);
 wire [31:0] ia,da,dw; wire [2:0] ds; wire [1:0] it,dt; wire dwrite;
 reg [31:0] ip=32'h80000000,dp=32'h80000000; reg [2:0] dsize=0; reg pending_write=0;
 integer delay_left=0;
 wire dready=delay_left==0;
 wire [31:0] ir=isaac_read(ip);
 wire [31:0] dr=isaac_read(dp);
 assign retired={31'b0,(!rst && dut.VexRiscv_inst.writeBack_arbitration_isFiring)};
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
  if(rst) begin ip<=32'h80000000;dp<=32'h80000000;pending_write<=0;delay_left<=0;end
  else begin
   if(it[1]) ip<=ia;
   if(dready) begin
    if(dt[1]) begin dp<=da;dsize<=ds;delay_left<=DATA_WAIT_STATES;end
    pending_write<=dt[1] && dwrite;
   end else delay_left<=delay_left-1;
   if(dready && pending_write) isaac_write(dp,dw, dsize==2 ? 15 : (dsize==1 ? 3 : 1) << dp[1:0]);
  end
 end
endmodule
