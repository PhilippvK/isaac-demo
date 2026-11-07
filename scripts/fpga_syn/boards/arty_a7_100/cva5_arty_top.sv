// Digilent Arty A7-100 board shell for Nailgun/SCAIE-V CVA5 outputs.
module cva5_arty_top (
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
    wire awvalid, awready, wvalid, wready, bvalid, bready;
    wire arvalid, arready, rvalid, rready;
    wire [31:0] awaddr, araddr, wdata, rdata;
    wire [3:0] wstrb;
    wire [1:0] bresp, rresp;

    cva5_top cpu (
        .clk(clk20), .rst(reset),
        .m_axi_awvalid(awvalid), .m_axi_awready(awready), .m_axi_awaddr(awaddr),
        .m_axi_wvalid(wvalid), .m_axi_wready(wready), .m_axi_wdata(wdata), .m_axi_wstrb(wstrb),
        .m_axi_bvalid(bvalid), .m_axi_bready(bready), .m_axi_bresp(bresp),
        .m_axi_arvalid(arvalid), .m_axi_arready(arready), .m_axi_araddr(araddr),
        .m_axi_rvalid(rvalid), .m_axi_rready(rready), .m_axi_rdata(rdata),
        .m_axi_rresp(rresp), .m_axi_rlast(1'b1),
        // Cache buses are disabled in the supported CVA5 configuration.
        .m_axi_cache_awready(1'b0), .m_axi_cache_wready(1'b0),
        .m_axi_cache_bvalid(1'b0), .m_axi_cache_bresp(2'b00), .m_axi_cache_bid(6'b0),
        .m_axi_cache_arready(1'b0), .m_axi_cache_rvalid(1'b0),
        .m_axi_cache_rdata(32'b0), .m_axi_cache_rresp(2'b00),
        .m_axi_cache_rid(6'b0), .m_axi_cache_rlast(1'b0)
    );
    // CVA5 axi_master emits single beats (ARLEN=AWLEN=0). UART registers
    // occupy offsets 0/4/8/12 and alias throughout the peripheral window.
    isaac_uart uart (
        .s_axi_aclk(clk20), .s_axi_aresetn(!reset),
        .s_axi_awaddr(awaddr[3:0]), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr[3:0]), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .rx(uart_rx), .tx(uart_tx), .interrupt()
    );
endmodule
