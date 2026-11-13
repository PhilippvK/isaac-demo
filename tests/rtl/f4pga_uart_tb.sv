module tb;
reg clk=0; always #5 clk=~clk;
reg resetn=0, awvalid=0,wvalid=0,bready=0,arvalid=0,rready=0;
reg [3:0] awaddr=0,araddr=0,wstrb=1;
reg [31:0] wdata=0;
wire awready,wready,bvalid,arready,rvalid,tx,irq;
wire [1:0] bresp,rresp;wire [31:0] rdata;
reg rx=1;
isaac_uart #(.CLOCK_HZ(800),.BAUD(100)) dut(
.s_axi_aclk(clk),.s_axi_aresetn(resetn),
.s_axi_awaddr(awaddr),.s_axi_awvalid(awvalid),.s_axi_awready(awready),
.s_axi_wdata(wdata),.s_axi_wstrb(wstrb),.s_axi_wvalid(wvalid),.s_axi_wready(wready),
.s_axi_bvalid(bvalid),.s_axi_bready(bready),.s_axi_bresp(bresp),
.s_axi_araddr(araddr),.s_axi_arvalid(arvalid),.s_axi_arready(arready),
.s_axi_rdata(rdata),.s_axi_rvalid(rvalid),.s_axi_rready(rready),.s_axi_rresp(rresp),
.rx(rx),.tx(tx),.interrupt(irq));
task tick; begin @(posedge clk); #1; end endtask
task aw(input [3:0] addr); begin
 @(negedge clk);awaddr=addr;awvalid=1;
 @(posedge clk);if(!awready)$fatal(1,"AW stalled unexpectedly");
 @(negedge clk);awvalid=0;
end endtask
task wd(input [31:0] data);begin
 @(negedge clk);wdata=data;wvalid=1;
 @(posedge clk);if(!wready)$fatal(1,"W stalled unexpectedly");
 @(negedge clk);wvalid=0;
end endtask
task write_reg(input [3:0] addr,input [31:0] data,input integer data_first);begin
 if(data_first)begin wd(data);repeat(3)tick;aw(addr);end
 else begin aw(addr);repeat(3)tick;wd(data);end
 while(!bvalid)tick;
 repeat(3)begin tick;if(!bvalid || bresp!=0)$fatal(1,"B response lost under backpressure");end
 @(negedge clk);bready=1;tick;@(negedge clk);bready=0;
end endtask
task read_reg(input [3:0] addr,output [31:0] data);begin
 @(negedge clk);araddr=addr;arvalid=1;tick;
 @(negedge clk);arvalid=0;
 while(!rvalid)tick;data=rdata;
 repeat(3)begin tick;if(!rvalid || rdata!==data || rresp!=0)$fatal(1,"R response unstable");end
 @(negedge clk);rready=1;tick;@(negedge clk);rready=0;
end endtask
task send_rx(input[7:0] data,input bad_stop);integer i;begin
 @(negedge clk);rx=0;repeat(8)@(negedge clk);
 for(i=0;i<8;i=i+1)begin rx=data[i];repeat(8)@(negedge clk);end
 rx=!bad_stop;repeat(8)@(negedge clk);rx=1;repeat(10)@(negedge clk);
end endtask
task check_tx(input[7:0] data);integer i;begin
 @(negedge tx);repeat(4)tick;if(tx!==0)$fatal(1,"TX start");
 for(i=0;i<8;i=i+1)begin repeat(8)tick;if(tx!==data[i])$fatal(1,"TX data bit %d",i);end
 repeat(8)tick;if(tx!==1)$fatal(1,"TX stop");
end endtask
reg[31:0] value;integer n;
initial begin
 repeat(4)tick;@(negedge clk);resetn=1;tick;
 read_reg(8,value);if(value!==4)$fatal(1,"reset status %h",value);
 fork write_reg(4,32'ha5,0);check_tx(8'ha5);join
 fork write_reg(4,32'h3c,1);check_tx(8'h3c);join
 wstrb=0;write_reg(4,32'hff,0);repeat(100)tick;if(tx!==1)$fatal(1,"WSTRB ignored");wstrb=1;
 send_rx(8'h96,0);read_reg(8,value);if(!value[0])$fatal(1,"RX not ready");
 read_reg(0,value);if(value!==32'h96)$fatal(1,"RX wrong %h",value);
 read_reg(8,value);if(value[0])$fatal(1,"RX pop failed");
 send_rx(8'h55,1);read_reg(8,value);if(!value[6])$fatal(1,"framing error missing");
 read_reg(8,value);if(value[6])$fatal(1,"framing error not cleared");
 for(n=0;n<17;n=n+1)send_rx(n,0);
 read_reg(8,value);if(!value[1] || !value[5])$fatal(1,"FIFO full/overrun missing %h",value);
 for(n=0;n<16;n=n+1)begin read_reg(0,value);if(value!==n)$fatal(1,"FIFO order %d %h",n,value);end
 send_rx(8'h42,0);write_reg(12,2,1);read_reg(8,value);if(value[0])$fatal(1,"RX reset failed");
 write_reg(12,16,0);read_reg(8,value);if(!value[4] || !irq)$fatal(1,"IRQ enable");
 $display("PASS UART AXI independent channels, backpressure, TX/RX, FIFO and errors");$finish;
end
initial begin #1000000;$fatal(1,"timeout");end
endmodule
