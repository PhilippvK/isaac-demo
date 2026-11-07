module cva5_top (
    input wire clk,
    input wire rst,

	// output wire [31:0] instruction_bram_addr,
	// output wire        instruction_bram_en,
	// output wire [3:0]  instruction_bram_we,
	// output wire [31:0] instruction_bram_din,
	// input  wire [31:0] instruction_bram_dout,

	// output wire [31:0] data_bram_addr,
	// output wire        data_bram_en,
	// output wire [3:0]  data_bram_we,
	// output wire [31:0] data_bram_din,
	// input  wire [31:0] data_bram_dout,

    // // Generic LSU memory interface
    // output wire dgeneric_new_request,
    // output wire [31:0] dgeneric_addr,
    // output wire dgeneric_re,
    // output wire dgeneric_we,
    // output wire [3:0] dgeneric_be,
    // output wire [31:0] dgeneric_data_in,
    // input wire [31:0] dgeneric_data_out,
    // input wire dgeneric_data_valid,
    // input wire dgeneric_ready,

    // // Generic Fetch memory interface
    // output wire igeneric_new_request,
    // output wire [31:0] igeneric_addr,
    // output wire igeneric_re,
    // output wire igeneric_we,
    // output wire [3:0] igeneric_be,
    // output wire [31:0] igeneric_data_in,
    // input wire [31:0] igeneric_data_out,
    // input wire igeneric_data_valid,
    // input wire igeneric_ready,

	// AXI Bus
	// AXI Write Channels
	output wire                            m_axi_awvalid,
	input  wire                            m_axi_awready,
	// output wire [5:0]                      m_axi_awid,
	output wire [31:0]                     m_axi_awaddr,
	//~ output wire [3:0]                      m_axi_awregion,
	output wire [7:0]                      m_axi_awlen,
	output wire [2:0]                      m_axi_awsize,
	output wire [1:0]                      m_axi_awburst,
	//~ output wire                            m_axi_awlock,
	output wire [3:0]                      m_axi_awcache,
	//~ output wire [2:0]                      m_axi_awprot,
	//~ output wire [3:0]                      m_axi_awqos,

	output wire                            m_axi_wvalid,
	input  wire                            m_axi_wready,
	output wire [31:0]                     m_axi_wdata,
	output wire [3:0]                      m_axi_wstrb,
	output wire                            m_axi_wlast,

	input  wire                            m_axi_bvalid,
	output wire                            m_axi_bready,
	input  wire [1:0]                      m_axi_bresp,
	// input  wire [5:0]                      m_axi_bid,

	// AXI Read Channels
	output wire                            m_axi_arvalid,
	input  wire                            m_axi_arready,
	// output wire [5:0]                      m_axi_arid,
	output wire [31:0]                     m_axi_araddr,
	//~ output wire [3:0]                      m_axi_arregion,
	output wire [7:0]                      m_axi_arlen,
	output wire [2:0]                      m_axi_arsize,
	output wire [1:0]                      m_axi_arburst,
	//~ output wire                            m_axi_arlock,
	output wire [3:0]                      m_axi_arcache,
	//~ output wire [2:0]                      m_axi_arprot,
	//~ output wire [3:0]                      m_axi_arqos,

	input  wire                            m_axi_rvalid,
	output wire                            m_axi_rready,
	// input  wire [5:0]                      m_axi_rid,
	input  wire [31:0]                     m_axi_rdata,
	input  wire [1:0]                      m_axi_rresp,
	input  wire                            m_axi_rlast,

	// AXI Cache
	// AXI Write Channels
	output wire                            m_axi_cache_awvalid,
	input  wire                            m_axi_cache_awready,
	output wire [5:0]                      m_axi_cache_awid,
	output wire [31:0]                     m_axi_cache_awaddr,
	//~ output wire [3:0]                      m_axi_cache_awregion,
	output wire [7:0]                      m_axi_cache_awlen,
	output wire [2:0]                      m_axi_cache_awsize,
	output wire [1:0]                      m_axi_cache_awburst,
	//~ output wire                            m_axi_cache_awlock,
	output wire [3:0]                      m_axi_cache_awcache,
	output wire [2:0]                      m_axi_cache_awprot,
	//~ output wire [3:0]                      m_axi_cache_awqos,

	output wire                            m_axi_cache_wvalid,
	input  wire                            m_axi_cache_wready,
	output wire [31:0]                     m_axi_cache_wdata,
	output wire [3:0]                      m_axi_cache_wstrb,
	output wire                            m_axi_cache_wlast,

	input  wire                            m_axi_cache_bvalid,
	output wire                            m_axi_cache_bready,
	input  wire [1:0]                      m_axi_cache_bresp,
	input  wire [5:0]                      m_axi_cache_bid,

	// AXI Read Channels
	output wire                            m_axi_cache_arvalid,
	input  wire                            m_axi_cache_arready,
	output wire [5:0]                      m_axi_cache_arid,
	output wire [31:0]                     m_axi_cache_araddr,
	//~ output wire [3:0]                      m_axi_cache_arregion,
	output wire [7:0]                      m_axi_cache_arlen,
	output wire [2:0]                      m_axi_cache_arsize,
	output wire [1:0]                      m_axi_cache_arburst,
	//~ output wire                            m_axi_cache_arlock,
	output wire [3:0]                      m_axi_cache_arcache,
	output wire [2:0]                      m_axi_cache_arprot,
	//~ output wire [3:0]                      m_axi_cache_arqos,

	input  wire                            m_axi_cache_rvalid,
	output wire                            m_axi_cache_rready,
	input  wire [5:0]                      m_axi_cache_rid,
	input  wire [31:0]                     m_axi_cache_rdata,
	input  wire [1:0]                      m_axi_cache_rresp,
	input  wire                            m_axi_cache_rlast // ,

	// input wire timer_interrupt,
	// input wire interrupt
);

    // Instruction Memory Signals
    wire [31:0] instruction_bram_addr;
    wire        instruction_bram_en;
    wire [3:0]  instruction_bram_we;
    wire [31:0] instruction_bram_din;
    wire [31:0] instruction_bram_dout;

    // Data Memory Signals
    wire [31:0] data_bram_addr;
    wire        data_bram_en;
    wire [3:0]  data_bram_we;
    wire [31:0] data_bram_din;
    wire [31:0] data_bram_dout;

     // **Instruction Memory BRAM Instantiation**
    blk_mem_gen_0 instruction_bram (
        .clka(clk),
        // .rsta(rst),
        .ena(instruction_bram_en),
        .wea(instruction_bram_we),
        .addra(instruction_bram_addr[17:2]),
        .dina(instruction_bram_din),
        .douta(instruction_bram_dout)
    );

    // **Data Memory BRAM Instantiation**
    blk_mem_gen_0 data_bram (
        .clka(clk),
        // .rsta(rst),
        .ena(data_bram_en),
        .wea(data_bram_we),
        .addra(data_bram_addr[17:2]),
        .dina(data_bram_din),
        .douta(data_bram_dout)
    );
    wire core_RdIValid_FUSED_BLT_3_from_scal;
    wire core_RdIValid_FUSED_BEQ_1_from_scal;
    wire core_RdInStageValid_1_to_scal;
    wire [32-1:0] core_RdInstr_2_to_scal;
    wire core_RdPipeInto_stage_executesv1_2_to_scal;
    wire core_WrFlush_1_from_scal;
    wire core_RdInStageValid_3_to_scal;
    wire core_glueToSCAL_IValid_cond_all_2_to_scal;
    wire [32-1:0] core_RdRS1_2_to_scal;
    wire core_RdIValid_FUSED_BNE_1_from_scal;
    wire core_RdIValid_FUSED_BLTU_1_from_scal;
    wire core_RdStall_1_to_scal;
    wire core_WrPC_validReq_2_from_scal;
    wire core_RdStall_3_to_scal;
    wire core_RdIValid_FUSED_BGEU_1_from_scal;
    wire core_RdFlush_2_to_scal;
    wire core_RdIValid_FUSED_BEQ_3_from_scal;
    wire core_RdIValid_FUSED_BGE_1_from_scal;
    wire core_RdIValid_FUSED_BLT_1_from_scal;
    wire core_RdFlush_3_to_scal;
    wire [32-1:0] core_RdRS2_2_to_scal;
    wire [32-1:0] core_RdInstr_1_to_scal;
    wire core_RdIValid_FUSED_BGEU_3_from_scal;
    wire core_RdInStageValid_2_to_scal;
    wire [32-1:0] core_WrPC_2_from_scal;
    wire core_glueToSCAL_IValid_cond_all_3_to_scal;
    wire core_glueToSCAL_IValid_cond_all_1_to_scal;
    wire core_RdIValid_FUSED_BNE_3_from_scal;
    wire core_RdStall_2_to_scal;
    wire [32-1:0] core_RdPC_2_to_scal;
    wire core_RdIValid_FUSED_BGE_3_from_scal;
    wire core_RdIValid_FUSED_BLTU_3_from_scal;
    wire core_RdFlush_1_to_scal;

	// assign dgeneric_new_request = 0;
	// assign igeneric_new_request = 0;
    cva5_wrapper_verilog cva5 (
        .clk(clk),
        .rst(rst),

        .instruction_bram_addr(instruction_bram_addr),
        .instruction_bram_en(instruction_bram_en),
        .instruction_bram_we(instruction_bram_we),
        .instruction_bram_din(instruction_bram_din),
        .instruction_bram_dout(instruction_bram_dout),
        .data_bram_addr(data_bram_addr),
        .data_bram_en(data_bram_en),
        .data_bram_we(data_bram_we),
        .data_bram_din(data_bram_din),
        .data_bram_dout(data_bram_dout),
        .m_axi_awvalid(m_axi_awvalid),
        .m_axi_awready(m_axi_awready),
        // .m_axi_awid(m_axi_awid),
        .m_axi_awaddr(m_axi_awaddr),
        //.m_axi_awregion(m_axi_awregion),
        .m_axi_awlen(m_axi_awlen),
        .m_axi_awsize(m_axi_awsize),
        .m_axi_awburst(m_axi_awburst),
        //.m_axi_awlock(m_axi_awlock),
        .m_axi_awcache(m_axi_awcache),
        //.m_axi_awprot(m_axi_awprot),
        //.m_axi_awqos(m_axi_awqos),
        .m_axi_wvalid(m_axi_wvalid),
        .m_axi_wready(m_axi_wready),
        .m_axi_wdata(m_axi_wdata),
        .m_axi_wstrb(m_axi_wstrb),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_bready(m_axi_bready),
        .m_axi_bresp(m_axi_bresp),
        // .m_axi_bid(m_axi_bid),
        .m_axi_arvalid(m_axi_arvalid),
        .m_axi_arready(m_axi_arready),
        // .m_axi_arid(m_axi_arid),
        .m_axi_araddr(m_axi_araddr),
        //.m_axi_arregion(m_axi_arregion),
        .m_axi_arlen(m_axi_arlen),
        .m_axi_arsize(m_axi_arsize),
        .m_axi_arburst(m_axi_arburst),
        //.m_axi_arlock(m_axi_arlock),
        .m_axi_arcache(m_axi_arcache),
        //.m_axi_arprot(m_axi_arprot),
        //.m_axi_arqos(m_axi_arqos),
        .m_axi_rvalid(m_axi_rvalid),
        .m_axi_rready(m_axi_rready),
        // .m_axi_rid(m_axi_rid),
        .m_axi_rdata(m_axi_rdata),
        .m_axi_rresp(m_axi_rresp),
        .m_axi_rlast(m_axi_rlast),

        .m_axi_cache_awvalid(m_axi_cache_awvalid),
        .m_axi_cache_awready(m_axi_cache_awready),
        .m_axi_cache_awid(m_axi_cache_awid),
        .m_axi_cache_awaddr(m_axi_cache_awaddr),
        .m_axi_cache_awlen(m_axi_cache_awlen),
        .m_axi_cache_awsize(m_axi_cache_awsize),
        .m_axi_cache_awburst(m_axi_cache_awburst),
        .m_axi_cache_awcache(m_axi_cache_awcache),
        .m_axi_cache_awprot(m_axi_cache_awprot),
        .m_axi_cache_wvalid(m_axi_cache_wvalid),
        .m_axi_cache_wready(m_axi_cache_wready),
        .m_axi_cache_wdata(m_axi_cache_wdata),
        .m_axi_cache_wstrb(m_axi_cache_wstrb),
        .m_axi_cache_wlast(m_axi_cache_wlast),
        .m_axi_cache_bvalid(m_axi_cache_bvalid),
        .m_axi_cache_bready(m_axi_cache_bready),
        .m_axi_cache_bresp(m_axi_cache_bresp),
        .m_axi_cache_bid(m_axi_cache_bid),
        .m_axi_cache_arvalid(m_axi_cache_arvalid),
        .m_axi_cache_arready(m_axi_cache_arready),
        .m_axi_cache_arid(m_axi_cache_arid),
        .m_axi_cache_araddr(m_axi_cache_araddr),
        .m_axi_cache_arlen(m_axi_cache_arlen),
        .m_axi_cache_arsize(m_axi_cache_arsize),
        .m_axi_cache_arburst(m_axi_cache_arburst),
        .m_axi_cache_arcache(m_axi_cache_arcache),
        .m_axi_cache_arprot(m_axi_cache_arprot),
        .m_axi_cache_rvalid(m_axi_cache_rvalid),
        .m_axi_cache_rready(m_axi_cache_rready),
        .m_axi_cache_rid(m_axi_cache_rid),
        .m_axi_cache_rdata(m_axi_cache_rdata),
        .m_axi_cache_rresp(m_axi_cache_rresp),
        .m_axi_cache_rlast(m_axi_cache_rlast) // ,

        // .timer_interrupt(timer_interrupt),
        // .interrupt(interrupt)

        ,.RdIValid_FUSED_BLT_3_i(core_RdIValid_FUSED_BLT_3_from_scal)
        ,.RdIValid_FUSED_BEQ_1_i(core_RdIValid_FUSED_BEQ_1_from_scal)
        ,.RdInStageValid_1_o(core_RdInStageValid_1_to_scal)
        ,.RdInstr_2_o(core_RdInstr_2_to_scal)
        ,.RdPipeInto_stage_executesv1_2_o(core_RdPipeInto_stage_executesv1_2_to_scal)
        ,.WrFlush_1_i(core_WrFlush_1_from_scal)
        ,.RdInStageValid_3_o(core_RdInStageValid_3_to_scal)
        ,.glueToSCAL_IValid_cond_all_2_o(core_glueToSCAL_IValid_cond_all_2_to_scal)
        ,.RdRS1_2_o(core_RdRS1_2_to_scal)
        ,.RdIValid_FUSED_BNE_1_i(core_RdIValid_FUSED_BNE_1_from_scal)
        ,.RdIValid_FUSED_BLTU_1_i(core_RdIValid_FUSED_BLTU_1_from_scal)
        ,.RdStall_1_o(core_RdStall_1_to_scal)
        ,.WrPC_validReq_2_i(core_WrPC_validReq_2_from_scal)
        ,.RdStall_3_o(core_RdStall_3_to_scal)
        ,.RdIValid_FUSED_BGEU_1_i(core_RdIValid_FUSED_BGEU_1_from_scal)
        ,.RdFlush_2_o(core_RdFlush_2_to_scal)
        ,.RdIValid_FUSED_BEQ_3_i(core_RdIValid_FUSED_BEQ_3_from_scal)
        ,.RdIValid_FUSED_BGE_1_i(core_RdIValid_FUSED_BGE_1_from_scal)
        ,.RdIValid_FUSED_BLT_1_i(core_RdIValid_FUSED_BLT_1_from_scal)
        ,.RdFlush_3_o(core_RdFlush_3_to_scal)
        ,.RdRS2_2_o(core_RdRS2_2_to_scal)
        ,.RdInstr_1_o(core_RdInstr_1_to_scal)
        ,.RdIValid_FUSED_BGEU_3_i(core_RdIValid_FUSED_BGEU_3_from_scal)
        ,.RdInStageValid_2_o(core_RdInStageValid_2_to_scal)
        ,.WrPC_2_i(core_WrPC_2_from_scal)
        ,.glueToSCAL_IValid_cond_all_3_o(core_glueToSCAL_IValid_cond_all_3_to_scal)
        ,.glueToSCAL_IValid_cond_all_1_o(core_glueToSCAL_IValid_cond_all_1_to_scal)
        ,.RdIValid_FUSED_BNE_3_i(core_RdIValid_FUSED_BNE_3_from_scal)
        ,.RdStall_2_o(core_RdStall_2_to_scal)
        ,.RdPC_2_o(core_RdPC_2_to_scal)
        ,.RdIValid_FUSED_BGE_3_i(core_RdIValid_FUSED_BGE_3_from_scal)
        ,.RdIValid_FUSED_BLTU_3_i(core_RdIValid_FUSED_BLTU_3_from_scal)
        ,.RdFlush_1_o(core_RdFlush_1_to_scal)
    );

    wire [32-1:0] isax_RdRS1_2_from_scal;
    wire isax_RdStall_FUSED_BGE_2_from_scal;
    wire isax_WrPC_validReq_FUSED_BLTU_2_to_scal;
    wire isax_RdIValid_FUSED_BEQ_2_from_scal;
    wire [32-1:0] isax_RdPC_2_from_scal;
    wire isax_RdIValid_FUSED_BGEU_1_from_scal;
    wire isax_RdStall_FUSED_BLTU_2_from_scal;
    wire [32-1:0] isax_RdInstr_2_from_scal;
    wire isax_RdIValid_FUSED_BNE_2_from_scal;
    wire [32-1:0] isax_RdRS2_2_from_scal;
    wire isax_WrPC_validReq_FUSED_BGE_2_to_scal;
    wire [32-1:0] isax_WrPC_FUSED_BGE_2_to_scal;
    wire isax_RdIValid_FUSED_BGE_2_from_scal;
    wire [32-1:0] isax_WrPC_FUSED_BLTU_2_to_scal;
    wire isax_RdIValid_FUSED_BEQ_1_from_scal;
    wire [32-1:0] isax_WrPC_FUSED_BNE_2_to_scal;
    wire isax_RdIValid_FUSED_BLTU_1_from_scal;
    wire isax_WrPC_validReq_FUSED_BGEU_2_to_scal;
    wire isax_RdIValid_FUSED_BLT_1_from_scal;
    wire isax_RdStall_FUSED_BGEU_2_from_scal;
    wire isax_RdIValid_FUSED_BGE_1_from_scal;
    wire [32-1:0] isax_WrPC_FUSED_BGEU_2_to_scal;
    wire isax_WrPC_validReq_FUSED_BLT_2_to_scal;
    wire isax_WrPC_validReq_FUSED_BNE_2_to_scal;
    wire [32-1:0] isax_WrPC_FUSED_BLT_2_to_scal;
    wire isax_RdIValid_FUSED_BLTU_2_from_scal;
    wire isax_RdIValid_FUSED_BLT_2_from_scal;
    wire isax_RdStall_FUSED_BLT_2_from_scal;
    wire isax_RdStall_FUSED_BNE_2_from_scal;
    wire isax_RdStall_FUSED_BEQ_2_from_scal;
    wire isax_RdIValid_FUSED_BGEU_2_from_scal;
    wire isax_RdIValid_FUSED_BNE_1_from_scal;
    wire [32-1:0] isax_WrPC_FUSED_BEQ_2_to_scal;
    wire isax_WrPC_validReq_FUSED_BEQ_2_to_scal;

    SCAL scal (
        .clk_i(clk)
        ,.rst_i(rst)
        ,.RdRS1_2_o(isax_RdRS1_2_from_scal)
        ,.RdStall_FUSED_BGE_2_o(isax_RdStall_FUSED_BGE_2_from_scal)
        ,.core_RdIValid_FUSED_BLT_3_o(core_RdIValid_FUSED_BLT_3_from_scal)
        ,.core_RdIValid_FUSED_BEQ_1_o(core_RdIValid_FUSED_BEQ_1_from_scal)
        ,.RdInStageValid_1_i(core_RdInStageValid_1_to_scal)
        ,.WrPC_validReq_FUSED_BLTU_2_i(isax_WrPC_validReq_FUSED_BLTU_2_to_scal)
        ,.RdInstr_2_i(core_RdInstr_2_to_scal)
        ,.RdIValid_FUSED_BEQ_2_o(isax_RdIValid_FUSED_BEQ_2_from_scal)
        ,.RdPC_2_o(isax_RdPC_2_from_scal)
        ,.RdIValid_FUSED_BGEU_1_o(isax_RdIValid_FUSED_BGEU_1_from_scal)
        ,.RdStall_FUSED_BLTU_2_o(isax_RdStall_FUSED_BLTU_2_from_scal)
        ,.RdInstr_2_o(isax_RdInstr_2_from_scal)
        ,.RdIValid_FUSED_BNE_2_o(isax_RdIValid_FUSED_BNE_2_from_scal)
        ,.RdRS2_2_o(isax_RdRS2_2_from_scal)
        ,.core_RdPipeInto_stage_executesv1_2_i(core_RdPipeInto_stage_executesv1_2_to_scal)
        ,.WrPC_validReq_FUSED_BGE_2_i(isax_WrPC_validReq_FUSED_BGE_2_to_scal)
        ,.WrFlush_1_o(core_WrFlush_1_from_scal)
        ,.WrPC_FUSED_BGE_2_i(isax_WrPC_FUSED_BGE_2_to_scal)
        ,.RdInStageValid_3_i(core_RdInStageValid_3_to_scal)
        ,.RdIValid_FUSED_BGE_2_o(isax_RdIValid_FUSED_BGE_2_from_scal)
        ,.glueToSCAL_IValid_cond_all_2_i(core_glueToSCAL_IValid_cond_all_2_to_scal)
        ,.RdRS1_2_i(core_RdRS1_2_to_scal)
        ,.core_RdIValid_FUSED_BNE_1_o(core_RdIValid_FUSED_BNE_1_from_scal)
        ,.core_RdIValid_FUSED_BLTU_1_o(core_RdIValid_FUSED_BLTU_1_from_scal)
        ,.RdStall_1_i(core_RdStall_1_to_scal)
        ,.WrPC_FUSED_BLTU_2_i(isax_WrPC_FUSED_BLTU_2_to_scal)
        ,.RdIValid_FUSED_BEQ_1_o(isax_RdIValid_FUSED_BEQ_1_from_scal)
        ,.WrPC_FUSED_BNE_2_i(isax_WrPC_FUSED_BNE_2_to_scal)
        ,.WrPC_validReq_2_o(core_WrPC_validReq_2_from_scal)
        ,.RdIValid_FUSED_BLTU_1_o(isax_RdIValid_FUSED_BLTU_1_from_scal)
        ,.RdStall_3_i(core_RdStall_3_to_scal)
        ,.core_RdIValid_FUSED_BGEU_1_o(core_RdIValid_FUSED_BGEU_1_from_scal)
        ,.RdFlush_2_i(core_RdFlush_2_to_scal)
        ,.core_RdIValid_FUSED_BEQ_3_o(core_RdIValid_FUSED_BEQ_3_from_scal)
        ,.WrPC_validReq_FUSED_BGEU_2_i(isax_WrPC_validReq_FUSED_BGEU_2_to_scal)
        ,.core_RdIValid_FUSED_BGE_1_o(core_RdIValid_FUSED_BGE_1_from_scal)
        ,.RdIValid_FUSED_BLT_1_o(isax_RdIValid_FUSED_BLT_1_from_scal)
        ,.RdStall_FUSED_BGEU_2_o(isax_RdStall_FUSED_BGEU_2_from_scal)
        ,.core_RdIValid_FUSED_BLT_1_o(core_RdIValid_FUSED_BLT_1_from_scal)
        ,.RdIValid_FUSED_BGE_1_o(isax_RdIValid_FUSED_BGE_1_from_scal)
        ,.WrPC_FUSED_BGEU_2_i(isax_WrPC_FUSED_BGEU_2_to_scal)
        ,.RdFlush_3_i(core_RdFlush_3_to_scal)
        ,.RdRS2_2_i(core_RdRS2_2_to_scal)
        ,.WrPC_validReq_FUSED_BLT_2_i(isax_WrPC_validReq_FUSED_BLT_2_to_scal)
        ,.WrPC_validReq_FUSED_BNE_2_i(isax_WrPC_validReq_FUSED_BNE_2_to_scal)
        ,.RdInstr_1_i(core_RdInstr_1_to_scal)
        ,.WrPC_FUSED_BLT_2_i(isax_WrPC_FUSED_BLT_2_to_scal)
        ,.RdIValid_FUSED_BLTU_2_o(isax_RdIValid_FUSED_BLTU_2_from_scal)
        ,.core_RdIValid_FUSED_BGEU_3_o(core_RdIValid_FUSED_BGEU_3_from_scal)
        ,.RdIValid_FUSED_BLT_2_o(isax_RdIValid_FUSED_BLT_2_from_scal)
        ,.RdStall_FUSED_BLT_2_o(isax_RdStall_FUSED_BLT_2_from_scal)
        ,.RdStall_FUSED_BNE_2_o(isax_RdStall_FUSED_BNE_2_from_scal)
        ,.RdInStageValid_2_i(core_RdInStageValid_2_to_scal)
        ,.WrPC_2_o(core_WrPC_2_from_scal)
        ,.glueToSCAL_IValid_cond_all_3_i(core_glueToSCAL_IValid_cond_all_3_to_scal)
        ,.glueToSCAL_IValid_cond_all_1_i(core_glueToSCAL_IValid_cond_all_1_to_scal)
        ,.core_RdIValid_FUSED_BNE_3_o(core_RdIValid_FUSED_BNE_3_from_scal)
        ,.RdStall_FUSED_BEQ_2_o(isax_RdStall_FUSED_BEQ_2_from_scal)
        ,.RdStall_2_i(core_RdStall_2_to_scal)
        ,.RdPC_2_i(core_RdPC_2_to_scal)
        ,.core_RdIValid_FUSED_BGE_3_o(core_RdIValid_FUSED_BGE_3_from_scal)
        ,.core_RdIValid_FUSED_BLTU_3_o(core_RdIValid_FUSED_BLTU_3_from_scal)
        ,.RdIValid_FUSED_BGEU_2_o(isax_RdIValid_FUSED_BGEU_2_from_scal)
        ,.RdIValid_FUSED_BNE_1_o(isax_RdIValid_FUSED_BNE_1_from_scal)
        ,.WrPC_FUSED_BEQ_2_i(isax_WrPC_FUSED_BEQ_2_to_scal)
        ,.WrPC_validReq_FUSED_BEQ_2_i(isax_WrPC_validReq_FUSED_BEQ_2_to_scal)
        ,.RdFlush_1_i(core_RdFlush_1_to_scal)
    );

    ISAX_XBranch isax_xbranch (
        .clk_i(clk)
        ,.rst_i(rst)
        ,.RdRS1_FUSED_BGE_2_i(isax_RdRS1_2_from_scal)
        ,.RdStall_FUSED_BGE_2_i(isax_RdStall_FUSED_BGE_2_from_scal)
        ,.WrPC_validReq_FUSED_BLTU_2_o(isax_WrPC_validReq_FUSED_BLTU_2_to_scal)
        ,.RdIValid_FUSED_BEQ_2_i(isax_RdIValid_FUSED_BEQ_2_from_scal)
        ,.RdPC_FUSED_BLT_2_i(isax_RdPC_2_from_scal)
        ,.RdIValid_FUSED_BGEU_1_i(isax_RdIValid_FUSED_BGEU_1_from_scal)
        ,.RdStall_FUSED_BLTU_2_i(isax_RdStall_FUSED_BLTU_2_from_scal)
        ,.RdInstr_FUSED_BNE_2_i(isax_RdInstr_2_from_scal)
        ,.RdIValid_FUSED_BNE_2_i(isax_RdIValid_FUSED_BNE_2_from_scal)
        ,.RdInstr_FUSED_BEQ_2_i(isax_RdInstr_2_from_scal)
        ,.RdRS2_FUSED_BNE_2_i(isax_RdRS2_2_from_scal)
        ,.WrPC_validReq_FUSED_BGE_2_o(isax_WrPC_validReq_FUSED_BGE_2_to_scal)
        ,.WrPC_FUSED_BGE_2_o(isax_WrPC_FUSED_BGE_2_to_scal)
        ,.RdIValid_FUSED_BGE_2_i(isax_RdIValid_FUSED_BGE_2_from_scal)
        ,.RdPC_FUSED_BGEU_2_i(isax_RdPC_2_from_scal)
        ,.WrPC_FUSED_BLTU_2_o(isax_WrPC_FUSED_BLTU_2_to_scal)
        ,.RdIValid_FUSED_BEQ_1_i(isax_RdIValid_FUSED_BEQ_1_from_scal)
        ,.WrPC_FUSED_BNE_2_o(isax_WrPC_FUSED_BNE_2_to_scal)
        ,.RdIValid_FUSED_BLTU_1_i(isax_RdIValid_FUSED_BLTU_1_from_scal)
        ,.RdRS2_FUSED_BEQ_2_i(isax_RdRS2_2_from_scal)
        ,.RdRS2_FUSED_BGEU_2_i(isax_RdRS2_2_from_scal)
        ,.RdPC_FUSED_BGE_2_i(isax_RdPC_2_from_scal)
        ,.WrPC_validReq_FUSED_BGEU_2_o(isax_WrPC_validReq_FUSED_BGEU_2_to_scal)
        ,.RdRS1_FUSED_BLT_2_i(isax_RdRS1_2_from_scal)
        ,.RdIValid_FUSED_BLT_1_i(isax_RdIValid_FUSED_BLT_1_from_scal)
        ,.RdRS2_FUSED_BLTU_2_i(isax_RdRS2_2_from_scal)
        ,.RdStall_FUSED_BGEU_2_i(isax_RdStall_FUSED_BGEU_2_from_scal)
        ,.RdIValid_FUSED_BGE_1_i(isax_RdIValid_FUSED_BGE_1_from_scal)
        ,.WrPC_FUSED_BGEU_2_o(isax_WrPC_FUSED_BGEU_2_to_scal)
        ,.WrPC_validReq_FUSED_BLT_2_o(isax_WrPC_validReq_FUSED_BLT_2_to_scal)
        ,.RdPC_FUSED_BLTU_2_i(isax_RdPC_2_from_scal)
        ,.RdRS2_FUSED_BLT_2_i(isax_RdRS2_2_from_scal)
        ,.WrPC_validReq_FUSED_BNE_2_o(isax_WrPC_validReq_FUSED_BNE_2_to_scal)
        ,.RdRS1_FUSED_BGEU_2_i(isax_RdRS1_2_from_scal)
        ,.RdInstr_FUSED_BGE_2_i(isax_RdInstr_2_from_scal)
        ,.WrPC_FUSED_BLT_2_o(isax_WrPC_FUSED_BLT_2_to_scal)
        ,.RdInstr_FUSED_BLTU_2_i(isax_RdInstr_2_from_scal)
        ,.RdIValid_FUSED_BLTU_2_i(isax_RdIValid_FUSED_BLTU_2_from_scal)
        ,.RdIValid_FUSED_BLT_2_i(isax_RdIValid_FUSED_BLT_2_from_scal)
        ,.RdStall_FUSED_BLT_2_i(isax_RdStall_FUSED_BLT_2_from_scal)
        ,.RdStall_FUSED_BNE_2_i(isax_RdStall_FUSED_BNE_2_from_scal)
        ,.RdRS1_FUSED_BEQ_2_i(isax_RdRS1_2_from_scal)
        ,.RdPC_FUSED_BNE_2_i(isax_RdPC_2_from_scal)
        ,.RdInstr_FUSED_BGEU_2_i(isax_RdInstr_2_from_scal)
        ,.RdRS1_FUSED_BLTU_2_i(isax_RdRS1_2_from_scal)
        ,.RdPC_FUSED_BEQ_2_i(isax_RdPC_2_from_scal)
        ,.RdInstr_FUSED_BLT_2_i(isax_RdInstr_2_from_scal)
        ,.RdStall_FUSED_BEQ_2_i(isax_RdStall_FUSED_BEQ_2_from_scal)
        ,.RdRS1_FUSED_BNE_2_i(isax_RdRS1_2_from_scal)
        ,.RdRS2_FUSED_BGE_2_i(isax_RdRS2_2_from_scal)
        ,.RdIValid_FUSED_BGEU_2_i(isax_RdIValid_FUSED_BGEU_2_from_scal)
        ,.RdIValid_FUSED_BNE_1_i(isax_RdIValid_FUSED_BNE_1_from_scal)
        ,.WrPC_FUSED_BEQ_2_o(isax_WrPC_FUSED_BEQ_2_to_scal)
        ,.WrPC_validReq_FUSED_BEQ_2_o(isax_WrPC_validReq_FUSED_BEQ_2_to_scal)
    );


endmodule
