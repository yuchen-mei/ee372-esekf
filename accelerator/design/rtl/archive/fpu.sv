module fpu #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter MATRIX_HEIGHT = 3,
  parameter MATRIX_WIDTH = 3,
  parameter VECTOR_LANES = 9
) (
  input en,
  input [7 : 0] opcode,
  input [SIG_WIDTH + EXP_WIDTH : 0] data_n [VECTOR_LANES - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] data_m [VECTOR_LANES - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] data_a [VECTOR_LANES - 1 : 0],
  input [3 : 0] index,
  input [VECTOR_LANES - 1 : 0] predicate,
  output [SIG_WIDTH + EXP_WIDTH : 0] data_out [VECTOR_LANES - 1 : 0]
);

  logic [SIG_WIDTH + EXP_WIDTH : 0] mmul_out_w [MATRIX_WIDTH * MATRIX_HEIGHT - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vmul_out_w [VECTOR_LANES - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_mul_w [VECTOR_LANES - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] vadd_op2_w [VECTOR_LANES - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vadd_out_w [VECTOR_LANES - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] data_out_w [VECTOR_LANES - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_neg_w [VECTOR_LANES - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] quat_out_w [3 : 0];

  assign data_mul_w = opcode[5] ? vmul_out_w : mmul_out_w;
  assign vadd_op2_w = opcode[0] ? data_m     : data_mul_w;
  assign data_out_w = opcode[1] ? data_mul_w : vadd_out_w;
  // assign data_out = opcode[6] ? {{5{32'b0}}, quat_out_w} : data_out_w;
  // assign data_out[3 : 0] = opcode[6] ? quat_out_w : data_neg_w[3 : 0];
  // assign data_out[8 : 4] = opcode[6] ? '{5{32'b0}} : data_neg_w[8 : 4];
  assign data_out = data_neg_w;

  matmul #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
  ) matmul_inst (
    .en(~opcode[5]),
    .matrix_a(data_n),
    .matrix_b(data_m),
    .rnd(3'b0),
    .matrix_out(mmul_out_w)
  );

  vec_mul #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .VECTOR_LANES(VECTOR_LANES)
  ) vector_mul_inst (
    .en({VECTOR_LANES{opcode[5]}}), // TODO: use predicate register
    .vec_a(data_n),
    .vec_b(data_m),
    .indexed(opcode[2]),
    .index(index),
    .rnd(3'b0),
    .vec_out(vmul_out_w)
  );

  vec_add #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .VECTOR_LANES(VECTOR_LANES)
  ) vector_add_inst (
    .en({VECTOR_LANES{~opcode[1]}}), // TODO: add predicate
    .vec_a(data_a),
    .vec_b(vadd_op2_w),
    .rnd(3'b0),
    .op(opcode[4]),
    .vec_out(vadd_out_w)
  );

  negate #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .VECTOR_LANES(VECTOR_LANES)
  ) negate_inst (
    .en(opcode[3]),
    .vec_in(data_out_w),
    .vec_out(data_neg_w)
  );

  quat_mult #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
  ) quat_mult_inst (
    .en(opcode[2]),
    .quat_a(data_n[3 : 0]),
    .quat_b(data_m[3 : 0]),
    .rnd(3'b0),
    .quat_out(quat_out_w)
  );

endmodule
