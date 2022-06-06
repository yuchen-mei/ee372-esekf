module vfpu #(
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
    input  logic [             4:0]                 opcode,
    input  logic [             2:0]                 funct,
    input  logic [             2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        logic [DATA_WIDTH-1:0] inst_a;
        logic [DATA_WIDTH-1:0] inst_b;
        logic [DATA_WIDTH-1:0] inst_c;
        logic [DATA_WIDTH-1:0] z_inst;
        logic [           7:0] status_inst;

        logic [DATA_WIDTH-1:0] b_neg;
        logic [DATA_WIDTH-1:0] c_neg;

        assign b_neg = {~vec_b[i][DATA_WIDTH-1], vec_b[i][DATA_WIDTH-2:0]};
        assign c_neg = {~vec_c[i][DATA_WIDTH-1], vec_c[i][DATA_WIDTH-2:0]};

        assign inst_a = (funct == 3'b101) ? vec_a[0] : vec_a[i];

        always_comb begin
            case (opcode)
                `VFU_ADD, `VFU_SUB:   inst_b = 32'h3f800000;
                `VFU_FNMA, `VFU_FNMS: inst_b = b_neg;
                default:              inst_b = vec_b[i];
            endcase

            case (opcode)
                `VFU_ADD:            inst_c = vec_b[i];
                `VFU_SUB:            inst_c = b_neg;
                `VFU_MUL:            inst_c = 32'b0;
                `VFU_FMS, `VFU_FNMA: inst_c = c_neg;
                default:             inst_c = vec_c[i];
            endcase
        end

        DW_fp_mac_DG_inst_pipe #(
            .SIG_WIDTH      (SIG_WIDTH      ),
            .EXP_WIDTH      (EXP_WIDTH      ),
            .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
            .NUM_STAGES     (NUM_STAGES     )
        ) U1 (
            .inst_clk       (clk            ),
            .inst_a         (inst_a         ),
            .inst_b         (inst_b         ),
            .inst_c         (inst_c         ),
            .inst_rnd       (rnd            ),
            .inst_DG_ctrl   (en             ),
            .z_inst         (vec_out[i]     ),
            .status_inst    (status_inst    )
        );
    end

endmodule
