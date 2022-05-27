module vector_unit #(
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
    input  logic [             3:0]                 opcode,
    input  logic [             2:0]                 funct,
    input  logic [             2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        logic [DATA_WIDTH-1:0] inst_a;
        logic [DATA_WIDTH-1:0] inst_b;
        logic [DATA_WIDTH-1:0] inst_c;
        logic [DATA_WIDTH-1:0] z_inst;
        logic                  aeqb_inst;
        logic                  altb_inst;
        logic                  agtb_inst;
        logic                  unordered_inst;
        logic [DATA_WIDTH-1:0] max_ab;
        logic [DATA_WIDTH-1:0] min_ab;
        logic [DATA_WIDTH-1:0] sgnj_inst;
        logic [DATA_WIDTH-1:0] sgnjn_inst;
        logic [DATA_WIDTH-1:0] sgnjx_inst;

        assign inst_a = (funct == 3'b101) ? vec_a[0] : vec_a[i];

        always_comb begin
            case (opcode)
                `VFU_ADD,
                `VFU_SUB:  inst_b = 32'h3f800000;
                `VFU_FNMA,
                `VFU_FNMS: inst_b = {~vec_b[i][DATA_WIDTH-1], vec_b[i][DATA_WIDTH-2:0]};
                default:   inst_b = vec_b[i];
            endcase

            case (opcode)
                `VFU_ADD:  inst_c = vec_b[i];
                `VFU_SUB:  inst_c = {~vec_b[i][DATA_WIDTH-1], vec_b[i][DATA_WIDTH-2:0]};
                `VFU_MUL:  inst_c = 32'b0;
                `VFU_FMS,
                `VFU_FNMA: inst_c = {~vec_c[i][DATA_WIDTH-1], vec_c[i][DATA_WIDTH-2:0]};
                default:  inst_c = vec_c[i];
            endcase
        end

        DW_fp_mac_DG #(
            .sig_width      (SIG_WIDTH      ),
            .exp_width      (EXP_WIDTH      ),
            .ieee_compliance(IEEE_COMPLIANCE)
        ) DW_fp_mac_inst (
            .a              (inst_a         ),
            .b              (inst_b         ),
            .c              (inst_c         ),
            .rnd            (rnd            ),
            .DG_ctrl        (en             ),
            .z              (z_inst         ),
            .status         (               )
        );

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
            .z0             (min_ab         ),
            .z1             (max_ab         ),
            .status0        (               ),
            .status1        (               )
        );

        assign sgnj_inst  = {vec_b[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
        assign sgnjn_inst = {~vec_b[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
        assign sgnjx_inst = {vec_a[i][DATA_WIDTH-1] ^ vec_b[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};

        always_comb begin
            case (opcode)
                `VFU_MIN:   vec_out[i] = min_ab;
                `VFU_MAX:   vec_out[i] = max_ab;
                `VFU_EQ:    vec_out[i] = aeqb_inst;
                `VFU_LT:    vec_out[i] = altb_inst;
                `VFU_LE:    vec_out[i] = aeqb_inst || altb_inst;
                `VFU_SGNJ:  vec_out[i] = sgnj_inst;
                `VFU_SGNJN: vec_out[i] = sgnjn_inst;
                `VFU_SGNJX: vec_out[i] = sgnjx_inst;
                default:    vec_out[i] = z_inst;
            endcase
        end
    end

endmodule
