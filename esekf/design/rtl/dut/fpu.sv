module fpu #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 9
) (
  input en,
  input [7 : 0] opcode,
  input [SIG_WIDTH + EXP_WIDTH : 0] data_n [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] data_m [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] data_a [LEN - 1 : 0],
  input [3 : 0] index,
  input [LEN - 1 : 0] predicate,
  output logic [SIG_WIDTH + EXP_WIDTH : 0] data_out [LEN - 1 : 0]
);

  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_dp_in [7 : 0][LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_mat_in [7 : 0][LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_quat_in [7 : 0][LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_dp_out [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_out_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_scalar_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_skew_out [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] scalar_out_w;

  for (genvar i = 0; i < LEN; i = i + 1) begin
    assign vec_scalar_w[i] = index == i ? scalar_out_w : data_n[i];
  end

  always_comb begin
    case (opcode[6:5])
      2'b00: data_out = vec_dp_out;
      2'b01: data_out = vec_out_w;
      2'b10: data_out = vec_scalar_w;
      2'b11: data_out = vec_skew_out;
    endcase
  end

  // Operands negate
  logic op1_neg, op3_neg;
  logic [SIG_WIDTH + EXP_WIDTH : 0] op1_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] op2_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] op3_w [LEN - 1 : 0];

  assign op1_neg = opcode[1] ^ opcode[0];
  assign op3_neg = opcode[1];

  for (genvar i = 0; i < LEN; i = i + 1) begin: negate_inputs
    assign op1_w[i][SIG_WIDTH + EXP_WIDTH] = op1_neg ^ data_n[i][SIG_WIDTH + EXP_WIDTH];
    assign op1_w[i][SIG_WIDTH + EXP_WIDTH - 1 : 0] = data_n[i][SIG_WIDTH + EXP_WIDTH - 1 : 0];

    assign op2_w[i] = data_m[i];

    assign op3_w[i][SIG_WIDTH + EXP_WIDTH] = op3_neg ^ data_a[i][SIG_WIDTH + EXP_WIDTH];
    assign op3_w[i][SIG_WIDTH + EXP_WIDTH - 1 : 0] = data_a[i][SIG_WIDTH + EXP_WIDTH - 1 : 0];
  end

  // 3 x 3 x 3 Matrix multiplication
  logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_a [2 : 0][2 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_b [2 : 0][2 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_c [2 : 0][2 : 0];

  genvar i, j;
  for (i = 0; i < 3; i = i + 1) begin: unpack_inputs
    assign matrix_a[i] = op1_w[3 * i +: 3];
    assign matrix_b[i] = op2_w[3 * i +: 3];
    assign matrix_c[i] = op3_w[3 * i +: 3];
  end

  for (i = 0; i < 3; i = i + 1) begin: col
    for (j = 0; j < 3; j = j + 1) begin: row
      assign vec_mat_in[0][3*i+j] = matrix_a[0][j];
      assign vec_mat_in[1][3*i+j] = matrix_b[i][0];
      assign vec_mat_in[2][3*i+j] = matrix_a[1][j];
      assign vec_mat_in[3][3*i+j] = matrix_b[i][1];
      assign vec_mat_in[4][3*i+j] = matrix_a[2][j];
      assign vec_mat_in[5][3*i+j] = matrix_b[i][2];
      assign vec_mat_in[6][3*i+j] = matrix_c[i][j];
      assign vec_mat_in[7][3*i+j] = 32'h3f800000;
    end
  end

  // TODO: Rotation matrix

  // Quaternion Hamilton Product
  logic [SIG_WIDTH + EXP_WIDTH : 0] quat_a [3 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] quat_a_neg [3 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] quat_b [3 : 0];

  for (i = 0; i < 4; i = i + 1) begin
    assign quat_a[i] = data_n[i];
    assign quat_b[i] = data_m[i];
    assign quat_a_neg[i][SIG_WIDTH + EXP_WIDTH] = ~data_n[i][SIG_WIDTH + EXP_WIDTH];
    assign quat_a_neg[i][SIG_WIDTH + EXP_WIDTH - 1 : 0] = data_n[i][SIG_WIDTH + EXP_WIDTH - 1 : 0];
  end

  for (i = 0; i < 8; i = i + 1) begin
    assign vec_quat_in[i][LEN - 1 : 4] = '{default:32'b0};
  end

  assign vec_quat_in[0][3 : 0] = '{quat_a[0],     quat_a[0],     quat_a[0],     quat_a[0]};
  assign vec_quat_in[1][3 : 0] = '{quat_b[3],     quat_b[2],     quat_b[1],     quat_b[0]};
  assign vec_quat_in[2][3 : 0] = '{quat_a[1],     quat_a_neg[1], quat_a[1],     quat_a_neg[1]};
  assign vec_quat_in[3][3 : 0] = '{quat_b[2],     quat_b[3],     quat_b[0],     quat_b[1]};
  assign vec_quat_in[4][3 : 0] = '{quat_a_neg[2], quat_a[2],     quat_a[2],     quat_a_neg[2]};
  assign vec_quat_in[5][3 : 0] = '{quat_b[1],     quat_b[0],     quat_b[3],     quat_b[2]};
  assign vec_quat_in[6][3 : 0] = '{quat_a[3],     quat_a[3],     quat_a_neg[3], quat_a_neg[3]};
  assign vec_quat_in[7][3 : 0] = '{quat_b[0],     quat_b[1],     quat_b[2],     quat_b[3]};
  
  assign vec_dp_in = opcode[2] ? vec_quat_in : vec_mat_in;

  dp_unit #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .LEN(MATRIX_HEIGHT * MATRIX_WIDTH)
  ) dp_unit_inst (
    .vec_a(vec_dp_in[0]),
    .vec_b(vec_dp_in[1]),
    .vec_c(vec_dp_in[2]),
    .vec_d(vec_dp_in[3]),
    .vec_e(vec_dp_in[4]),
    .vec_f(vec_dp_in[5]),
    .vec_g(vec_dp_in[6]),
    .vec_h(vec_dp_in[7]),
    .rnd(3'b0),
    .vec_out(vec_dp_out),
    .status()
  );

  vector_unit #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .LEN(LEN)
  ) vector_unit_inst (
    .vec_a(op1_w),
    .vec_b(op2_w),
    .vec_c(op3_w),
    .rnd(3'b0),
    .op(opcode[4:2]),
    .en({LEN{opcode[5]}}),
    .index(index),
    .vec_out(vec_out_w),
    .status()
  );

  multifunc_unit #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
  ) sfu_inst (
    .data_in(data_n[index]),
    .func(opcode[4:0]),
    .rnd(3'b0),
    .en(opcode[6]),
    .data_out(scalar_out_w),
    .status()
  );

  skew_symmetric #(SIG_WIDTH + EXP_WIDTH + 1) ss_inst (.vec_in(data_n[2 : 0]), .matrix_out(vec_skew_out));

endmodule
