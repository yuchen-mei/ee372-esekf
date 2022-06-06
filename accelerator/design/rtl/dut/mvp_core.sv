module mvp_core #(
    parameter SIG_WIDTH            = 23,
    parameter EXP_WIDTH            = 8,
    parameter IEEE_COMPLIANCE      = 0,
    
    parameter VECTOR_LANES         = 16,

    parameter ADDR_WIDTH           = 16,
    parameter DATA_WIDTH           = SIG_WIDTH + EXP_WIDTH + 1,

    parameter INSTR_MEM_ADDR_WIDTH = 8,
    parameter DATA_MEM_ADDR_WIDTH  = 12,
    parameter REG_BANK_DEPTH       = 32,
    parameter REG_ADDR_WIDTH       = $clog2(REG_BANK_DEPTH)
) (
    input  logic                               clk,
    input  logic                               rst_n,
    input  logic                               en,

    output logic [   INSTR_MEM_ADDR_WIDTH-1:0] pc,
    input  logic [                       31:0] instr,

    output logic [             ADDR_WIDTH-1:0] mem_addr,
    output logic                               mem_ren,
    output logic                               mem_we,
    input  logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_rdata,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_wdata,
    output logic [                        2:0] width,

    output logic                               data_out_vld,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] data_out,
    output logic [                        4:0] reg_wb
);

    logic                                    en_q;
    logic                                    stall;
    logic [             4:0]                 opcode_id;
    logic [             4:0]                 opcode_ex1;
    logic [             4:0]                 vd_addr_id;
    logic [             4:0]                 vd_addr_ex1;
    logic [             4:0]                 vd_addr_ex2;
    logic [             4:0]                 vd_addr_ex3;
    logic [             4:0]                 vd_addr_ex4;
    logic [             4:0]                 vd_addr_wb;
    logic [             4:0]                 vs1_addr_id;
    logic [             4:0]                 vs1_addr_ex1;
    logic [             4:0]                 vs2_addr_id;
    logic [             4:0]                 vs2_addr_ex1;
    logic [             4:0]                 vs3_addr_id;
    logic [             4:0]                 vs3_addr_ex1;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_ex1;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs2_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs2_data_ex1;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs3_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs3_data_ex1;
    logic [  DATA_WIDTH-1:0]                 rs1_data_id;
    logic [  DATA_WIDTH-1:0]                 rs2_data_id;
    logic [  DATA_WIDTH-1:0]                 rs3_data_id;
    logic [             2:0]                 funct3_id;
    logic [             2:0]                 funct3_ex1;
    logic [             3:0]                 op_sel_id;
    logic [             3:0]                 op_sel_ex1;
    logic [             3:0]                 op_sel_ex2;
    logic [             3:0]                 op_sel_ex3;
    logic [             3:0]                 op_sel_ex4;
    logic [             3:0]                 op_sel_wb;
    logic                                    reg_we_id;
    logic                                    reg_we_ex1;
    logic                                    reg_we_ex2;
    logic                                    reg_we_ex3;
    logic                                    reg_we_ex4;
    logic                                    reg_we_wb;
    logic                                    mem_we_id;
    logic                                    mem_we_ex1;
    logic [  ADDR_WIDTH-1:0]                 mem_addr_id;
    logic [  ADDR_WIDTH-1:0]                 mem_addr_ex1;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata_ex3;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata_ex4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata_wb;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_wdata_wb;

    assign data_out     = reg_wdata_wb;
    assign data_out_vld = en && reg_we_wb;
    assign reg_wb       = vd_addr_wb;

    always @(posedge clk) begin
        en_q <= en;
        // synopsys translate_off
        if (data_out_vld) begin
            for (int i = VECTOR_LANES - 1; i >= 0 ; i = i - 1) begin
                $write("%h_", reg_wdata_wb[i]);
            end
            $display();
        end
        // synopsys translate_on
    end

    instruction_fetch #(
        .ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH)
    ) if_stage (
        .clk           (clk        ),
        .rst_n         (rst_n      ),
        .en            (en & ~stall),
        // .jump_target   (jump_target_id),
        // .instr_id      (instr_id[25:0]),

        // .branch        (jump_branch_id),
        // .branch_offset (branch_offset_id),

        // .jump_reg      (jump_reg_id),
        // .jr_pc         (jr_pc_id),

        .pc            (pc         )
    );

    //=======================================================
    // Instruction Decode Stage
    //=======================================================

    decoder decoder_inst (
        .instr      (instr        ),
        // Instruction out
        .vfu_opcode (opcode_id    ),
        .vd_addr    (vd_addr_id   ),
        .vs1_addr   (vs1_addr_id  ),
        .vs2_addr   (vs2_addr_id  ),
        .vs3_addr   (vs3_addr_id  ),
        // Controls
        .op_sel     (op_sel_id    ),
        .funct3     (funct3_id    ),
        .masking    (             ),
        .reg_we     (reg_we_id    ),
        // Memory instruction
        .mem_we     (mem_we_id    ),
        .mem_addr   (mem_addr_id  ),
        // Stalling logic
        .vd_addr_ex1(vd_addr_ex1  ),
        .vd_addr_ex2(vd_addr_ex2  ),
        .vd_addr_ex3(vd_addr_ex3  ),
        .reg_we_ex1 (reg_we_ex1   ),
        .reg_we_ex2 (reg_we_ex2   ),
        .reg_we_ex3 (reg_we_ex3   ),
        .op_sel_ex1 (op_sel_ex1   ),
        .op_sel_ex2 (op_sel_ex2   ),
        .op_sel_ex3 (op_sel_ex3   ),
        .stall      (stall        )
    );

    // regfile #(
    //     .ADDR_WIDTH (REG_ADDR_WIDTH ),
    //     .DEPTH      (REG_BANK_DEPTH ),
    //     .DATA_WIDTH (DATA_WIDTH     )
    // ) regfile_inst (
    //     .clk        (clk            ),
    //     .rst_n      (rst_n          ),
    //     // Write Port
    //     .wen        (reg_we_wb      ),
    //     .addr_w     (vd_addr_wb     ),
    //     .data_w     (reg_wdata_wb[0]),
    //     // Read Ports
    //     .addr_r1    (vs1_addr_id    ),
    //     .data_r1    (rs1_data_id    ),
    //     .addr_r2    (vs2_addr_id    ),
    //     .data_r2    (rs2_data_id    ),
    //     .addr_r3    (vs3_addr_id    ),
    //     .data_r3    (rs3_data_id    )
    // );

    // FIXME: Don't write when en is low
    vrf #(
        .ADDR_WIDTH (REG_ADDR_WIDTH         ),
        .DEPTH      (REG_BANK_DEPTH         ),
        .DATA_WIDTH (VECTOR_LANES*DATA_WIDTH)
    ) vrf_inst (
        .clk        (clk                    ),
        .rst_n      (rst_n                  ),
        // Write Port
        .wen        (reg_we_wb              ),
        .addr_w     (vd_addr_wb             ),
        .data_w     (reg_wdata_wb           ),
        // Read Ports
        .addr_r1    (vs1_addr_id            ),
        .data_r1    (vs1_data_id            ),
        .addr_r2    (vs2_addr_id            ),
        .data_r2    (vs2_data_id            ),
        .addr_r3    (vs3_addr_id            ),
        .data_r3    (vs3_data_id            )
    );

    //=======================================================
    // Execute Stages
    //=======================================================

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] operand_a;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] operand_b;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] operand_c;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_ex2;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_ex3;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_ex4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_wb;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vfpu_out_ex4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vfpu_out_wb;
    logic [             8:0][DATA_WIDTH-1:0] mat_out_wb;
    logic                   [DATA_WIDTH-1:0] mfu_out_ex4;
    logic                   [DATA_WIDTH-1:0] mfu_out_wb;
    logic [             7:0]                 status_inst;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] stage2_forward;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] stage3_forward;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] stage4_forward;

    assign stage2_forward = vec_out_ex2;
    assign stage3_forward = op_sel_ex3[3] ? mem_rdata_ex3 : vec_out_ex3;

    always_comb begin
        case (op_sel_ex4)
            4'b0001: stage4_forward = vfpu_out_ex4;
            4'b0100: stage4_forward = mfu_out_ex4;
            4'b1000: stage4_forward = mem_rdata_ex4;
            default: stage4_forward = vec_out_ex4;
        endcase
    end

    assign operand_a = ((vs1_addr_ex1 == vd_addr_ex2) && reg_we_ex2 && ~|op_sel_ex2)      ? stage2_forward : 
                       ((vs1_addr_ex1 == vd_addr_ex3) && reg_we_ex3 && ~|op_sel_ex3[2:0]) ? stage3_forward :
                       ((vs1_addr_ex1 == vd_addr_ex4) && reg_we_ex4 && ~op_sel_ex4[1])    ? stage4_forward :
                       ((vs1_addr_ex1 == vd_addr_wb) && reg_we_wb)                        ? reg_wdata_wb   : vs1_data_ex1;
    assign operand_b = ((vs2_addr_ex1 == vd_addr_ex2) && reg_we_ex2 && ~|op_sel_ex2)      ? stage2_forward : 
                       ((vs2_addr_ex1 == vd_addr_ex3) && reg_we_ex3 && ~|op_sel_ex3[2:0]) ? stage3_forward :
                       ((vs2_addr_ex1 == vd_addr_ex4) && reg_we_ex4 && ~op_sel_ex4[1])    ? stage4_forward :
                       ((vs2_addr_ex1 == vd_addr_wb) && reg_we_wb)                        ? reg_wdata_wb   : vs2_data_ex1;
    assign operand_c = ((vs3_addr_ex1 == vd_addr_ex2) && reg_we_ex2 && ~|op_sel_ex2)      ? stage2_forward : 
                       ((vs3_addr_ex1 == vd_addr_ex3) && reg_we_ex3 && ~|op_sel_ex3[2:0]) ? stage3_forward :
                       ((vs3_addr_ex1 == vd_addr_ex4) && reg_we_ex4 && ~op_sel_ex4[1])    ? stage4_forward :
                       ((vs3_addr_ex1 == vd_addr_wb) && reg_we_wb)                        ? reg_wdata_wb   : vs3_data_ex1;

    vector_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (VECTOR_LANES   )
    ) vector_unit_inst (
        .clk            (clk            ),
        .en             (~|op_sel_ex1   ),
        .vec_a          (operand_a      ),
        .vec_b          (operand_b      ),
        .rnd            (3'b0           ),
        .opcode         (opcode_ex1     ),
        .funct          (funct3_ex1     ),
        .vec_out        (vec_out_ex2    )
    );

    vfpu #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (VECTOR_LANES   ),
        .NUM_STAGES     (3              )
    ) vfpu_inst (
        .clk            (clk            ),
        .en             (op_sel_ex1[0]  ),
        .vec_a          (operand_a      ),
        .vec_b          (operand_b      ),
        .vec_c          (operand_c      ),
        .rnd            (3'b0           ),
        .opcode         (opcode_ex1     ),
        .funct          (funct3_ex1     ),
        .vec_out        (vfpu_out_ex4   )
    );

    dot_product_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (9              ),
        .NUM_STAGES     (4              )
    ) dp_unit_inst (
        .clk            (clk            ),
        .en             (op_sel_ex1[1]  ),
        .vec_a          (operand_a[8:0] ),
        .vec_b          (operand_b[8:0] ),
        .vec_c          (operand_c[8:0] ),
        .rnd            (3'b0           ),
        .funct          (funct3_ex1     ),
        .vec_out        (mat_out_wb     )
    );

    DW_lp_fp_multifunc_DG_inst_pipe #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .NUM_STAGES     (3              )
    ) mfu_inst (
        .inst_clk       (clk            ),
        .inst_a         (operand_a[0]   ),
        .inst_func      (funct3_ex1     ),
        .inst_rnd       (3'b0           ),
        .inst_DG_ctrl   (op_sel_ex1[2]  ),
        .z_inst         (mfu_out_ex4    ),
        .status_inst    (status_inst    )
    );

    //=======================================================
    // Memroy Stage
    //=======================================================

    assign mem_addr  = mem_addr_ex1;
    assign mem_we    = mem_we_ex1;
    assign mem_ren   = op_sel_ex1[3];
    assign mem_wdata = operand_c;
    assign width     = funct3_ex1;

    //=======================================================
    // Write Back Stage
    //=======================================================

    always_comb begin
        case (op_sel_wb)
            4'b0001: reg_wdata_wb = vfpu_out_wb;
            4'b0010: reg_wdata_wb = mat_out_wb;
            4'b0100: reg_wdata_wb = mfu_out_wb;
            4'b1000: reg_wdata_wb = mem_rdata_wb;
            default: reg_wdata_wb = vec_out_wb;
        endcase
    end

    //=======================================================
    // Pipeline Registers
    //=======================================================

    always @(posedge clk) begin
        if (~rst_n) begin
            vs1_addr_ex1 <= '0;
            vs2_addr_ex1 <= '0;
            vs3_addr_ex1 <= '0;

            opcode_ex1 <= '0;
            funct3_ex1 <= '0;

            vs1_data_ex1 <= '0;
            vs2_data_ex1 <= '0;
            vs3_data_ex1 <= '0;

            vd_addr_ex1 <= '0;
            vd_addr_ex2 <= '0;
            vd_addr_ex3 <= '0;
            vd_addr_ex4 <= '0;
            vd_addr_wb  <= '0;

            op_sel_ex1 <= '0;
            op_sel_ex2 <= '0;
            op_sel_ex3 <= '0;
            op_sel_ex4 <= '0;
            op_sel_wb  <= '0;

            vec_out_ex3 <= '0;
            vec_out_ex4 <= '0;
            vec_out_wb  <= '0;

            vfpu_out_wb <= '0;
            mfu_out_wb  <= '0;

            reg_we_ex1 <= '0;
            reg_we_ex2 <= '0;
            reg_we_ex3 <= '0;
            reg_we_ex4 <= '0;
            reg_we_wb  <= '0;

            mem_addr_ex1 <= '0;
            mem_we_ex1   <= '0;

            mem_rdata_ex3 <= '0;
            mem_rdata_ex4 <= '0;
            mem_rdata_wb  <= '0;
        end
        else if (en && (en_q || pc != 0)) begin
            vs1_addr_ex1 <= vs1_addr_id;
            vs2_addr_ex1 <= vs2_addr_id;
            vs3_addr_ex1 <= vs3_addr_id;

            opcode_ex1 <= opcode_id;
            funct3_ex1 <= funct3_id;

            vs1_data_ex1 <= vs1_data_id;
            vs2_data_ex1 <= vs2_data_id;
            vs3_data_ex1 <= vs3_data_id;

            vd_addr_ex1 <= vd_addr_id;
            vd_addr_ex2 <= vd_addr_ex1;
            vd_addr_ex3 <= vd_addr_ex2;
            vd_addr_ex4 <= vd_addr_ex3;
            vd_addr_wb  <= vd_addr_ex4;

            op_sel_ex1 <= ~stall ? op_sel_id : '0;
            op_sel_ex2 <= op_sel_ex1;
            op_sel_ex3 <= op_sel_ex2;
            op_sel_ex4 <= op_sel_ex3;
            op_sel_wb  <= op_sel_ex4;

            vec_out_ex3 <= vec_out_ex2;
            vec_out_ex4 <= vec_out_ex3;
            vec_out_wb  <= vec_out_ex4;

            vfpu_out_wb <= vfpu_out_ex4;
            mfu_out_wb  <= mfu_out_ex4;

            reg_we_ex1 <= reg_we_id && ~stall;
            reg_we_ex2 <= reg_we_ex1;
            reg_we_ex3 <= reg_we_ex2;
            reg_we_ex4 <= reg_we_ex3;
            reg_we_wb  <= reg_we_ex4;

            mem_addr_ex1 <= mem_addr_id;
            mem_we_ex1   <= mem_we_id && ~stall;

            mem_rdata_ex3 <= mem_rdata;
            mem_rdata_ex4 <= mem_rdata_ex3;
            mem_rdata_wb  <= mem_rdata_ex4;
        end
    end

endmodule

