module dot_product_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter VECTOR_LANES    = 16,
    parameter NUM_STAGES      = 2,
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
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] dp4_in;

    logic [VECTOR_LANES-1:0][           7:0] status_inst;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] z_inst;

    // 3x3x3 matrix multiply-accumulate
    for (genvar i = 0; i < 3; i = i + 1) begin: col
        for (genvar j = 0; j < 3; j = j + 1) begin: row
            assign dp4_mat_in[3*i+j][0] = vec_a[j];
            assign dp4_mat_in[3*i+j][1] = vec_b[3*i];
            assign dp4_mat_in[3*i+j][2] = vec_a[3+j];
            assign dp4_mat_in[3*i+j][3] = vec_b[3*i+1];
            assign dp4_mat_in[3*i+j][4] = vec_a[6+j];
            assign dp4_mat_in[3*i+j][5] = vec_b[3*i+2];
            assign dp4_mat_in[3*i+j][6] = vec_c[3*i+j];
            assign dp4_mat_in[3*i+j][7] = 32'h3f800000;
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
    end

    if (VECTOR_LANES > 9) begin
        assign dp4_mat_in[VECTOR_LANES-1:9] = '0;
        assign dp4_rot_in[VECTOR_LANES-1:9] = '0;
    end

    always_comb begin
        case (funct)
            3'b000:  dp4_in = dp4_mat_in;
            3'b001:  dp4_in = dp4_dot_in;
            3'b010:  dp4_in = dp4_qmul_in;
            3'b011:  dp4_in = dp4_rot_in;
            default: dp4_in = '0;
        endcase
    end

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        DW_fp_dp4 #(
            .sig_width      (SIG_WIDTH      ),
            .exp_width      (EXP_WIDTH      ),
            .ieee_compliance(IEEE_COMPLIANCE),
            .arch_type      (1              )
        ) DW_fp_dp4_inst (
            .a              (dp4_in[i][0]   ),
            .b              (dp4_in[i][1]   ),
            .c              (dp4_in[i][2]   ),
            .d              (dp4_in[i][3]   ),
            .e              (dp4_in[i][4]   ),
            .f              (dp4_in[i][5]   ),
            .g              (dp4_in[i][6]   ),
            .h              (dp4_in[i][7]   ),
            .rnd            (rnd            ),
            .z              (z_inst[i]      ),
            .status         (status_inst[i] )
        );
    end

    // assign vec_out = z_inst;

    always @(posedge clk) begin
        z_inst_pipe1 <= z_inst;
        z_inst_pipe2 <= z_inst_pipe1;
        z_inst_pipe3 <= z_inst_pipe2;
        z_inst_pipe4 <= z_inst_pipe3;
    end

    assign vec_out = (NUM_STAGES == 4) ? z_inst_pipe4 :
                     (NUM_STAGES == 3) ? z_inst_pipe3 :
                     (NUM_STAGES == 2) ? z_inst_pipe2 : z_inst_pipe1;

endmodule
