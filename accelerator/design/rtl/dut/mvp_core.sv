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

    logic        rst_id;
    logic        en_q;
    logic        en_pl;
    logic        en_if;
    logic [31:0] instr_sav;
    logic [31:0] instr_id;
    logic        stall;
    logic        stall_r;

    logic [             3:0]                 opcode_id;
    logic [             3:0]                 opcode_ex;
    logic [             4:0]                 vd_addr_id;
    logic [             4:0]                 vd_addr_ex;
    logic [             4:0]                 vd_addr_mem;
    logic [             4:0]                 vd_addr_wb;
    logic [             4:0]                 vs1_addr_id;
    logic [             4:0]                 vs1_addr_ex;
    logic [             4:0]                 vs2_addr_id;
    logic [             4:0]                 vs2_addr_ex;
    logic [             4:0]                 vs3_addr_id;
    logic [             4:0]                 vs3_addr_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_in;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs2_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs2_data_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs3_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs3_data_ex;
    logic [             2:0]                 funct3_id;
    logic [             2:0]                 funct3_ex;
    logic [             2:0]                 op_sel_id;
    logic [             2:0]                 op_sel_ex;
    logic [             2:0]                 op_sel_mem;
    logic                                    reg_we_id;
    logic                                    reg_we_ex;
    logic                                    reg_we_mem;
    logic                                    reg_we_wb;
    logic                                    mem_we_id;
    logic                                    mem_we_ex;
    logic                                    mem_ren_id;
    logic                                    mem_ren_ex;
    logic                                    mem_ren_mem;
    logic [  ADDR_WIDTH-1:0]                 mem_addr_id;
    logic [  ADDR_WIDTH-1:0]                 mem_addr_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_wdata_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_wdata_ex2;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_wdata_mem;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_wdata_wb;

    assign en_if  = ~stall & en;
    assign rst_id = stall & en;
    assign en_pl  = en & en_q;

    assign data_out     = reg_wdata_wb;
    assign data_out_vld = reg_we_wb;
    assign reg_wb       = vd_addr_wb;

    always @(posedge clk) begin
        en_q <= en;
    end

    instruction_fetch #(
        .ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH)
    ) if_stage (
        .clk           (clk  ),
        .rst_n         (rst_n),
        .en            (en_if),
        // .jump_target   (jump_target_id),
        // .instr_id      (instr_id[25:0]),

        // .branch        (jump_branch_id),
        // .branch_offset (branch_offset_id),

        // .jump_reg      (jump_reg_id),
        // .jr_pc         (jr_pc_id),

        .pc            (pc)
    );

    // Saved ID instruction after a stall
    dff #(32, 1, 1) instr_sav_dff (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(instr), .out(instr_sav));
    dff #(1, 1, 1)  stall_f_dff   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(stall), .out(stall_r));
    assign instr_id = stall_r ? instr_sav : instr;

    //=======================================================
    // Instruction Decode Stage
    //=======================================================

    decoder decoder_inst (
        .instr      (instr_id     ),
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
        .mem_ren    (mem_ren_id   ),
        .mem_addr   (mem_addr_id  ),
        // Stalling logic
        .vd_addr_ex (vd_addr_ex   ),
        .reg_we_ex  (reg_we_ex    ),
        .stall      (stall        )
    );

    register_file #(
        .ADDR_WIDTH (REG_ADDR_WIDTH         ),
        .DEPTH      (REG_BANK_DEPTH         ),
        .DATA_WIDTH (VECTOR_LANES*DATA_WIDTH)
    ) register_file_inst (
        .clk        (clk                    ),
        .rst_n      (rst_n                  ),
        // Write Port
        .wen        (reg_we_wb              ),
        .addr_w     (vd_addr_wb             ),
        .data_w     (reg_wdata_wb           ),
        // Read Ports
        .addr_r1    (vs1_addr_id            ),
        .data_r1    (vs1_data_in            ),
        .addr_r2    (vs2_addr_id            ),
        .data_r2    (vs2_data_id            ),
        .addr_r3    (vs3_addr_id            ),
        .data_r3    (vs3_data_id            )
    );

    assign vs1_data_id = (funct3_id == 3'b101) ? {VECTOR_LANES{vs1_data_in[0]}} : vs1_data_in;

    // always @(posedge clk) begin
    //     if (~rst_n) begin
    //         vd_addr_ex  <= 'b0;
    //         vs1_addr_ex <= 'b0;
    //         vs2_addr_ex <= 'b0;
    //         vs3_addr_ex <= 'b0;

    //         opcode_ex <= 'b0;
    //         funct3_ex <= 'b0;
    //         op_sel_ex <= 'b0;
    //         reg_we_ex <= 'b0;

    //         vs1_data_ex <= 'b0;
    //         vs2_data_ex <= 'b0;
    //         vs3_data_ex <= 'b0;

    //         mem_we_ex   <= 'b0;
    //         mem_ren_ex  <= 'b0;
    //         mem_addr_ex <= 'b0;
    //     end
    //     else begin
    //         vd_addr_ex  <= vd_addr_id;
    //         vs1_addr_ex <= vs1_addr_id;
    //         vs2_addr_ex <= vs2_addr_id;
    //         vs3_addr_ex <= vs3_addr_id;

    //         opcode_ex <= opcode_id;
    //         funct3_ex <= funct3_id;
    //         op_sel_ex <= op_sel_ex;
    //         reg_we_ex <= reg_we_id & ~rst_id;

    //         vs1_data_ex <= vs1_data_id;
    //         vs2_data_ex <= vs2_data_id;
    //         vs3_data_ex <= vs3_data_id;

    //         mem_we_ex   <= mem_we_id & ~rst_id;
    //         mem_ren_ex  <= mem_ren_id & ~rst_id;
    //         mem_addr_ex <= mem_addr_id;
    //     end
    // end

    dff #(5, 1, 1) vd_addr_id2ex  (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vd_addr_id),  .out(vd_addr_ex));
    dff #(5, 1, 1) vs1_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs1_addr_id), .out(vs1_addr_ex));
    dff #(5, 1, 1) vs2_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs2_addr_id), .out(vs2_addr_ex));
    dff #(5, 1, 1) vs3_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs3_addr_id), .out(vs3_addr_ex));

    dff #(4, 1, 1) opcode_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(opcode_id), .out(opcode_ex));
    dff #(3, 1, 1) funct3_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(funct3_id), .out(funct3_ex));
    dff #(3, 1, 1) op_sel_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(op_sel_id), .out(op_sel_ex));
    dff #(1, 1, 1) reg_we_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_we_id & ~rst_id), .out(reg_we_ex));

    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vs1_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs1_data_id), .out(vs1_data_ex));
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vs2_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs2_data_id), .out(vs2_data_ex));
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vs3_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs3_data_id), .out(vs3_data_ex));

    dff #(1, 1, 1) mem_we_id2ex  (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_we_id & ~rst_id),  .out(mem_we_ex));
    dff #(1, 1, 1) mem_ren_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_ren_id & ~rst_id), .out(mem_ren_ex));
    dff #(ADDR_WIDTH, 1, 1) mem_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_addr_id), .out(mem_addr_ex));

    //=======================================================
    // Execute Stage
    //=======================================================

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] operand_a;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] operand_b;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] operand_c;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_mem;
    logic [             8:0][DATA_WIDTH-1:0] mat_out_ex;
    logic [             8:0][DATA_WIDTH-1:0] mat_out_mem;
    logic                   [DATA_WIDTH-1:0] mfu_out_ex;
    logic                   [DATA_WIDTH-1:0] mfu_out_mem;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] permute_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] permute_mem;
    logic [             1:0]                 op_sel;

    assign operand_a = ((vs1_addr_ex == vd_addr_wb) & reg_we_wb) ? reg_wdata_wb : vs1_data_ex;
    assign operand_b = ((vs2_addr_ex == vd_addr_wb) & reg_we_wb) ? reg_wdata_wb : vs2_data_ex;
    assign operand_c = ((vs3_addr_ex == vd_addr_wb) & reg_we_wb) ? reg_wdata_wb : vs3_data_ex;

    vector_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (VECTOR_LANES   )
    ) vector_unit_inst (
        .clk            (clk            ),
        .vec_a          (operand_a      ),
        .vec_b          (operand_b      ),
        .vec_c          (operand_c      ),
        .rnd            (3'b0           ),
        .opcode         (opcode_ex      ),
        .funct          (funct3_ex      ),
        .en             (op_sel_ex[0]   ),
        .vec_out        (vec_out_ex     )
    );

    dot_product_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (9              )
    ) dp_unit_inst (
        .clk            (clk            ),
        .vec_a          (operand_a[8:0] ),
        .vec_b          (operand_b[8:0] ),
        .vec_c          (operand_c[8:0] ),
        .funct          (funct3_ex      ),
        .rnd            (3'b0           ),
        .en             (op_sel_ex[1]   ),
        .vec_out        (mat_out_ex     )
    );

    multifunc_unit #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
    ) mfu_inst (
        .clk            (clk            ),
        .data_in        (operand_a[0]   ),
        .funct          (funct3_ex      ),
        .rnd            (3'b0           ),
        .en             (op_sel_ex[2]   ),
        .data_out       (mfu_out_ex     )
    );

    dff #(VECTOR_LANES*DATA_WIDTH, 1, 0) vec_out_ex2mem (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vec_out_ex), .out(vec_out_mem));
    dff #(9*DATA_WIDTH, 1, 0) mat_out_ex2mem (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mat_out_ex), .out(mat_out_mem));
    dff #(DATA_WIDTH, 1, 0) mfu_out_ex2mem (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mfu_out_ex), .out(mfu_out_mem));

    // vector_permute #(
    //     .DATA_WIDTH  (DATA_WIDTH    ),
    //     .VECTOR_LANES(VECTOR_LANES  )
    // ) vector_permute_inst (
    //     .vec_in      (operand_a     ),
    //     .funct       (funct3_ex     ),
    //     .vec_out     (permute_out   )
    // );

    dff #(5, 1, 1) vd_addr_ex2mem  (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vd_addr_ex), .out(vd_addr_mem));
    dff #(3, 1, 1) op_sel_ex2mem   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(op_sel_ex),  .out(op_sel_mem));
    dff #(1, 1, 1) reg_we_ex2mem   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_we_ex),  .out(reg_we_mem));
    dff #(1, 1, 1) mem_ren_ex2mem  (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_ren_ex), .out(mem_ren_mem));

    //=======================================================
    // Memroy Stage
    //=======================================================

    assign mem_addr  = mem_addr_ex;
    assign mem_ren   = mem_ren_ex;
    assign mem_we    = mem_we_ex;
    assign mem_wdata = vs3_data_ex;
    assign width     = funct3_ex;

    always_comb begin
        case (op_sel_mem)
            3'b001:  reg_wdata_ex2 = vec_out_mem;
            3'b010:  reg_wdata_ex2 = mat_out_mem;
            3'b100:  reg_wdata_ex2 = mfu_out_mem;
            default: reg_wdata_ex2 = '0;
        endcase
    end

    assign reg_wdata_mem = mem_ren_mem ? mem_rdata : reg_wdata_ex2;

    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) reg_wdata_mem2wb (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_wdata_mem), .out(reg_wdata_wb));
    dff #(5, 1, 1) addr_d_mem2wb (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vd_addr_mem), .out(vd_addr_wb));
    dff #(1, 1, 1) reg_we_mem2wb (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_we_mem), .out(reg_we_wb));

endmodule

