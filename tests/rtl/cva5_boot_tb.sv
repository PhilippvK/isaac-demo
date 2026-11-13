// Clock primitives are behavioral stubs for CPU/UART simulation only.
module IBUF(input I,output O);assign O=I;endmodule
module BUFG(input I,output O);assign O=I;endmodule
module PLLE2_ADV #(parameter CLKIN1_PERIOD=10.0,CLKFBOUT_MULT=10,DIVCLK_DIVIDE=1,CLKOUT0_DIVIDE=50,STARTUP_WAIT="FALSE")(
input CLKIN1,CLKIN2,CLKINSEL,CLKFBIN,RST,PWRDWN,DCLK,DEN,DWE,input[6:0]DADDR,input[15:0]DI,
output CLKFBOUT,CLKOUT0,output LOCKED);
assign CLKFBOUT=CLKIN1;assign CLKOUT0=CLKIN1;assign LOCKED=!RST;
endmodule
module tb;
reg clk=0;always #1 clk=~clk;
reg reset=1;wire tx;
cva5_arty_top dut(clk,reset,1'b1,tx);
initial begin repeat(10)@(negedge clk);reset=0;end
reg[7:0]ch;reg[55:0]last=0;integer i;
initial forever begin
 @(negedge tx);repeat(87)@(posedge clk);
 if(tx!==0)$fatal(1,"UART start");
 for(i=0;i<8;i=i+1)begin repeat(174)@(posedge clk);ch[i]=tx;end
 repeat(174)@(posedge clk);if(tx!==1)$fatal(1,"UART stop");
 $write("%c",ch);$fflush();last={last[47:0],ch};
 if(last[47:0]==48'h4641494c0d0a)$fatal(1,"firmware FAIL");
 if(last==56'h0a504153530d0a)begin $display("\nSIMULATION_PASS");$finish;end
end
initial begin repeat(10000000)@(posedge clk);$fatal(1,"CPU boot timeout");end
endmodule
