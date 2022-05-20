module vector_permute #(
  parameter DATA_WIDTH = 32,
  parameter LEN = 16
)(
  input [LEN*DATA_WIDTH - 1 : 0] src,
  input [2 : 0] func,
  input [2 : 0] width,
  output [LEN*DATA_WIDTH - 1 : 0] vec_out
);

  logic [DATA_WIDTH - 1 : 0] src_unpacked   [LEN - 1 : 0];
  logic [DATA_WIDTH - 1 : 0] src_unpacked_n [LEN - 1 : 0];
  logic [DATA_WIDTH - 1 : 0] skew_symmetric [LEN - 1 : 0];
  logic [DATA_WIDTH - 1 : 0] transpose [LEN - 1 : 0];
  logic [DATA_WIDTH - 1 : 0] vec_out_unpacked [LEN - 1 : 0];

  for (genvar i = 0; i < 3; i = i + 1) begin: unpack_inputs
    assign src_unpacked[i] = src[i*DATA_WIDTH + DATA_WIDTH];
    assign src_unpacked_n[i][DATA_WIDTH - 1] = ~src_unpacked[i][DATA_WIDTH - 1];
    assign src_unpacked_n[i][DATA_WIDTH - 2 : 0] = src_unpacked[i][DATA_WIDTH - 2 : 0];
  end

  assign skew_symmetric[0] = 32'b0;
  assign skew_symmetric[1] = src_unpacked[2];
  assign skew_symmetric[2] = src_unpacked_n[1];
  assign skew_symmetric[3] = src_unpacked_n[2];
  assign skew_symmetric[4] = 32'b0;
  assign skew_symmetric[5] = src_unpacked[0];
  assign skew_symmetric[6] = src_unpacked[1];
  assign skew_symmetric[7] = src_unpacked_n[0];
  assign skew_symmetric[8] = 32'b0;
  
  for (genvar i = 0; i < 3; i = i + 1) begin
    for (genvar j = 0; j < 3; j = j + 1) begin
      assign transpose[3 * i + j] = src_unpacked[3 * j + i];
    end
  end

  if (LEN > 9) begin
    assign skew_symmetric[LEN - 1 : 9] = '{default:0};
    assign transpose[LEN - 1 : 9] = '{default:0};
  end

  always_comb begin
    case (func)
      2'b00:   vec_out_unpacked = skew_symmetric;
      2'b01:   vec_out_unpacked = transpose;
      default: vec_out_unpacked = '{default:0};
    endcase
  end

  assign vec_out = { << { vec_out_unpacked }};

endmodule
