module vector_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter VECTOR_LANES    = 16,
    parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic [  DATA_WIDTH-1:0] vec_a [VECTOR_LANES-1:0],
    input  logic [  DATA_WIDTH-1:0] vec_b [VECTOR_LANES-1:0],
    input  logic [  DATA_WIDTH-1:0] vec_c [VECTOR_LANES-1:0],
    input  logic [             2:0] func,
    input  logic [             2:0] rnd,
    input  logic [VECTOR_LANES-1:0] en,
    output logic [  DATA_WIDTH-1:0] vec_out [VECTOR_LANES-1:0],
    output logic [             7:0] status [VECTOR_LANES-1:0]
);

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        logic [DATA_WIDTH-1:0] inst_b;
        logic [DATA_WIDTH-1:0] inst_c;

        assign inst_b = func[0] ? 32'h3f800000 : vec_b[i];
        assign inst_c = func[0] ? vec_b[i] : (func[2] ? vec_c[i] : 32'b0);

        DW_fp_mac_DG #(
            .sig_width      (SIG_WIDTH      ),
            .exp_width      (EXP_WIDTH      ),
            .ieee_compliance(IEEE_COMPLIANCE)
        ) DW_fp_mac_inst (
            .a      (vec_a[i]  ),
            .b      (inst_b    ),
            .c      (inst_c    ),
            .rnd    (rnd       ),
            .DG_ctrl(en[i]     ),
            .z      (vec_out[i]),
            .status (status[i] )
        );
    end

endmodule
