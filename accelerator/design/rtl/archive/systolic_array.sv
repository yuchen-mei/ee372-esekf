module systolic_array #( 
  parameter DATA_WIDTH = 32,
  parameter ARRAY_HEIGHT = 3,
  parameter ARRAY_WIDTH = 3
)(
  input clk,
  input rst_n,
  input en,
  input signed [DATA_WIDTH - 1 : 0] ifmap_in [ARRAY_HEIGHT - 1 : 0],
  input signed [DATA_WIDTH - 1 : 0] weight_in [ARRAY_WIDTH - 1 : 0],
  output signed [DATA_WIDTH - 1 : 0] ofmap_out [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0]
);

  for (genvar x = 0; x < ARRAY_WIDTH; x = x + 1) begin: col
    for (genvar y = 0; y < ARRAY_HEIGHT; y = y + 1) begin: row
      mac mac_inst (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .data_a(ifmap_in[y]),
        .data_b(weight_in[x]),
        .rnd(3'b0),
        .data_out(ofmap_out[y][x]),
        .status()
      );
    end
  end

endmodule
