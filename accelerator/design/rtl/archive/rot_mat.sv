module rot_mat #(
    parameter SIG_WIDTH = 23,
    parameter EXP_WIDTH = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter DATA_WIDTH = 32
)
(
    input logic clk, rst_n,
    input logic [DATA_WIDTH - 1 : 0] x, y, z, w,
    output logic [DATA_WIDTH - 1 : 0] matrix_out [2 : 0][2 : 0]
);

    logic [DATA_WIDTH - 1 : 0] matrix_out_r_w [2 : 0][2 : 0];
    logic [DATA_WIDTH - 1 : 0] matrix_out_r [2 : 0][2 : 0];
    logic [DATA_WIDTH - 1 : 0] r00, r01, r02, r10, r11, r12, r20, r21, r22;

    assign matrix_out_r[0][1] = {r01[DATA_WIDTH - 1], r01[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r01[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r[0][2] = {r02[DATA_WIDTH - 1], r02[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r02[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r[1][0] = {r10[DATA_WIDTH - 1], r10[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r10[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r[1][2] = {r12[DATA_WIDTH - 1], r12[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r12[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r[2][0] = {r20[DATA_WIDTH - 1], r20[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r20[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r[2][1] = {r21[DATA_WIDTH - 1], r21[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r21[DATA_WIDTH - 10 : 0]};

    assign matrix_out_r_w[0][0] = {r00[DATA_WIDTH - 1], r00[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r00[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r_w[1][1] = {r11[DATA_WIDTH - 1], r11[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r11[DATA_WIDTH - 10 : 0]};
    assign matrix_out_r_w[2][2] = {r22[DATA_WIDTH - 1], r22[DATA_WIDTH - 2 : DATA_WIDTH - 9] + 1'h1, r22[DATA_WIDTH - 10 : 0]};

    // z = a * b + c * d
    DW_fp_dp2 #(
        .sig_width(SIG_WIDTH),
        .exp_width(EXP_WIDTH),
        .ieee_compliance(IEEE_COMPLIANCE)
    )
    fp_dp2_U00 (
        .a(w), 
        .b(w), 
        .c(x), 
        .d(x), 
        .rnd(3'h0), 
        .z(r00), 
        .status()
    ),
    fp_dp2_U01 (
        .a(x), 
        .b(y), 
        .c({~w[DATA_WIDTH - 1], w[DATA_WIDTH - 2 : 0]}), 
        .d(z), 
        .rnd(3'h0), 
        .z(r01), 
        .status()
    ),
    fp_dp2_U02 (
        .a(x), 
        .b(z), 
        .c(w), 
        .d(y), 
        .rnd(3'h0), 
        .z(r02), 
        .status()
    ),
    fp_dp2_U10 (
        .a(x), 
        .b(y), 
        .c(w), 
        .d(z), 
        .rnd(3'h0), 
        .z(r10), 
        .status()
    ),
    fp_dp2_U11 (
        .a(w), 
        .b(w), 
        .c(y), 
        .d(y), 
        .rnd(3'h0), 
        .z(r11), 
        .status()
    ),
    fp_dp2_U12 (
        .a(y), 
        .b(z), 
        .c({~w[DATA_WIDTH - 1], w[DATA_WIDTH - 2 : 0]}), 
        .d(x), 
        .rnd(3'h0), 
        .z(r12), 
        .status()
    ),
    fp_dp2_U20 (
        .a(x), 
        .b(z), 
        .c({~w[DATA_WIDTH - 1], w[DATA_WIDTH - 2 : 0]}), 
        .d(y), 
        .rnd(3'h0), 
        .z(r20), 
        .status()
    ),
    fp_dp2_U21 (
        .a(y), 
        .b(z), 
        .c(w), 
        .d(x), 
        .rnd(3'h0), 
        .z(r21), 
        .status()
    ),
    fp_dp2_U22 (
        .a(w), 
        .b(w), 
        .c(z), 
        .d(z), 
        .rnd(3'h0), 
        .z(r22), 
        .status()
    );

    // z = a - b
    DW_fp_sub_DG #(
        .sig_width(SIG_WIDTH),
        .exp_width(EXP_WIDTH),
        .ieee_compliance(IEEE_COMPLIANCE)
    )
    fp_sub_U00 ( 
        .a(matrix_out_r_w[0][0]), 
        .b(32'h3F800000), 
        .rnd(3'h0),
        .DG_ctrl(en),
        .z(matrix_out_r[0][0]), 
        .status() 
    ),
    fp_sub_U11 ( 
        .a(matrix_out_r_w[1][1]), 
        .b(32'h3F800000), 
        .rnd(3'h0),
        .DG_ctrl(en),
        .z(matrix_out_r[1][1]), 
        .status() 
    ),
    fp_sub_U22 ( 
        .a(matrix_out_r_w[2][2]), 
        .b(32'h3F800000), 
        .rnd(3'h0),
        .DG_ctrl(en),
        .z(matrix_out_r[2][2]), 
        .status() 
    );

    // always_ff @(posedge clk) begin
    //     if(~rst_n) begin
    //         matrix_out <= '{default:'0};
    //     end
    //     else begin
    //        matrix_out <= matrix_out_r; 
    //     end
    // end
endmodule
