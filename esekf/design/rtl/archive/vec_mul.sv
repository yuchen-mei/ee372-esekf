module vec_mul #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 9
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [LEN - 1 : 0],
  input [2 : 0] rnd,
  input op,
  input [3 : 0] index,
  input [LEN - 1 : 0] en,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [LEN - 1 : 0],
  output [7 : 0] status [LEN - 1 : 0]
);

  for (genvar i = 0; i < LEN; i = i + 1) begin
    DW_fp_mult_DG #(
      .sig_width(SIG_WIDTH),
      .exp_width(EXP_WIDTH),
      .ieee_compliance(IEEE_COMPLIANCE)
    ) U1 (
      .a(vec_a[i]),
      .b(op ? vec_b[index] : vec_b[i]),
      .rnd(rnd),
      .DG_ctrl(en[i]),
      .z(vec_out[i]),
      .status(status[i])
    );
  end

endmodule
