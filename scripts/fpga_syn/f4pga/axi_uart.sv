// Portable UARTLite register subset: 16-byte RX/TX FIFOs, 8N1, 115200 baud
// at 20 MHz. AXI4-Lite AW/W are captured independently; responses hold until
// accepted. Offsets: RX=0, TX=4, status=8, control=12 (reset TX/RX, enable IRQ).
module isaac_uart #(parameter integer CLOCK_HZ=20000000, BAUD=115200) (
    input wire s_axi_aclk, s_axi_aresetn,
    input wire [3:0] s_axi_awaddr, input wire s_axi_awvalid, output wire s_axi_awready,
    input wire [31:0] s_axi_wdata, input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid, output wire s_axi_wready,
    output wire [1:0] s_axi_bresp, output reg s_axi_bvalid, input wire s_axi_bready,
    input wire [3:0] s_axi_araddr, input wire s_axi_arvalid, output wire s_axi_arready,
    output reg [31:0] s_axi_rdata, output wire [1:0] s_axi_rresp,
    output reg s_axi_rvalid, input wire s_axi_rready,
    input wire rx, output wire tx, output wire interrupt
);
    localparam integer DIV=(CLOCK_HZ+BAUD/2)/BAUD;
    reg aw_pending, w_pending;
    reg [3:0] awaddr;
    reg [31:0] wdata;
    reg [3:0] wstrb;
    assign s_axi_awready = !aw_pending && !s_axi_bvalid;
    assign s_axi_wready = !w_pending && !s_axi_bvalid;
    assign s_axi_arready = !s_axi_rvalid;
    assign s_axi_bresp=2'b00, s_axi_rresp=2'b00;
    wire write_fire = aw_pending && w_pending && !s_axi_bvalid;
    wire read_fire = s_axi_arvalid && s_axi_arready;
    wire control_write = write_fire && awaddr[3:2]==3 && wstrb[0];
    wire reset_tx = control_write && wdata[0];
    wire reset_rx = control_write && wdata[1];
    reg irq_enable;
    reg [7:0] tx_fifo[0:15], rx_fifo[0:15];
    reg [3:0] tx_wr, tx_rd, rx_wr, rx_rd;
    reg [4:0] tx_count, rx_count;
    reg [9:0] tx_shift;
    reg [3:0] tx_bits;
    reg [31:0] tx_timer, rx_timer;
    reg [3:0] rx_bits;
    reg [7:0] rx_shift;
    (* ASYNC_REG="TRUE" *) reg [1:0] rx_sync;
    reg rx_busy, overrun, framing;
    wire tx_pop = tx_bits==0 && tx_count!=0;
    wire tx_push = write_fire && awaddr[3:2]==1 && wstrb[0] && tx_count<16;
    wire rx_pop = read_fire && s_axi_araddr[3:2]==0 && rx_count!=0;
    wire rx_done = rx_busy && rx_timer==0 && rx_bits==9;
    wire rx_push = rx_done && rx_sync[1] && rx_count<16;
    assign tx = tx_bits==0 ? 1'b1 : tx_shift[0];
    assign interrupt = irq_enable && (rx_count!=0 || (tx_count==0 && tx_bits==0));
    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            aw_pending<=0; w_pending<=0; s_axi_bvalid<=0; s_axi_rvalid<=0;
            s_axi_rdata<=0; awaddr<=0; wdata<=0; wstrb<=0; irq_enable<=0;
            tx_wr<=0; tx_rd<=0; tx_count<=0; tx_bits<=0; tx_shift<=10'h3ff; tx_timer<=0;
            rx_wr<=0; rx_rd<=0; rx_count<=0; rx_bits<=0; rx_timer<=0;
            rx_busy<=0; rx_shift<=0; rx_sync<=3; overrun<=0; framing<=0;
        end else begin
            rx_sync <= {rx_sync[0],rx};
            if (s_axi_awvalid && s_axi_awready) begin awaddr<=s_axi_awaddr; aw_pending<=1; end
            if (s_axi_wvalid && s_axi_wready) begin wdata<=s_axi_wdata; wstrb<=s_axi_wstrb; w_pending<=1; end
            if (s_axi_bvalid && s_axi_bready) s_axi_bvalid<=0;
            if (write_fire) begin aw_pending<=0; w_pending<=0; s_axi_bvalid<=1; end
            if (s_axi_rvalid && s_axi_rready) s_axi_rvalid<=0;
            if (read_fire) begin
                s_axi_rvalid<=1;
                case (s_axi_araddr[3:2])
                    0: s_axi_rdata<=rx_count!=0 ? {24'b0,rx_fifo[rx_rd]} : 0;
                    2: s_axi_rdata<={25'b0,framing,overrun,irq_enable,(tx_count==16),
                                    (tx_count==0 && tx_bits==0),(rx_count==16),(rx_count!=0)};
                    default: s_axi_rdata<=0;
                endcase
            end
            if (control_write) irq_enable<=wdata[4];
            if (read_fire && s_axi_araddr[3:2]==2) begin overrun<=0; framing<=0; end
            if (tx_push) begin tx_fifo[tx_wr]<=wdata[7:0]; tx_wr<=tx_wr+1'b1; end
            if (tx_pop) begin
                tx_shift<={1'b1,tx_fifo[tx_rd],1'b0}; tx_rd<=tx_rd+1'b1;
                tx_bits<=10; tx_timer<=DIV-1;
            end else if (tx_bits!=0) begin
                if (tx_timer==0) begin tx_shift<={1'b1,tx_shift[9:1]}; tx_bits<=tx_bits-1'b1; tx_timer<=DIV-1; end
                else tx_timer<=tx_timer-1'b1;
            end
            case ({tx_push,tx_pop})
                2'b10: tx_count<=tx_count+1'b1;
                2'b01: tx_count<=tx_count-1'b1;
                default: ;
            endcase
            if (!rx_busy) begin
                if (!rx_sync[1]) begin rx_busy<=1; rx_bits<=0; rx_timer<=DIV/2-1; end
            end else if (rx_timer!=0) rx_timer<=rx_timer-1'b1;
            else begin
                rx_timer<=DIV-1;
                if (rx_bits==0 && rx_sync[1]) rx_busy<=0; // false start
                else if (rx_bits==9) begin
                    rx_busy<=0;
                    if (!rx_sync[1]) framing<=1;
                    else if (rx_count==16) overrun<=1;
                end else begin
                    if (rx_bits!=0) rx_shift[rx_bits-1]<=rx_sync[1];
                    rx_bits<=rx_bits+1'b1;
                end
            end
            if (rx_push) begin rx_fifo[rx_wr]<=rx_shift; rx_wr<=rx_wr+1'b1; end
            if (rx_pop) rx_rd<=rx_rd+1'b1;
            case ({rx_push,rx_pop})
                2'b10: rx_count<=rx_count+1'b1;
                2'b01: rx_count<=rx_count-1'b1;
                default: ;
            endcase
            if (reset_tx) begin tx_wr<=0; tx_rd<=0; tx_count<=0; tx_bits<=0; end
            if (reset_rx) begin rx_wr<=0; rx_rd<=0; rx_count<=0; rx_busy<=0; framing<=0; overrun<=0; end
        end
    end
endmodule
