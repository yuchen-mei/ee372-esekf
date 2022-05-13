module multifunc_unit #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0
)(
  input logic [SIG_WIDTH + EXP_WIDTH : 0] data_in,
  input logic [4 : 0] func,
  input logic [2 : 0] rnd,
  input logic en,
  output logic [SIG_WIDTH + EXP_WIDTH : 0] data_out,
  output logic [7 : 0] status
);

  DW_lp_fp_multifunc_DG #(
    .sig_width(SIG_WIDTH),
    .exp_width(EXP_WIDTH),
    .ieee_compliance(IEEE_COMPLIANCE),
    .func_select(7'b11111),
    .pi_multiple(1'b0)
  ) U1 (
    .a(data_in),
    .func({11'b0, func}),
    .rnd(rnd),
    .DG_ctrl(en),
    .z(data_out),
    .status(status)
  );

endmodule
