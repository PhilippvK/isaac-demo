// Clock primitives are behavioral stubs for CPU/UART simulation only.
module IBUF(input I,output O);assign O=I;endmodule
module BUFG(input I,output O);assign O=I;endmodule
module PLLE2_ADV #(parameter CLKIN1_PERIOD=10.0,CLKFBOUT_MULT=10,DIVCLK_DIVIDE=1,CLKOUT0_DIVIDE=50,STARTUP_WAIT="FALSE")(
input CLKIN1,CLKIN2,CLKINSEL,CLKFBIN,RST,PWRDWN,DCLK,DEN,DWE,input[6:0]DADDR,input[15:0]DI,
output CLKFBOUT,CLKOUT0,output LOCKED);
assign CLKFBOUT=CLKIN1;assign CLKOUT0=CLKIN1;assign LOCKED=!RST;
endmodule
