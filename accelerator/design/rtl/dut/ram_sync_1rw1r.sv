module ram_sync_1rw1r#(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8,
  parameter DEPTH = 256,
  parameter DELAY = 0
)(
  input clk,
  input wen,
  input [ADDR_WIDTH - 1 : 0] wadr,
  input [DATA_WIDTH - 1 : 0] wdata,
  input ren,
  input [ADDR_WIDTH - 1 : 0] radr,
  output [DATA_WIDTH - 1 : 0] rdata
);

  genvar i, j;

  generate
    if (DEPTH > 256) begin

      wire [DATA_WIDTH - 1 : 0] rdata_w [DEPTH/256 - 1 : 0];
      reg  [ADDR_WIDTH - 1 : 0] radr_r;

      always @ (posedge clk) begin
        radr_r <= radr;
      end

      for (i = 0; i < DEPTH / 256; i = i + 1) begin: depth_macro
        for (j = 0; j < DATA_WIDTH / 32; j = j + 1) begin: width_macro
          sky130_sram_1kbyte_1rw1r_32x256_8 #(
            .VERBOSE(0)
          ) sram_macro (
            .clk0(clk),
            .csb0(~(wen && (wadr[ADDR_WIDTH - 1 : 8] == i))),
            .web0(~(wen && (wadr[ADDR_WIDTH - 1 : 8] == i))),
            .wmask0(4'hF),
            .addr0(wadr[7 : 0]),
            .din0(wdata[j*32 +: 32]),
            .dout0(),
            .clk1(clk),
            .csb1(~(ren && (radr[ADDR_WIDTH - 1 : 8] == i))),
            .addr1(radr[7 : 0]),
            .dout1(rdata_w[i][j*32 +: 32])
          );
        end
      end

      assign rdata = rdata_w[radr_r[ADDR_WIDTH - 1 : 8]];

    end else if (DEPTH == 256) begin

      for (i = 0; i < DATA_WIDTH/32; i = i + 1) begin: width_macro
        sky130_sram_1kbyte_1rw1r_32x256_8 #(
          .VERBOSE(0)
        ) sram (
          .clk0(clk),
          .csb0(~wen),
          .web0(~wen), // And wadr in range
          .wmask0(4'hF),
          .addr0(wadr),
          .din0(wdata[32*i +: 32]),
          .dout0(),
          .clk1(clk),
          .csb1(~ren), // And radr in range
          .addr1(radr),
          .dout1(rdata[32*i +: 32])
        );
      end

    end
  endgenerate

endmodule
