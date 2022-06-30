module mvp_core #(
    parameter  SIG_WIDTH            = 23,
    parameter  EXP_WIDTH            = 8,
    parameter  IEEE_COMPLIANCE      = 0,
    
    parameter  VECTOR_LANES         = 16,
    parameter  DATA_WIDTH           = SIG_WIDTH + EXP_WIDTH + 1,

    parameter  INSTR_MEM_ADDR_WIDTH = 8,
    parameter  REG_BANK_DEPTH       = 32,
    localparam REG_ADDR_WIDTH       = $clog2(REG_BANK_DEPTH)
) (
    input  logic                               clk,
    input  logic                               rst_n,
    input  logic                               en,

    output logic [   INSTR_MEM_ADDR_WIDTH-1:0] pc,
    input  logic [                       31:0] instr,

    output logic [                       11:0] mem_addr,
    output logic                               mem_read,
    output logic                               mem_write,
    input  logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_rdata,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_wdata,
    output logic [                        2:0] width,

    output logic                               data_out_vld,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] data_out,
    output logic [                        4:0] reg_wb
);

    logic                                    en_q;
    logic                                    stall;
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
    logic [             4:0]                 opcode_id;
    logic [             4:0]                 opcode_ex1;
    logic [             2:0]                 funct3_id;
    logic [             2:0]                 funct3_ex1;
    logic [             4:0]                 wb_sel_id;
    logic [             4:0]                 wb_sel_ex1;
    logic [             4:0]                 wb_sel_ex2;
    logic [             4:0]                 wb_sel_ex3;
    logic [             4:0]                 wb_sel_ex4;
    logic [             4:0]                 wb_sel_wb;
    logic                                    reg_we_id;
    logic                                    reg_we_ex1;
    logic                                    reg_we_ex2;
    logic                                    reg_we_ex3;
    logic                                    reg_we_ex4;
    logic                                    reg_we_wb;
    logic                                    mem_we_id;
    logic                                    mem_we_ex1;
    logic [            11:0]                 mem_addr_id;
    logic [            11:0]                 mem_addr_ex1;
    logic [            11:0]                 mem_addr_ex2;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata_ex3;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata_ex4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata_wb;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_wdata_wb;
    logic                                    jump_id;
    logic [        INSTR_MEM_ADDR_WIDTH-1:0] jump_addr_id;
    logic [        INSTR_MEM_ADDR_WIDTH-1:0] jump_addr_ex2;
    logic                                    pc_sel;
    logic                                    branch_id;
    logic                                    branch_ex1;
    logic                                    branch_ex2;

    assign data_out     = reg_wdata_wb;
    assign data_out_vld = en && reg_we_wb;
    assign reg_wb       = vd_addr_wb;

    logic pipe_en;
    assign pipe_en = en && (en_q || pc != 0);

    always @(posedge clk) begin
        en_q <= en;
        // synopsys translate_off
        if (data_out_vld) begin
            for (int i = 8; i >= 0 ; i = i - 1) begin
                $write("%h_", reg_wdata_wb[i]);
            end
            $display();
        end
        // synopsys translate_on
    end

    instruction_fetch #(
        .ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH)
    ) if_stage (
        .clk           (clk           ),
        .rst_n         (rst_n         ),
        .en            (en & ~stall   ),

        .branch        (pc_sel        ),
        .branch_offset (jump_addr_ex2 ),

        .jump          (jump_id       ),
        .jump_addr     (jump_addr_id  ),

        .pc            (pc            )
    );

    assign jump_addr_id  = mem_addr_id[INSTR_MEM_ADDR_WIDTH-1:0];
    assign jump_addr_ex2 = mem_addr_ex2[INSTR_MEM_ADDR_WIDTH-1:0];

    // logic [31:0] instr_r

    // always @(posedge clk) begin
    //     if (~rst_n) instr_r <= '0;
    //     else if (en_q) instr_r <= instr;
    // end

    //=======================================================
    // Instruction Decode Stage
    //=======================================================

    decoder decoder_inst (
        .instr        ( instr       ),
        // Registers and immediate
        .vd_addr      ( vd_addr_id  ),
        .vs1_addr     ( vs1_addr_id ),
        .vs2_addr     ( vs2_addr_id ),
        .vs3_addr     ( vs3_addr_id ),
        .mem_addr     ( mem_addr_id ),
        // Control signals
        .func_sel     ( opcode_id   ),
        .funct3       ( funct3_id   ),
        .wb_sel       ( wb_sel_id   ),
        .masking      (             ),
        .mem_write    ( mem_we_id   ),
        .reg_we       ( reg_we_id   ),
        .jump         ( jump_id     ),
        .branch       ( branch_id   ),
        // Stalling logic
        .vd_addr_ex1  ( vd_addr_ex1 ),
        .vd_addr_ex2  ( vd_addr_ex2 ),
        .vd_addr_ex3  ( vd_addr_ex3 ),
        .reg_we_ex1   ( reg_we_ex1  ),
        .reg_we_ex2   ( reg_we_ex2  ),
        .reg_we_ex3   ( reg_we_ex3  ),
        .wb_sel_ex1   ( wb_sel_ex1  ),
        .wb_sel_ex2   ( wb_sel_ex2  ),
        .wb_sel_ex3   ( wb_sel_ex3  ),
        .stall        ( stall       )
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

    vrf #(
        .ADDR_WIDTH (REG_ADDR_WIDTH         ),
        .DEPTH      (REG_BANK_DEPTH         ),
        .DATA_WIDTH (VECTOR_LANES*DATA_WIDTH)
    ) vrf_inst (
        .clk        (clk                    ),
        .rst_n      (rst_n                  ),
        // Write Port
        .wen        (en && reg_we_wb        ),
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
    logic                   [DATA_WIDTH-1:0] mfu_out_ex4;
    logic                   [DATA_WIDTH-1:0] mfu_out_wb;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vfu_out_ex4;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vfu_out_wb;
    logic [             8:0][DATA_WIDTH-1:0] mat_out_wb;
    logic [             7:0]                 status_inst;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] stage2_forward;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] stage3_forward;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] stage4_forward;

    assign stage2_forward = vec_out_ex2;
    assign stage3_forward = wb_sel_ex3[0] ? vec_out_ex3 : mem_rdata_ex3;

    always_comb begin
        case (wb_sel_ex4)
            5'b00001: stage4_forward = vec_out_ex4;
            5'b00010: stage4_forward = mem_rdata_ex4;
            5'b00100: stage4_forward = vfu_out_ex4;
            5'b01000: stage4_forward = mfu_out_ex4;
            default:  stage4_forward = '0;
        endcase
    end

    assign pc_sel = branch_ex2 && vec_out_ex2[0];

    assign operand_a = ((vs1_addr_ex1 == vd_addr_ex2) && reg_we_ex2 && wb_sel_ex2[0])    ? stage2_forward : 
                       ((vs1_addr_ex1 == vd_addr_ex3) && reg_we_ex3 && |wb_sel_ex3[1:0]) ? stage3_forward :
                       ((vs1_addr_ex1 == vd_addr_ex4) && reg_we_ex4 && ~wb_sel_ex4[4])   ? stage4_forward :
                       ((vs1_addr_ex1 == vd_addr_wb) && reg_we_wb)                       ? reg_wdata_wb   : vs1_data_ex1;
    assign operand_b = ((vs2_addr_ex1 == vd_addr_ex2) && reg_we_ex2 && wb_sel_ex2[0])    ? stage2_forward : 
                       ((vs2_addr_ex1 == vd_addr_ex3) && reg_we_ex3 && |wb_sel_ex3[1:0]) ? stage3_forward :
                       ((vs2_addr_ex1 == vd_addr_ex4) && reg_we_ex4 && ~wb_sel_ex4[4])   ? stage4_forward :
                       ((vs2_addr_ex1 == vd_addr_wb) && reg_we_wb)                       ? reg_wdata_wb   : vs2_data_ex1;
    assign operand_c = ((vs3_addr_ex1 == vd_addr_ex2) && reg_we_ex2 && wb_sel_ex2[0])    ? stage2_forward : 
                       ((vs3_addr_ex1 == vd_addr_ex3) && reg_we_ex3 && |wb_sel_ex3[1:0]) ? stage3_forward :
                       ((vs3_addr_ex1 == vd_addr_ex4) && reg_we_ex4 && ~wb_sel_ex4[4])   ? stage4_forward :
                       ((vs3_addr_ex1 == vd_addr_wb) && reg_we_wb)                       ? reg_wdata_wb   : vs3_data_ex1;

    vector_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (VECTOR_LANES   )
    ) vector_unit_inst (
        .clk            (clk            ),
        .en             (wb_sel_ex1[0]  ),
        .vec_a          (operand_a      ),
        .vec_b          (operand_b      ),
        .vec_c          (operand_c      ),
        .rnd            (3'b0           ),
        .opcode         (opcode_ex1     ),
        .funct          (funct3_ex1     ),
        .imm            (vs1_addr_ex1   ),
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
        .en             (wb_sel_ex1[2]  ),
        .vec_a          (operand_a      ),
        .vec_b          (operand_b      ),
        .vec_c          (operand_c      ),
        .rnd            (3'b0           ),
        .opcode         (opcode_ex1     ),
        .funct          (funct3_ex1     ),
        .vec_out        (vfu_out_ex4    )
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
        .inst_DG_ctrl   (wb_sel_ex1[3]  ),
        .z_inst         (mfu_out_ex4    ),
        .status_inst    (status_inst    )
    );

    dot_product_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (9              ),
        .NUM_STAGES     (4              )
    ) dp_unit_inst (
        .clk            (clk            ),
        .en             (wb_sel_ex1[4]  ),
        .vec_a          (operand_a[8:0] ),
        .vec_b          (operand_b[8:0] ),
        .vec_c          (operand_c[8:0] ),
        .rnd            (3'b0           ),
        .funct          (funct3_ex1     ),
        .vec_out        (mat_out_wb     )
    );

    //=======================================================
    // Memroy Stage
    //=======================================================

    assign mem_addr  = mem_addr_ex1;
    assign mem_write = mem_we_ex1 && en;
    assign mem_read  = wb_sel_ex1[1] && en;
    assign mem_wdata = operand_c;
    assign width     = funct3_ex1;

    //=======================================================
    // Write Back Stage
    //=======================================================

    always_comb begin
        case (wb_sel_wb)
            5'b00001: reg_wdata_wb = vec_out_wb;
            5'b00010: reg_wdata_wb = mem_rdata_wb;
            5'b00100: reg_wdata_wb = vfu_out_wb;
            5'b01000: reg_wdata_wb = mfu_out_wb;
            5'b10000: reg_wdata_wb = mat_out_wb;
            default:  reg_wdata_wb = '0;
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
            mem_addr_ex1 <= '0;
            mem_addr_ex2 <= '0;

            vs1_data_ex1 <= '0;
            vs2_data_ex1 <= '0;
            vs3_data_ex1 <= '0;

            vd_addr_ex1 <= '0;
            vd_addr_ex2 <= '0;
            vd_addr_ex3 <= '0;
            vd_addr_ex4 <= '0;
            vd_addr_wb  <= '0;

            opcode_ex1 <= '0;
            funct3_ex1 <= '0;
            mem_we_ex1 <= '0;

            reg_we_ex1 <= '0;
            reg_we_ex2 <= '0;
            reg_we_ex3 <= '0;
            reg_we_ex4 <= '0;
            reg_we_wb  <= '0;

            wb_sel_ex1 <= '0;
            wb_sel_ex2 <= '0;
            wb_sel_ex3 <= '0;
            wb_sel_ex4 <= '0;
            wb_sel_wb  <= '0;

            branch_ex1 <= '0;
            branch_ex2 <= '0;

            vec_out_ex3 <= '0;
            vec_out_ex4 <= '0;
            vec_out_wb  <= '0;

            vfu_out_wb <= '0;
            mfu_out_wb <= '0;

            mem_rdata_ex3 <= '0;
            mem_rdata_ex4 <= '0;
            mem_rdata_wb  <= '0;
        end
        else if (pipe_en) begin
            vs1_addr_ex1 <= vs1_addr_id;
            vs2_addr_ex1 <= vs2_addr_id;
            vs3_addr_ex1 <= vs3_addr_id;
            mem_addr_ex1 <= mem_addr_id;
            mem_addr_ex2 <= mem_addr_ex1;

            vs1_data_ex1 <= vs1_data_id;
            vs2_data_ex1 <= vs2_data_id;
            vs3_data_ex1 <= vs3_data_id;

            vd_addr_ex1 <= vd_addr_id;
            vd_addr_ex2 <= vd_addr_ex1;
            vd_addr_ex3 <= vd_addr_ex2;
            vd_addr_ex4 <= vd_addr_ex3;
            vd_addr_wb  <= vd_addr_ex4;

            opcode_ex1 <= opcode_id;
            funct3_ex1 <= funct3_id;
            mem_we_ex1 <= mem_we_id && ~stall;

            reg_we_ex1 <= reg_we_id && ~stall;
            reg_we_ex2 <= reg_we_ex1;
            reg_we_ex3 <= reg_we_ex2;
            reg_we_ex4 <= reg_we_ex3;
            reg_we_wb  <= reg_we_ex4;

            wb_sel_ex1 <= stall ? 5'b0 : wb_sel_id;
            wb_sel_ex2 <= wb_sel_ex1;
            wb_sel_ex3 <= wb_sel_ex2;
            wb_sel_ex4 <= wb_sel_ex3;
            wb_sel_wb  <= wb_sel_ex4;

            branch_ex1 <= branch_id && ~stall;
            branch_ex2 <= branch_ex1;

            vec_out_ex3 <= vec_out_ex2;
            vec_out_ex4 <= vec_out_ex3;
            vec_out_wb  <= vec_out_ex4;

            vfu_out_wb <= vfu_out_ex4;
            mfu_out_wb <= mfu_out_ex4;

            mem_rdata_ex3 <= mem_rdata;
            mem_rdata_ex4 <= mem_rdata_ex3;
            mem_rdata_wb  <= mem_rdata_ex4;
        end
    end

endmodule

