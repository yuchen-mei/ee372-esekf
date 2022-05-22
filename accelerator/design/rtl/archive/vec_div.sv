module vec_div #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter VECTOR_LANES = 4,
  parameter INDEX_WIDTH = 2
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [VECTOR_LANES - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [VECTOR_LANES - 1 : 0],
  input [2 : 0] rnd,
  input op,
  input [INDEX_WIDTH - 1 : 0] index,
  input [VECTOR_LANES - 1 : 0] en,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [VECTOR_LANES - 1 : 0],
  output [7 : 0] status [VECTOR_LANES - 1 : 0]
);

  for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
    DW_fp_div_DG #(
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
