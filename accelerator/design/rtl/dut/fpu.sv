module fpu #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 16
) (
  input en,
  input [SIG_WIDTH + EXP_WIDTH : 0] data_a [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] data_b [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] data_c [LEN - 1 : 0],
  input [4 : 0] opcode,
  input [3 : 0] index,
  input [LEN - 1 : 0] predicate,
  output logic [SIG_WIDTH + EXP_WIDTH : 0] data_out [LEN - 1 : 0]
);

  logic dp_en, vec_en, sfu_en;
  logic [2 : 0] vec_func;
  logic [3 : 0] dp_func;
  logic [4 : 0] sfu_func;

  logic scalar, op2_neg, op3_neg;
  logic [SIG_WIDTH + EXP_WIDTH : 0] op1_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] op2_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] op3_w [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] scalar_out;
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_unit_out [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_dp_out   [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vec_sfu_out  [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] data_out_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] skew_symmetric [LEN - 1 : 0];

  assign vec_en = en & ~opcode[4];
  assign dp_en = en & opcode[4] & ~opcode[3];
  assign sfu_en = en & opcode[4] & opcode[3];

  for (genvar i = 0; i < LEN; i = i + 1) begin
    assign vec_sfu_out[i] = (i == index) ? scalar_out : data_a[i];
  end

  always_comb begin
    casez (opcode[4:3])
      2'b0?:   data_out_w = vec_unit_out;
      2'b10:   data_out_w = vec_dp_out;
      2'b11:   data_out_w = vec_sfu_out;
      default: data_out_w = '{default:'0};
    endcase

    case (opcode)
      5'b00110: data_out = data_a;
      5'b00111: data_out = skew_symmetric;
      default:  data_out = data_out_w;
    endcase
  end

  // Collecting operands 

  // FIXME: Move this into vector unit?
  assign scalar = ~opcode[4] & opcode[0];

  always_comb begin
    casez (opcode)
      5'b0001?: {op2_neg, op3_neg} = 2'b01;
      5'b01???: {op2_neg, op3_neg} = {opcode[2], opcode[2] ^ opcode[1]};
      5'b100??: {op2_neg, op3_neg} = {opcode[1], opcode[1] ^ opcode[0]};
      default:  {op2_neg, op3_neg} = 2'b00;
    endcase
  end

  for (genvar i = 0; i < LEN; i = i + 1) begin: vector_inputs
    assign op1_w[i] = scalar ? data_a[index] : data_a[i];

    assign op2_w[i][SIG_WIDTH + EXP_WIDTH] = op2_neg ^ data_b[i][SIG_WIDTH + EXP_WIDTH];
    assign op2_w[i][SIG_WIDTH + EXP_WIDTH - 1 : 0] = data_b[i][SIG_WIDTH + EXP_WIDTH - 1 : 0];

    assign op3_w[i][SIG_WIDTH + EXP_WIDTH] = op3_neg ^ data_c[i][SIG_WIDTH + EXP_WIDTH];
    assign op3_w[i][SIG_WIDTH + EXP_WIDTH - 1 : 0] = data_c[i][SIG_WIDTH + EXP_WIDTH - 1 : 0];
  end

  // Opcodes

  always_comb begin
    casez (opcode[3:1])
      3'b00?:  vec_func = 3'b001; // Add/Subtract
      3'b010:  vec_func = 3'b010; // Multiply
      3'b1??:  vec_func = 3'b100; // Fused Multiply-Add
      default: vec_func = 3'b100;
    endcase

    casez (opcode[2:0])
      3'b0??:  dp_func = 4'b0001; // Matrix Multiply-Add
      3'b100:  dp_func = 4'b0010; // Dot Product
      3'b101:  dp_func = 4'b0100; // Quaternion Multiplication
      3'b110:  dp_func = 4'b1000; // Rotation Matrix
      default: dp_func = 4'b0001;
    endcase

    case (opcode[2:0])
      3'b000:  sfu_func = 5'b00001; // reciprocal, 1/A
      3'b001:  sfu_func = 5'b00010; // square root of A
      3'b010:  sfu_func = 5'b00100; // reciprocal square root of A
      3'b011:  sfu_func = 5'b01000; // sine, sin(A)
      3'b100:  sfu_func = 5'b10000; // cosine, cos(A)
      default: sfu_func = 5'b00001;
    endcase
  end

  skew_symmetric #(SIG_WIDTH + EXP_WIDTH + 1) skew_symmetrix_inst (.vec_in(data_a[2:0]), .matrix_out(skew_symmetric[8:0]));

  if (LEN > 9)
    assign skew_symmetric[LEN - 1 : 9] = '{default:'0};

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
    .func(vec_func),
    .en({LEN{vec_en}}),
    .vec_out(vec_unit_out),
    .status()
  );

  dot_product_unit #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .LEN(LEN)
  ) dp_unit_inst (
    .vec_a(op1_w),
    .vec_b(op2_w),
    .vec_c(op3_w),
    .func(dp_func),
    .rnd(3'b0),
    .en(dp_en),
    .vec_out(vec_dp_out),
    .status()
  );

  multifunc_unit #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
  ) mfu_inst (
    .data_in(data_a[index]),
    .func(sfu_func),
    .rnd(3'b0),
    .en(sfu_en),
    .data_out(scalar_out),
    .status()
  );

endmodule
