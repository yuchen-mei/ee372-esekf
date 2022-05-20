module vector_unit #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 16
)(
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_a [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_b [LEN - 1 : 0],
  input [SIG_WIDTH + EXP_WIDTH : 0] vec_c [LEN - 1 : 0],
  input [2 : 0] func,
  input [2 : 0] rnd,
  input [LEN - 1 : 0] en,
  output [SIG_WIDTH + EXP_WIDTH : 0] vec_out [LEN - 1 : 0],
  output [7 : 0] status [LEN - 1 : 0]
);

  for (genvar i = 0; i < LEN; i = i + 1) begin
    logic [SIG_WIDTH + EXP_WIDTH : 0] inst_b;
    logic [SIG_WIDTH + EXP_WIDTH : 0] inst_c;

    assign inst_b = func[0] ? 32'h3f800000 : vec_b[i];

    // FIXME: Case statement marked unique does not cover all possible conditions
    always_comb begin
      unique case (1'b1)
        func[0]: inst_c = vec_b[i];
        func[1]: inst_c = 32'b0;
        func[2]: inst_c = vec_c[i];
      endcase
    end

    DW_fp_mac_DG #(
      .sig_width(SIG_WIDTH),
      .exp_width(EXP_WIDTH),
      .ieee_compliance(IEEE_COMPLIANCE)
    ) DW_fp_mac_inst (
      .a(vec_a[i]),
      .b(inst_b),
      .c(inst_c),
      .rnd(rnd),
      .DG_ctrl(en[i]),
      .z(vec_out[i]),
      .status(status[i])
    );
  end

endmodule
