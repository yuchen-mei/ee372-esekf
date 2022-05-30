module ram_sync_1rw1r #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8,
    parameter DEPTH      = 256,
    parameter DELAY      = 0
) (
    input  logic                       clk,
    input  logic                       csb0,
    input  logic                       web0,
    input  logic [(DATA_WIDTH/32-1):0] wmask0,
    input  logic [     ADDR_WIDTH-1:0] addr0,
    input  logic [     DATA_WIDTH-1:0] din0,
    output logic [     DATA_WIDTH-1:0] dout0,
    input  logic                       csb1,
    input  logic [     ADDR_WIDTH-1:0] addr1,
    output logic [     DATA_WIDTH-1:0] dout1
);

    genvar i, j;

    if (DEPTH > 256) begin

        logic [DATA_WIDTH-1:0] dout0_w [DEPTH/256-1:0];
        logic [DATA_WIDTH-1:0] dout1_w [DEPTH/256-1:0];
        logic [ADDR_WIDTH-1:0] addr0_r;
        logic [ADDR_WIDTH-1:0] addr1_r;

        always @ (posedge clk) begin
            addr0_r <= addr0;
            addr1_r <= addr1;
        end

        for (i = 0; i < DEPTH / 256; i = i + 1) begin: depth_macro
            for (j = 0; j < DATA_WIDTH / 32; j = j + 1) begin: width_macro
                sky130_sram_1kbyte_1rw1r_32x256_8 #(
                    .VERBOSE(0                   )
                ) sram_macro (
                    .clk0   (clk                 ),
                    .csb0   (~(csb0 && (addr0[ADDR_WIDTH-1:8] == i))),
                    .web0   (~web0 && wmask0[j]  ),
                    .wmask0 (4'hF                ),
                    .addr0  (addr0[7:0]          ),
                    .din0   (din0[j*32+:32]      ),
                    .dout0  (dout0_w[i][j*32+:32]),
                    .clk1   (clk                 ),
                    .csb1   (~(csb1 && (addr1[ADDR_WIDTH-1:8] == i))),
                    .addr1  (addr1[7:0]          ),
                    .dout1  (dout1_w[i][j*32+:32])
                );
            end
        end

        assign dout0 = dout0_w[addr0_r[ADDR_WIDTH-1:8]];
        assign dout1 = dout1_w[addr1_r[ADDR_WIDTH-1:8]];

    end else if (DEPTH == 256) begin

        for (i = 0; i < DATA_WIDTH/32; i = i + 1) begin: width_macro
            sky130_sram_1kbyte_1rw1r_32x256_8 #(
                .VERBOSE(0                 )
            ) sram_macro (
                .clk0   (clk               ),
                .csb0   (~csb0             ),
                .web0   (~web0 && wmask0[i]),
                .wmask0 (4'hF              ),
                .addr0  (addr0             ),
                .din0   (din0[32*i+:32]    ),
                .dout0  (dout0[32*i+:32]   ),
                .clk1   (clk               ),
                .csb1   (~csb1             ),
                .addr1  (addr1             ),
                .dout1  (dout1[32*i+:32]   )
            );
        end

    end

endmodule
