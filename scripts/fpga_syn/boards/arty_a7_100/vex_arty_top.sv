// Digilent Arty A7-100 board shell for Nailgun/SCAIE-V VEX_5S outputs.
module vex_arty_top (
    input wire clk100,
    input wire reset_button,
    input wire uart_rx,
    output wire uart_tx
);
    wire clk_input, clk_feedback, clk_feedback_buf, clk20_raw, clk20, locked;
    IBUF input_clock (.I(clk100), .O(clk_input));
    MMCME2_BASE #(
        .CLKIN1_PERIOD(10.0), .CLKFBOUT_MULT_F(10.0),
        .DIVCLK_DIVIDE(1), .CLKOUT0_DIVIDE_F(50.0), .STARTUP_WAIT("FALSE")
    ) clock_manager (
        .CLKIN1(clk_input), .CLKFBIN(clk_feedback_buf), .CLKFBOUT(clk_feedback),
        .CLKOUT0(clk20_raw), .LOCKED(locked), .RST(reset_button), .PWRDWN(1'b0)
    );
    BUFG feedback_clock (.I(clk_feedback), .O(clk_feedback_buf));
    BUFG core_clock (.I(clk20_raw), .O(clk20));
    // Asynchronous assertion and synchronized deassertion after MMCM lock.
    (* ASYNC_REG = "TRUE" *) reg [3:0] reset_pipe = 4'b1111;
    always @(posedge clk20 or negedge locked) begin
        if (!locked) reset_pipe <= 4'b1111;
        else reset_pipe <= {reset_pipe[2:0], 1'b0};
    end
    wire reset = reset_pipe[3];

 wire [31:0] ia, da, dw, ir, ram_data;
 wire [2:0] ds; wire [1:0] it,dt; wire dwrite;
 reg [31:0] address=0; reg [2:0] size=0; reg writing=0;
 reg [1:0] state=0;
 wire dready=(state==0 || state==2);
 wire in_ram=(address[31:18]==14'h2000);
 wire peripheral=(address[31:8]==24'h600000);
 wire tx_write=peripheral && writing && address[7:2]==1;
 wire service=(state==1 && (!tx_write || !tx_busy));
 wire [3:0] mask=(size==2 ? 4'b1111 : size==1 ? 4'b0011 : 4'b0001) << address[1:0];
 wire [3:0] ram_we=(service && writing && in_ram) ? mask : 4'b0000;
 wire [31:0] dr=in_ram ? ram_data : peripheral ? mmio_data : 32'b0;
 reg [31:0] cycles=0, instructions=0, exit_status=0;
 reg exited=0;
 reg [31:0] mmio_data=0;
 always @(posedge clk20) begin
  if(reset) begin state<=0; cycles<=0; instructions<=0; exited<=0; exit_status<=0; end
  else begin
   cycles<=cycles+1;
   if(dut.VexRiscv_inst.writeBack_arbitration_isFiring) instructions<=instructions+1;
   if(dready) begin
    if(dt[1]) begin address<=da;size<=ds;writing<=dwrite;state<=1;end
    else state<=0;
   end else if(service) begin
    state<=2;
    case(address[7:2])
     2: mmio_data<={28'b0,tx_busy,3'b0};
     4: mmio_data<=cycles;
     5: mmio_data<=instructions;
     6: begin mmio_data<=exit_status;if(peripheral && writing) begin exited<=1;exit_status<=dw;end end
     default:mmio_data<=0;
    endcase
   end
  end
 end
 blk_mem_gen_0 memory (
  .clka(clk20),.ena(!reset && it[1]),.wea(4'b0),.addra(ia[17:2]),.dina(32'b0),.douta(ir),
  .clkb(clk20),.enb(!reset && service && in_ram),.web(ram_we),.addrb(address[17:2]),.dinb(dw),.doutb(ram_data)
 );
 // Blocking transmit registers preserve every byte even for runtimes without polling.
 // 20 MHz / 174 = 114942 baud (0.22% below 115200).
 reg [9:0] tx_shift=10'h3ff; reg [7:0] tx_div=0;reg [3:0] tx_left=0;
 wire tx_busy=(tx_left!=0);
 assign uart_tx=tx_shift[0];
 always @(posedge clk20) begin
  if(reset) begin tx_shift<=10'h3ff;tx_div<=0;tx_left<=0;end
  else if(tx_busy) begin
   if(tx_div==173) begin tx_div<=0;tx_shift<={1'b1,tx_shift[9:1]};tx_left<=tx_left-1;end
   else tx_div<=tx_div+1;
  end else if(service && tx_write) begin tx_shift<={1'b1,dw[7:0],1'b0};tx_left<=10;tx_div<=0;end
 end
 top dut(.clk(clk20),.rst(reset),.debugReset(reset),
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
endmodule
