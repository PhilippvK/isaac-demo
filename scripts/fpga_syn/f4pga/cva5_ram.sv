// CVA5 has separate 256 KiB instruction and data memories. Same registered,
// byte-enabled WRITE_FIRST contract as the original single-port Vivado IP.
module blk_mem_gen_0 (
    input wire clka, ena, input wire [3:0] wea,
    input wire [15:0] addra, input wire [31:0] dina,
    output reg [31:0] douta
);
    (* ram_style = "block" *) reg [31:0] memory [0:65535];
    initial $readmemh("firmware.hex", memory);
    genvar lane;
    generate for (lane=0; lane<4; lane=lane+1) begin: bytes
        always @(posedge clka) if (ena) begin
            if (wea[lane]) begin
                memory[addra][lane*8+:8] <= dina[lane*8+:8];
                douta[lane*8+:8] <= dina[lane*8+:8];
            end else douta[lane*8+:8] <= memory[addra][lane*8+:8];
        end
    end endgenerate
endmodule
