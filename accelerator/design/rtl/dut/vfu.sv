module vector_unit #(
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
    input  logic              [3:0]                 opcode,
    input  logic              [2:0]                 funct,
    input  logic              [2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        logic [DATA_WIDTH-1:0] inst_a;
        logic [DATA_WIDTH-1:0] inst_b;
        logic [DATA_WIDTH-1:0] inst_c;
        logic [DATA_WIDTH-1:0] z_inst;
        logic            [7:0] status_inst;
        logic                  aeqb;
        logic                  altb;
        logic                  agtb;
        logic                  unordered;
        logic [DATA_WIDTH-1:0] max_ab;
        logic [DATA_WIDTH-1:0] min_ab;
        logic            [7:0] status0_inst;
        logic            [7:0] status1_inst;
        logic [DATA_WIDTH-1:0] sgnj;
        logic [DATA_WIDTH-1:0] sgnjn;
        logic [DATA_WIDTH-1:0] sgnjx;
        logic [DATA_WIDTH-1:0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
        logic [DATA_WIDTH-1:0] z_inst_internal;
        

        always_comb begin
            inst_a = (funct == 3'b101) ? vec_a[0] : vec_a[i];

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
                default:   inst_c = vec_c[i];
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
            .status         (status_inst    )
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
            .aeqb           (aeqb           ),
            .altb           (altb           ),
            .agtb           (agtb           ),
            .unordered      (unordered      ),
            .z0             (min_ab         ),
            .z1             (max_ab         ),
            .status0        (status0_inst   ),
            .status1        (status1_inst   )
        );

        assign sgnj  = {vec_b[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
        assign sgnjn = {~vec_b[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
        assign sgnjx = {vec_a[i][DATA_WIDTH-1] ^ vec_b[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};

        always_comb begin
            case (opcode)
                `VFU_MIN:   z_inst_internal = min_ab;
                `VFU_MAX:   z_inst_internal = max_ab;
                `VFU_EQ:    z_inst_internal = aeqb;
                `VFU_LT:    z_inst_internal = altb;
                `VFU_LE:    z_inst_internal = aeqb || altb;
                `VFU_SGNJ:  z_inst_internal = sgnj;
                `VFU_SGNJN: z_inst_internal = sgnjn;
                `VFU_SGNJX: z_inst_internal = sgnjx;
                default:    z_inst_internal = z_inst;
            endcase
        end

        assign vec_out[i] = z_inst_internal;

        // always @(posedge clk) begin
        //     z_inst_pipe1 <= z_inst_internal;
        //     z_inst_pipe2 <= z_inst_pipe1;
        //     z_inst_pipe3 <= z_inst_pipe2;
        //     z_inst_pipe4 <= z_inst_pipe3;
        // end

        // assign vec_out[i] = (NUM_STAGES == 4) ? z_inst_pipe4 :
        //                     (NUM_STAGES == 3) ? z_inst_pipe3 :
        //                     (NUM_STAGES == 2) ? z_inst_pipe2 : z_inst_pipe1;
    end

endmodule
