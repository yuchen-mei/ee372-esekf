module dp_unit #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 9
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_c [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_d [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_e [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_f [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_g [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_h [LEN - 1 : 0],
  input [2 : 0] rnd,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [LEN - 1 : 0],
  output [7 : 0] status [LEN - 1 : 0]
);

  for (genvar i = 0; i < LEN; i = i + 1) begin
    DW_fp_dp4 #(
      .sig_width(SIG_WIDTH),
      .exp_width(EXP_WIDTH),
      .ieee_compliance(IEEE_COMPLIANCE)
      // .arch_type(1'b1)
    ) DW_fp_dp4_inst (
      .a(vec_a[i]),
      .b(vec_b[i]),
      .c(vec_c[i]),
      .d(vec_d[i]),
      .e(vec_e[i]),
      .f(vec_f[i]),
      .g(vec_g[i]),
      .h(vec_h[i]),
      .rnd(rnd),
      .z(vec_out[i]),
      .status(status[i])
    );
  end

endmodule
