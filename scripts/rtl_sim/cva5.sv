/* Nailgun CVA5 local-memory and peripheral AXI simulation adapter. */
module blk_mem_gen_0(input clka, input ena, input [3:0] wea,
 input [31:0] addra, input [31:0] dina, output reg [31:0] douta);
 import "DPI-C" function int unsigned isaac_read(input int unsigned addr);
 import "DPI-C" function void isaac_write(input int unsigned addr, input int unsigned data, input int unsigned mask);
 // Original Nailgun pins carry byte addresses. One synchronous RAM read cycle.
 always @(posedge clka) if(ena) begin
  douta <= isaac_read(addra);
  if (|wea) isaac_write(addra,dina,{28'b0,wea});
 end
endmodule
module sim_top #(parameter DATA_WAIT_STATES=0)(input wire clk, input wire rst, output wire [31:0] retired);
 import "DPI-C" function int unsigned isaac_read(input int unsigned addr);
 import "DPI-C" function void isaac_write(input int unsigned addr, input int unsigned data, input int unsigned mask);
 wire awvalid,wvalid,bready,arvalid,rready;
 wire [31:0] awaddr,wdata,araddr;
 wire [3:0] wstrb;
 wire [7:0] awlen,arlen;
 wire wlast,cache_awvalid,cache_wvalid,cache_arvalid;
 integer delay_phase=0;
 wire bus_enable=delay_phase==0;
 always @(posedge clk) if(rst || delay_phase==DATA_WAIT_STATES) delay_phase<=0;else delay_phase<=delay_phase+1;
 reg aw_pending=0,w_pending=0,bvalid=0,rvalid=0;
 reg [31:0] addr=0,data=0,rdata=0;
 reg [3:0] strb=0;
 wire awready=!aw_pending&&!bvalid&&bus_enable, wready=!w_pending&&!bvalid&&bus_enable;
 wire arready=!rvalid&&bus_enable;
 assign retired = rst ? 0 : dut.cva5.cva5_wrapper.cva5.retire.count;
 cva5_top dut(.clk(clk),.rst(rst),
 .m_axi_awlen(awlen),.m_axi_arlen(arlen),.m_axi_wlast(wlast),
 .m_axi_cache_awvalid(cache_awvalid),.m_axi_cache_wvalid(cache_wvalid),.m_axi_cache_arvalid(cache_arvalid),
 .m_axi_awvalid(awvalid),.m_axi_awready(awready),.m_axi_awaddr(awaddr),
 .m_axi_wvalid(wvalid),.m_axi_wready(wready),.m_axi_wdata(wdata),.m_axi_wstrb(wstrb),
 .m_axi_bvalid(bvalid),.m_axi_bready(bready),.m_axi_bresp(2'b0),
 .m_axi_arvalid(arvalid),.m_axi_arready(arready),.m_axi_araddr(araddr),
 .m_axi_rvalid(rvalid),.m_axi_rready(rready),.m_axi_rdata(rdata),.m_axi_rresp(2'b0),.m_axi_rlast(1'b1),
 .m_axi_cache_awready(1'b0),.m_axi_cache_wready(1'b0),
 .m_axi_cache_bvalid(1'b0),.m_axi_cache_bresp(2'b0),.m_axi_cache_bid(6'b0),
 .m_axi_cache_arready(1'b0),.m_axi_cache_rvalid(1'b0),
 .m_axi_cache_rdata(32'b0),.m_axi_cache_rresp(2'b0),.m_axi_cache_rlast(1'b0),.m_axi_cache_rid(6'b0));
 always @(posedge clk) begin
  if(rst) begin aw_pending<=0;w_pending<=0;bvalid<=0;rvalid<=0;end
  else begin
   if(cache_awvalid || cache_wvalid || cache_arvalid) $fatal(1,"Cache AXI traffic is unsupported by the local-memory simulation config");
   if((awvalid && awlen!=0) || (arvalid && arlen!=0) || (wvalid && !wlast)) $fatal(1,"Only single-beat peripheral AXI transactions are supported");
   if(awvalid&&awready) begin addr<=awaddr;aw_pending<=1;end
   if(wvalid&&wready) begin data<=wdata;strb<=wstrb;w_pending<=1;end
   if(aw_pending&&w_pending&&!bvalid) begin
    isaac_write(addr,data,{28'b0,strb});aw_pending<=0;w_pending<=0;bvalid<=1;
   end
   if(bvalid&&bready) bvalid<=0;
   if(arvalid&&arready) begin rdata<=isaac_read(araddr);rvalid<=1;end
   if(rvalid&&rready) rvalid<=0;
  end
 end
endmodule
