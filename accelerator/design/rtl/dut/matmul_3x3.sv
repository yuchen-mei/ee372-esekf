module matmul_3x3 #( 
    parameter SIG_WIDTH = 23,
    parameter EXP_WIDTH = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter ARRAY_HEIGHT = 3,
    parameter ARRAY_WIDTH = 3
)(
    input logic clk,
    input logic rst_n,
    input logic en,
    input logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_a [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0],
    input logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_b [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0],
    output logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_out [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0]
);

    logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_out_w [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];
    logic [SIG_WIDTH + EXP_WIDTH : 0] matrix_out_r [ARRAY_HEIGHT - 1 : 0][ARRAY_WIDTH - 1 : 0];

    genvar i, j;

    for (i = 0; i < ARRAY_HEIGHT; i = i + 1) begin: row
        for (j = 0; j < ARRAY_WIDTH; j = j + 1) begin: col
            DW_fp_dp3 #(
                .sig_width(SIG_WIDTH), 
                .exp_width(EXP_WIDTH), 
                .ieee_compliance(IEEE_COMPLIANCE)
            ) 
            U1 (
                .a(matrix_a[i][0]),
                .b(matrix_b[0][j]),
                .c(matrix_a[i][1]),
                .d(matrix_b[1][j]),
                .e(matrix_a[i][2]),
                .f(matrix_b[2][j]),
                .rnd(3'b0),
                .z(matrix_out_w[i][j]),
                .status()
            );
        //   assign matrix_out[3 * i + j] = matrix_z_w[i][j];
        end
    end

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            matrix_out_r <= '{default:'0};
        end
        else if (en) begin
            matrix_out_r <= matrix_out_w;
        end
    end
    assign matrix_out = matrix_out_r;
endmodule

