module skew_symmetric #(
  parameter WIDTH = 32
)(
  input [WIDTH - 1 : 0] vec_in [2 : 0],
  output [WIDTH - 1 : 0] matrix_out [8 : 0]
);

  logic [WIDTH - 1 : 0] vec_neg [2 : 0];

  for (genvar i = 0; i < 3; i = i + 1) begin: negate_inputs
    assign vec_neg[i][WIDTH - 1] = ~vec_in[i][WIDTH - 1];
    assign vec_neg[i][WIDTH - 2 : 0] = vec_in[i][WIDTH - 2 : 0];
  end

  assign matrix_out[0] = 32'b0;
  assign matrix_out[1] = vec_in[2];
  assign matrix_out[2] = vec_neg[1];
  assign matrix_out[3] = vec_neg[2];
  assign matrix_out[4] = 32'b0;
  assign matrix_out[5] = vec_in[0];
  assign matrix_out[6] = vec_in[1];
  assign matrix_out[7] = vec_neg[0];
  assign matrix_out[8] = 32'b0;

endmodule
