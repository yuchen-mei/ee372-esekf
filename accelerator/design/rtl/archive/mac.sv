module mac #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0
)(
  input clk,
  input rst_n,
  input en,
  input [SIG_WIDTH+EXP_WIDTH : 0] data_a,
  input [SIG_WIDTH+EXP_WIDTH : 0] data_b,
  input [2 : 0] rnd,
  output [SIG_WIDTH+EXP_WIDTH : 0] data_out,
  output [7 : 0] status
);

  logic [SIG_WIDTH+EXP_WIDTH : 0] psum_w;
  logic [7 : 0] status_w;

  logic [SIG_WIDTH+EXP_WIDTH : 0] psum_r;
  logic [7 : 0] status_r;

  always @(posedge clk) begin
    if (!rst_n) begin
      psum_r <= 0;
    end
    else if (en) begin
      psum_r <= psum_w;
      status_r <= status_w;
    end
  end

  assign data_out = psum_r;
  assign status = status_r;

  DW_fp_mac_DG #(
    .sig_width(SIG_WIDTH),
    .exp_width(EXP_WIDTH),
    .ieee_compliance(IEEE_COMPLIANCE)
  ) DW_fp_mac_inst (
    .a(data_a),
    .b(data_b),
    .c(psum_r),
    .rnd(rnd),
    .DG_ctrl(en),
    .z(psum_w),
    .status(status_w)
  );

endmodule
