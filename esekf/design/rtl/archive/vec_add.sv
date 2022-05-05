module vec_add #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 4
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [LEN - 1 : 0],
  input [2 : 0] rnd,
  input op,
  input [LEN - 1 : 0] en,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [LEN - 1 : 0],
  output [7 : 0] status [LEN - 1 : 0]
);

  for (genvar i = 0; i < LEN; i = i + 1) begin
    DW_fp_addsub_DG #(
      .sig_width(SIG_WIDTH),
      .exp_width(EXP_WIDTH),
      .ieee_compliance(IEEE_COMPLIANCE)
    ) DW_fp_addsub_DG_inst (
      .a(vec_a[i]),
      .b(vec_b[i]),
      .rnd(rnd),
      .op(op),
      .DG_ctrl(en[i]),
      .z(vec_out[i]),
      .status(status[i])
    );
  end

endmodule
