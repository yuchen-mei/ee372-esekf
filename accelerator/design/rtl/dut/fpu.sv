module fpu #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 16
) (
  input en,
  input [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] data_a,
  input [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] data_b,
  input [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] data_c,
  input [4 : 0] opcode,
  input [LEN - 1 : 0] predicate,
  output reg [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] data_out
);

  localparam width = SIG_WIDTH + EXP_WIDTH + 1;

  logic dp_en, vec_en, sfu_en;
  logic [2 : 0] vec_func;
  logic [3 : 0] dp_func;
  logic [4 : 0] sfu_func;

  logic op2_neg, op3_neg;
  logic [width - 1 : 0] op1_w [LEN - 1 : 0];
  logic [width - 1 : 0] op2_w [LEN - 1 : 0];
  logic [width - 1 : 0] op3_w [LEN - 1 : 0];

  logic [width - 1 : 0] vec_out    [LEN - 1 : 0];
  logic [width - 1 : 0] vec_dp_out [LEN - 1 : 0];
  logic [width - 1 : 0] vec_scalar [LEN - 1 : 0];
  logic [width - 1 : 0] data_out_w [LEN - 1 : 0];

  assign vec_en = en & (opcode == 2'b00);
  assign dp_en  = en & (opcode == 2'b01);
  assign sfu_en = en & (opcode == 2'b10);

  // Wire outputs

  for (genvar i = 1; i < LEN; i = i + 1)
    assign vec_scalar[i] = op1_w[i];

  always_comb begin
    casez (opcode[4:3])
      2'b00:   data_out_w = vec_out;
      2'b01:   data_out_w = vec_dp_out;
      2'b10:   data_out_w = vec_scalar;
      default: data_out_w = '{default:0}; // permute operations
    endcase
  end

  assign data_out = { << { data_out_w }};

  // Unpack and optionally negate operands 

  assign op2_neg = ((opcode[4:2] == 3'b001) || (opcode[4:2] == 3'b010)) && opcode[1];
  assign op3_neg = (opcode == 5'b1) || ((opcode[4:2] == 3'b001) || (opcode[4:2] == 3'b010)) && (opcode[1] ^ opcode[0]);

  for (genvar i = 0; i < LEN; i = i + 1) begin: negate_and_unpack_inputs
    assign op1_w[i] = data_a[i*width +: width];
    assign op2_w[i] = {op2_neg ^ data_b[(i + 1) * width - 1], data_b[i*width  +: width - 1]};
    assign op3_w[i] = {op3_neg ^ data_c[(i + 1) * width - 1], data_c[i*width  +: width - 1]};
  end

  // Decode opcodes

  always_comb begin
    casez (opcode[2:0])
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
    .vec_out(vec_out),
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
    .data_in(data_a[width - 1 : 0]),
    .func(sfu_func),
    .rnd(3'b0),
    .en(sfu_en),
    .data_out(vec_scalar[0]),
    .status()
  );

endmodule
