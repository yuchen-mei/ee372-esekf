module vector_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter VECTOR_LANES    = 16,
    parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic                                    clk,
    input  logic                                    en,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_a,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_b,
    input  logic [             4:0]                 opcode,
    input  logic [             2:0]                 funct,
    input  logic [             2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    // Vector permutation
    logic [             8:0][DATA_WIDTH-1:0] vec_a_neg;
    logic [             8:0][DATA_WIDTH-1:0] skew_symmetric;
    logic [             8:0][DATA_WIDTH-1:0] transpose;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vpermute;

    for (genvar i = 0; i < 9; i = i + 1) begin: negate_inputs
        assign vec_a_neg[i] = {~vec_a[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
    end

    assign skew_symmetric[0] = 32'b0;
    assign skew_symmetric[1] = vec_a[2];
    assign skew_symmetric[2] = vec_a_neg[1];
    assign skew_symmetric[3] = vec_a_neg[2];
    assign skew_symmetric[4] = 32'b0;
    assign skew_symmetric[5] = vec_a[0];
    assign skew_symmetric[6] = vec_a[1];
    assign skew_symmetric[7] = vec_a_neg[0];
    assign skew_symmetric[8] = 32'b0;

    for (genvar i = 0; i < 3; i = i + 1) begin
        for (genvar j = 0; j < 3; j = j + 1) begin
            assign transpose[3*i+j] = vec_a[3*j+i];
        end
    end

    always_comb begin
        case (funct)
            3'b000:  vpermute = skew_symmetric;
            3'b001:  vpermute = transpose;
            default: vpermute = '0;
        endcase
    end

    // TODO: Pass shift amount from rs1 or immediate
    // vector_slide (.vec_a, .vec_b, .shift(), .vector_slide);

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        logic [DATA_WIDTH-1:0] inst_a;
        logic [DATA_WIDTH-1:0] inst_b;
        logic                  aeqb_inst;
        logic                  altb_inst;
        logic                  agtb_inst;
        logic                  unordered_inst;
        logic [DATA_WIDTH-1:0] z0_inst;
        logic [DATA_WIDTH-1:0] z1_inst;
        logic [           7:0] status0_inst;
        logic [           7:0] status1_inst;
        logic [DATA_WIDTH-1:0] sgnj;
        logic [DATA_WIDTH-1:0] sgnjn;
        logic [DATA_WIDTH-1:0] sgnjx;
        logic [DATA_WIDTH-1:0] classify;
   
        assign inst_a = (funct == 3'b101) ? vec_a[0] : vec_a[i];
        assign inst_b = vec_b[i];

        DW_fp_cmp_DG #(
            .sig_width      (SIG_WIDTH      ),
            .exp_width      (EXP_WIDTH      ),
            .ieee_compliance(IEEE_COMPLIANCE)
        ) DW_fp_cmp_DG_inst (
            .a              (inst_a         ),
            .b              (inst_b         ),
            .zctr           (1'b0           ),
            .DG_ctrl        (en             ),
            .aeqb           (aeqb_inst      ),
            .altb           (altb_inst      ),
            .agtb           (agtb_inst      ),
            .unordered      (unordered_inst ),
            .z0             (z0_inst        ),
            .z1             (z1_inst        ),
            .status0        (status0_inst   ),
            .status1        (status1_inst   )
        );

        assign sgnj  = {inst_b[DATA_WIDTH-1], inst_a[DATA_WIDTH-2:0]};
        assign sgnjn = {~inst_b[DATA_WIDTH-1], inst_a[DATA_WIDTH-2:0]};
        assign sgnjx = {inst_a[DATA_WIDTH-1] ^ inst_b[DATA_WIDTH-1], inst_a[DATA_WIDTH-2:0]};

        assign zero_frac = inst_a[22:0] == 0;
        assign zero_exp  = inst_a[30:23] == 0;

        assign classify[0] = (inst_a == 32'hff800000);
        assign classify[1] = inst_a[31] && (~zero_exp || zero_frac);
        assign classify[2] = inst_a[31] && (zero_exp && ~zero_frac);
        assign classify[3] = inst_a[31] && zero_exp && zero_frac;
        assign classify[4] = ~inst_a[31] && zero_exp && zero_frac;
        assign classify[5] = ~inst_a[31] && (zero_exp && ~zero_frac);
        assign classify[6] = ~inst_a[31] && (~zero_exp || zero_frac);
        assign classify[7] = (inst_a == 32'h7f800000);
        assign classify[8] = 0; // TODO: 
        assign classify[9] = 0; // TODO: 
        assign classify[DATA_WIDTH-1:10] = '0;

        always @(posedge clk) begin
            case (opcode)
                `VFU_MIN:   vec_out[i] <= z0_inst;
                `VFU_MAX:   vec_out[i] <= z1_inst;
                `VFU_EQ:    vec_out[i] <= aeqb_inst;
                `VFU_LT:    vec_out[i] <= altb_inst;
                `VFU_LE:    vec_out[i] <= aeqb_inst || altb_inst;
                `VFU_SGNJ:  vec_out[i] <= sgnj;
                `VFU_SGNJN: vec_out[i] <= sgnjn;
                `VFU_SGNJX: vec_out[i] <= sgnjx;
                `VPERMUTE:  vec_out[i] <= vpermute[i];
                default:    vec_out[i] <= '0;
            endcase
        end
    end

endmodule
