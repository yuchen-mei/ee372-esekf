module dot_product_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter VECTOR_LANES    = 16,
    parameter NUM_STAGES      = 3,
    parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic                                    clk,
    input  logic                                    en,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_a,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_b,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_c,
    input  logic [             2:0]                 funct,
    input  logic [             2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out 
);

    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] dp4_mat_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] dp4_dot_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] dp4_qmul_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] dp4_rot_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] inst_dp4;
    logic [VECTOR_LANES-1:0][7:0]                 status_inst;

    logic [EXP_WIDTH + SIG_WIDTH:0] one;
    logic [EXP_WIDTH - 1:0] one_exp;
    logic [SIG_WIDTH - 1:0] one_sig;

    // integer number 1 with the FP number format
    assign one_exp = ((1 << (EXP_WIDTH-1)) - 1);
    assign one_sig = 0;
    assign one = {1'b0, one_exp, one_sig}; // fp(1)

    // 3x3x3 matrix multiply-accumulate
    for (genvar i = 0; i < 3; i = i + 1) begin: mat_col
        for (genvar j = 0; j < 3; j = j + 1) begin: mat_row
            assign dp4_mat_in[3*i+j][0] = vec_a[j];
            assign dp4_mat_in[3*i+j][1] = vec_b[3*i];
            assign dp4_mat_in[3*i+j][2] = vec_a[3+j];
            assign dp4_mat_in[3*i+j][3] = vec_b[3*i+1];
            assign dp4_mat_in[3*i+j][4] = vec_a[6+j];
            assign dp4_mat_in[3*i+j][5] = vec_b[3*i+2];
            assign dp4_mat_in[3*i+j][6] = vec_c[3*i+j];
            assign dp4_mat_in[3*i+j][7] = one;
        end
    end

    // 4-way dot product
    for (genvar i = 0; i < VECTOR_LANES / 4; i = i + 1) begin: dot_product
        assign dp4_dot_in[4*i][0] = vec_a[4*i];
        assign dp4_dot_in[4*i][1] = vec_b[4*i];
        assign dp4_dot_in[4*i][2] = vec_a[4*i+1];
        assign dp4_dot_in[4*i][3] = vec_b[4*i+1];
        assign dp4_dot_in[4*i][4] = vec_a[4*i+2];
        assign dp4_dot_in[4*i][5] = vec_b[4*i+2];
        assign dp4_dot_in[4*i][6] = vec_a[4*i+3];
        assign dp4_dot_in[4*i][7] = vec_b[4*i+3];
    end

    // Quaternion multiplication
    logic [DATA_WIDTH-1:0] a_neg[VECTOR_LANES-1:0];
    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        assign a_neg[i] = {~vec_a[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
    end

    assign dp4_qmul_in[0] = {vec_a[0], vec_b[0], a_neg[1], vec_b[1], a_neg[2], vec_b[2], a_neg[3], vec_b[3]};
    assign dp4_qmul_in[1] = {vec_a[0], vec_b[1], vec_a[1], vec_b[0], vec_a[2], vec_b[3], a_neg[3], vec_b[2]};
    assign dp4_qmul_in[2] = {vec_a[0], vec_b[2], a_neg[1], vec_b[3], vec_a[2], vec_b[0], vec_a[3], vec_b[3]};
    assign dp4_qmul_in[3] = {vec_a[0], vec_b[3], vec_a[1], vec_b[2], a_neg[2], vec_b[1], vec_a[3], vec_b[0]};

    // Rotation matrix
    assign dp4_rot_in[0] = {vec_a[1], vec_a[1], vec_a[2], a_neg[2], a_neg[3], vec_a[3], vec_a[0], vec_a[0]};
    assign dp4_rot_in[1] = {vec_a[2], vec_a[1], vec_a[1], vec_a[2], vec_a[0], vec_a[3], vec_a[3], vec_a[0]};
    assign dp4_rot_in[2] = {vec_a[3], vec_a[1], vec_a[0], a_neg[2], vec_a[1], vec_a[3], a_neg[2], vec_a[0]};
    assign dp4_rot_in[3] = {vec_a[1], vec_a[2], vec_a[2], vec_a[1], a_neg[3], vec_a[0], vec_a[0], a_neg[3]};
    assign dp4_rot_in[4] = {vec_a[2], vec_a[2], a_neg[1], vec_a[1], vec_a[0], vec_a[0], vec_a[3], a_neg[3]};
    assign dp4_rot_in[5] = {vec_a[3], vec_a[2], vec_a[0], vec_a[1], vec_a[1], vec_a[0], vec_a[2], vec_a[3]};
    assign dp4_rot_in[6] = {vec_a[1], vec_a[3], vec_a[2], vec_a[0], vec_a[3], vec_a[1], vec_a[0], vec_a[2]};
    assign dp4_rot_in[7] = {vec_a[2], vec_a[3], a_neg[1], vec_a[0], vec_a[0], a_neg[1], vec_a[3], vec_a[2]};
    assign dp4_rot_in[8] = {vec_a[3], vec_a[3], vec_a[0], vec_a[0], vec_a[1], a_neg[1], a_neg[2], vec_a[2]};

    if (VECTOR_LANES > 4) begin
        assign dp4_qmul_in[VECTOR_LANES-1:4] = '0;
        assign dp4_dot_in[3:1] = '0;
        assign dp4_dot_in[8:5] = '0;
    end

    if (VECTOR_LANES > 9) begin
        assign dp4_mat_in[VECTOR_LANES-1:9] = '0;
        assign dp4_rot_in[VECTOR_LANES-1:9] = '0;
    end

    always_comb begin
        case (funct)
            3'b000:  inst_dp4 = dp4_mat_in;
            3'b001:  inst_dp4 = dp4_dot_in;
            3'b010:  inst_dp4 = dp4_qmul_in;
            3'b011:  inst_dp4 = dp4_rot_in;
            default: inst_dp4 = '0;
        endcase
    end

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        DW_fp_dp4_inst_pipe #(
            .SIG_WIDTH      (SIG_WIDTH      ),
            .EXP_WIDTH      (EXP_WIDTH      ),
            .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
            .ARCH_TYPE      (1              ),
            .NUM_STAGES     (NUM_STAGES     )
        ) DW_lp_fp_dp4_inst (
            .inst_clk       (clk            ),
            .inst_a         (inst_dp4[i][0] ),
            .inst_b         (inst_dp4[i][1] ),
            .inst_c         (inst_dp4[i][2] ),
            .inst_d         (inst_dp4[i][3] ),
            .inst_e         (inst_dp4[i][4] ),
            .inst_f         (inst_dp4[i][5] ),
            .inst_g         (inst_dp4[i][6] ),
            .inst_h         (inst_dp4[i][7] ),
            .inst_rnd       (rnd            ),
            .z_inst         (vec_out[i]     ),
            .status_inst    (status_inst[i] )
        );
    end

endmodule
