// CVA5: 256 KiB, synchronous byte-enabled WRITE_FIRST memory.
// Two 32K-word banks avoid the legacy XC7 flow's incompatible 64K-depth
// RAMB36 cascade mapping. Each bank fits non-cascaded 32K x 1 primitives.
module blk_mem_gen_0 (
    input wire clka, ena, input wire [3:0] wea,
    input wire [15:0] addra, input wire [31:0] dina,
    output wire [31:0] douta
);
    wire [31:0] bank_data [0:1];
    reg read_bank;
    always @(posedge clka) if (ena) read_bank <= addra[15];
    assign douta = bank_data[read_bank];
    genvar bank, lane;
    generate for (bank=0; bank<2; bank=bank+1) begin: banks
        (* ram_style = "block" *) reg [31:0] memory [0:32767];
        reg [31:0] data;
        assign bank_data[bank] = data;
        if (bank==0) begin: init_low
            initial $readmemh("firmware-0.hex", memory);
        end else begin: init_high
            initial $readmemh("firmware-1.hex", memory);
        end
        for (lane=0; lane<4; lane=lane+1) begin: bytes
            always @(posedge clka) if (ena && addra[15]==bank) begin
                if (wea[lane]) begin
                    memory[addra[14:0]][lane*8+:8] <= dina[lane*8+:8];
                    data[lane*8+:8] <= dina[lane*8+:8];
                end else data[lane*8+:8] <= memory[addra[14:0]][lane*8+:8];
            end
        end
    end endgenerate
endmodule
