module vector_unit #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 9
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_c [LEN - 1 : 0],
  input [2 : 0] rnd,
  input [2 : 0] op,
  input [3 : 0] index,
  input [LEN - 1 : 0] en,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [LEN - 1 : 0],
  output [7 : 0] status [LEN - 1 : 0]
);

  logic indexed, vec_mul, vec_add;
  logic [SIG_WIDTH + EXP_WIDTH : 0] op1_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] op2_w [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] op3_w [LEN - 1 : 0];

  assign indexed = op[0];
  assign vec_mul = op[1];
  assign vec_add = op[2];

  for (genvar i = 0; i < LEN; i = i + 1) begin
    assign op1_w[i] = vec_a[i];
    assign op2_w[i] = vec_add ? 32'h3f800000 :
                      indexed ? vec_b[index] : vec_b[i];
    assign op3_w[i] = vec_mul ? 32'b0 : vec_c[i];

    DW_fp_mac_DG #(
      .sig_width(SIG_WIDTH),
      .exp_width(EXP_WIDTH),
      .ieee_compliance(IEEE_COMPLIANCE)
    ) DW_fp_mac_inst (
      .a(op1_w[i]),
      .b(op2_w[i]),
      .c(op3_w[i]),
      .rnd(rnd),
      .DG_ctrl(en[i]),
      .z(vec_out[i]),
      .status(status[i])
    );
  end

endmodule
