module vec_add #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter VECTOR_LANES = 4
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [VECTOR_LANES - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [VECTOR_LANES - 1 : 0],
  input [2 : 0] rnd,
  input op,
  input [VECTOR_LANES - 1 : 0] en,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [VECTOR_LANES - 1 : 0],
  output [7 : 0] status [VECTOR_LANES - 1 : 0]
);

  for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
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
