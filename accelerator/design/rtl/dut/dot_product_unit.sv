module dot_product_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter VECTOR_LANES    = 16,
    parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic                                    en,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_a,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_b,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_c,
    input  logic [             2:0]                 funct,
    input  logic [             2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out 
);

    logic [DATA_WIDTH-1:0] vec_in      [VECTOR_LANES-1:0][7:0];
    logic [DATA_WIDTH-1:0] vec_mat3_in [VECTOR_LANES-1:0][7:0];
    logic [DATA_WIDTH-1:0] vec_dot4_in [VECTOR_LANES-1:0][7:0];
    logic [DATA_WIDTH-1:0] vec_qmul_in [VECTOR_LANES-1:0][7:0];
    logic [DATA_WIDTH-1:0] vec_rot_in  [VECTOR_LANES-1:0][7:0];

    // 3x3x3 Matrix multiply-accumulate
    for (genvar i = 0; i < 3; i = i + 1) begin: col_3x3
        for (genvar j = 0; j < 3; j = j + 1) begin: row_3x3
            assign vec_mat3_in[3*i+j][0] = vec_a[j];
            assign vec_mat3_in[3*i+j][2] = vec_a[3+j];
            assign vec_mat3_in[3*i+j][4] = vec_a[3*2+j];
            assign vec_mat3_in[3*i+j][6] = vec_c[3*i+j];
            assign vec_mat3_in[3*i+j][1] = vec_b[3*i];
            assign vec_mat3_in[3*i+j][3] = vec_b[3*i+1];
            assign vec_mat3_in[3*i+j][5] = vec_b[3*i+2];
            assign vec_mat3_in[3*i+j][7] = 32'h3f800000;
        end
    end

    // Dot product
    for (genvar i = 0; i < VECTOR_LANES / 4; i = i + 1) begin: dot_product
        assign vec_dot4_in[4*i][0] = vec_a[4*i];
        assign vec_dot4_in[4*i][2] = vec_a[4*i+1];
        assign vec_dot4_in[4*i][4] = vec_a[4*i+2];
        assign vec_dot4_in[4*i][6] = vec_a[4*i+3];
        assign vec_dot4_in[4*i][1] = vec_b[4*i];
        assign vec_dot4_in[4*i][3] = vec_b[4*i+1];
        assign vec_dot4_in[4*i][5] = vec_b[4*i+2];
        assign vec_dot4_in[4*i][7] = vec_b[4*i+3];
    end

    // Quaternion multiplication
    logic [DATA_WIDTH-1:0] qa[3:0];
    logic [DATA_WIDTH-1:0] qb[3:0];
    logic [DATA_WIDTH-1:0] qa_n[3:0];

    for (genvar i = 0; i < 4; i = i + 1) begin
        assign qa[i] = vec_a[i];
        assign qb[i] = vec_b[i];
        assign qa_n[i] = {~qa[i][DATA_WIDTH-1], qa[i][DATA_WIDTH-2:0]};
    end

    assign vec_qmul_in[0] = '{qa[0],   qb[0],   qa_n[1], qb[1],   qa_n[2], qb[2],   qa_n[3], qb[3]};
    assign vec_qmul_in[1] = '{qa[0],   qb[1],   qa[1],   qb[0],   qa[2],   qb[3],   qa_n[3], qb[2]};
    assign vec_qmul_in[2] = '{qa[0],   qb[2],   qa_n[1], qb[3],   qa[2],   qb[0],   qa[3],   qb[3]};
    assign vec_qmul_in[3] = '{qa[0],   qb[3],   qa[1],   qb[2],   qa_n[2], qb[1],   qa[3],   qb[0]};

    if (VECTOR_LANES > 4) begin
        for (genvar i = 4; i < VECTOR_LANES; i = i + 1) begin
            assign vec_qmul_in[i] = '{default:'0};
        end
    end

    // Rotation matrix
    assign vec_rot_in[0] = '{qa[1],   qa[1],   qa[2],   qa_n[2], qa_n[3], qa[3],   qa[0],   qa[0]};
    assign vec_rot_in[1] = '{qa[2],   qa[1],   qa[1],   qa[2],   qa[0],   qa[3],   qa[3],   qa[0]};
    assign vec_rot_in[2] = '{qa[3],   qa[1],   qa[0],   qa_n[2], qa[1],   qa[3],   qa_n[2], qa[0]};

    assign vec_rot_in[3] = '{qa[1],   qa[2],   qa[2],   qa[1],   qa_n[3], qa[0],   qa[0],   qa_n[3]};
    assign vec_rot_in[4] = '{qa[2],   qa[2],   qa_n[1], qa[1],   qa[0],   qa[0],   qa[3],   qa_n[3]};
    assign vec_rot_in[5] = '{qa[3],   qa[2],   qa[0],   qa[1],   qa[1],   qa[0],   qa[2],   qa[3]};

    assign vec_rot_in[6] = '{qa[1],   qa[3],   qa[2],   qa[0],   qa[3],   qa[1],   qa[0],   qa[2]};
    assign vec_rot_in[7] = '{qa[2],   qa[3],   qa_n[1], qa[0],   qa[0],   qa_n[1], qa[3],   qa[2]};
    assign vec_rot_in[8] = '{qa[3],   qa[3],   qa[0],   qa[0],   qa[1],   qa_n[1], qa_n[2], qa[2]};

    if (VECTOR_LANES > 9) begin
        for (genvar i = 9; i < VECTOR_LANES; i = i + 1) begin
            assign vec_mat3_in[i] = '{default:'0};
            assign vec_rot_in[i] = '{default:'0};
        end
    end

    always_comb begin
        case (funct)
            3'b000: vec_in = vec_mat3_in;
            3'b001: vec_in = vec_dot4_in;
            3'b010: vec_in = vec_qmul_in;
            3'b011: vec_in = vec_rot_in;
            default: vec_in = '{default:'0};
        endcase
    end

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        DW_fp_dp4 #(
            .sig_width      (SIG_WIDTH      ),
            .exp_width      (EXP_WIDTH      ),
            .ieee_compliance(IEEE_COMPLIANCE),
            .arch_type      (1              )
        ) DW_fp_dp4_inst (
            .a              (vec_in[i][0]   ),
            .b              (vec_in[i][1]   ),
            .c              (vec_in[i][2]   ),
            .d              (vec_in[i][3]   ),
            .e              (vec_in[i][4]   ),
            .f              (vec_in[i][5]   ),
            .g              (vec_in[i][6]   ),
            .h              (vec_in[i][7]   ),
            .rnd            (rnd            ),
            .z              (vec_out[i]     ),
            .status         (               )
        );
    end

endmodule
