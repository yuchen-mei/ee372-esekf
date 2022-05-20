module dff3
#(
  parameter WIDTH = 32,
  parameter ARRAY_SIZE1 = 8,
  parameter ARRAY_SIZE2 = 8,
  parameter PIPE_DEPTH = 1,
  parameter OUT_REG = 1
)
(
  input logic clk,
  input logic rst_n,
  input logic en,
  input logic [WIDTH - 1 : 0] in[ARRAY_SIZE1 - 1 : 0][ARRAY_SIZE2 - 1 : 0],
  output logic [WIDTH - 1 : 0] out[ARRAY_SIZE1 - 1 : 0][ARRAY_SIZE2 - 1 : 0]
);

  for (genvar i = 0; i < ARRAY_SIZE1; i = i + 1) begin
    dff2 #(
      .WIDTH(WIDTH),
      .ARRAY_SIZE(ARRAY_SIZE2),
      .PIPE_DEPTH(PIPE_DEPTH),
      .OUT_REG(OUT_REG)
    )
    dff_arr
    (
      .clk    (clk        ),
      .rst_n  (rst_n      ),
      .en     (en         ),
      .in     (in[i]      ),
      .out    (out[i]     )
    );
  end

endmodule
