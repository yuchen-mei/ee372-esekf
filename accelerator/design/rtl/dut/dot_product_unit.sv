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

    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] vec_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] vec_mat3_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] vec_dot4_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] vec_qmul_in;
    logic [VECTOR_LANES-1:0][7:0][DATA_WIDTH-1:0] vec_rot_in;

    logic [VECTOR_LANES-1:0][           7:0] status_inst;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] z_inst;

    // 3x3x3 Matrix multiply-accumulate
    for (genvar i = 0; i < 3; i = i + 1) begin: col_3x3
        for (genvar j = 0; j < 3; j = j + 1) begin: row_3x3
            assign vec_mat3_in[3*i+j][0] = vec_a[j];
            assign vec_mat3_in[3*i+j][2] = vec_a[3+j];
            assign vec_mat3_in[3*i+j][4] = vec_a[6+j];
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
    logic [DATA_WIDTH-1:0] a[3:0];
    logic [DATA_WIDTH-1:0] b[3:0];
    logic [DATA_WIDTH-1:0] a_neg[3:0];

    for (genvar i = 0; i < 4; i = i + 1) begin
        assign a[i] = vec_a[i];
        assign b[i] = vec_b[i];
        assign a_neg[i] = {~a[i][DATA_WIDTH-1], a[i][DATA_WIDTH-2:0]};
    end

    assign vec_qmul_in[0] = {a[0],     b[0],     a_neg[1], b[1],     a_neg[2], b[2],     a_neg[3], b[3]};
    assign vec_qmul_in[1] = {a[0],     b[1],     a[1],     b[0],     a[2],     b[3],     a_neg[3], b[2]};
    assign vec_qmul_in[2] = {a[0],     b[2],     a_neg[1], b[3],     a[2],     b[0],     a[3],     b[3]};
    assign vec_qmul_in[3] = {a[0],     b[3],     a[1],     b[2],     a_neg[2], b[1],     a[3],     b[0]};

    // Rotation matrix
    assign vec_rot_in[0] = {a[1],     a[1],     a[2],     a_neg[2], a_neg[3], a[3],     a[0],     a[0]    };
    assign vec_rot_in[1] = {a[2],     a[1],     a[1],     a[2],     a[0],     a[3],     a[3],     a[0]    };
    assign vec_rot_in[2] = {a[3],     a[1],     a[0],     a_neg[2], a[1],     a[3],     a_neg[2], a[0]    };
    assign vec_rot_in[3] = {a[1],     a[2],     a[2],     a[1],     a_neg[3], a[0],     a[0],     a_neg[3]};
    assign vec_rot_in[4] = {a[2],     a[2],     a_neg[1], a[1],     a[0],     a[0],     a[3],     a_neg[3]};
    assign vec_rot_in[5] = {a[3],     a[2],     a[0],     a[1],     a[1],     a[0],     a[2],     a[3]    };
    assign vec_rot_in[6] = {a[1],     a[3],     a[2],     a[0],     a[3],     a[1],     a[0],     a[2]    };
    assign vec_rot_in[7] = {a[2],     a[3],     a_neg[1], a[0],     a[0],     a_neg[1], a[3],     a[2]    };
    assign vec_rot_in[8] = {a[3],     a[3],     a[0],     a[0],     a[1],     a_neg[1], a_neg[2], a[2]    };

    if (VECTOR_LANES > 4) begin
        assign vec_qmul_in[VECTOR_LANES-1:4] = '0;
    end

    if (VECTOR_LANES > 9) begin
        assign vec_mat3_in[VECTOR_LANES-1:9] = '0;
        assign vec_rot_in[VECTOR_LANES-1:9] = '0;
    end

    always_comb begin
        case (funct)
            3'b000: vec_in = vec_mat3_in;
            3'b001: vec_in = vec_dot4_in;
            3'b010: vec_in = vec_qmul_in;
            3'b011: vec_in = vec_rot_in;
            default: vec_in = '0;
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
            .z              (z_inst[i]      ),
            .status         (status_inst[i] )
        );
    end

    assign vec_out = z_inst;

    // always @(posedge clk) begin
    //     z_inst_pipe1 <= z_inst;
    //     z_inst_pipe2 <= z_inst_pipe1;
    //     z_inst_pipe3 <= z_inst_pipe2;
    //     z_inst_pipe4 <= z_inst_pipe3;
    // end

    // assign vec_out = (NUM_STAGES == 4) ? z_inst_pipe4 :
    //                  (NUM_STAGES == 3) ? z_inst_pipe3 :
    //                  (NUM_STAGES == 2) ? z_inst_pipe2 : z_inst_pipe1;

endmodule
