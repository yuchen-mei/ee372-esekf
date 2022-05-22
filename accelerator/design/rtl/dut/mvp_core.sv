module mvp_core #(
    parameter SIG_WIDTH           = 23,
    parameter EXP_WIDTH           = 8,
    parameter IEEE_COMPLIANCE     = 0,
    parameter VECTOR_LANES        = 16,
    parameter INSTR_ADDR_WIDTH    = 8,
    parameter GLB_MEM_ADDR_WIDTH  = 12,
    parameter REG_BANK_DEPTH      = 32,
    parameter REG_BANK_ADDR_WIDTH = $clog2(REG_BANK_DEPTH),
    parameter DATA_WIDTH          = SIG_WIDTH + EXP_WIDTH + 1
)(
    input  logic                               clk,
    input  logic                               rst_n,
    input  logic                               en,

    output logic [       INSTR_ADDR_WIDTH-1:0] pc,
    input  logic [                       31:0] instr,

    output logic                               mem_write_en,
    output logic                               mem_read_en,
    output logic [                       11:0] mem_addr,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_write_data,
    input  logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_read_data,

    output logic                               data_out_vld,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] data_out,
    output logic [                        4:0] reg_wb
);

    logic                        rst_id;
    logic                        en_q;
    logic                        en_pl;
    logic                        en_if;
    logic [INSTR_ADDR_WIDTH-1:0] pc;
    logic [                31:0] instr_sav;
    logic [                31:0] instr_id;
    logic                        stall;
    logic                        stall_r;

    logic [             4:0]                 fpu_opcode_id;
    logic [             4:0]                 fpu_opcode_ex;
    logic [             2:0]                 funct3_id;
    logic [             2:0]                 funct3_ex;
    logic                                    fpu_src_id;
    logic                                    fpu_src_ex;
    logic [             4:0]                 vd_addr_id;
    logic [             4:0]                 vd_addr_ex;
    logic [             4:0]                 vd_addr_mem;
    logic [             4:0]                 vd_addr_wb;
    logic [             4:0]                 vs1_addr_id;
    logic [             4:0]                 vs1_addr_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_in;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs1_data_ex;
    logic [             4:0]                 vs2_addr_id;
    logic [             4:0]                 vs2_addr_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs2_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs2_data_ex;
    logic [             4:0]                 vs3_addr_id;
    logic [             4:0]                 vs3_addr_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs3_data_id;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vs3_data_ex;
    logic                                    reg_we_id;
    logic                                    reg_we_ex;
    logic                                    reg_we_mem;
    logic                                    reg_we_wb;
    logic                                    mem_we_id;
    logic                                    mem_we_ex;
    logic                                    mem_read_id;
    logic                                    mem_read_ex;
    logic                                    mem_read_mem;
    logic [            11:0]                 mem_addr_id;
    logic [            11:0]                 mem_addr_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_write_data_mem;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] reg_write_data_wb;

    assign en_if        = ~stall & en;
    assign rst_id       = stall & en;
    assign en_pl        = en & en_q;

    assign data_out     = reg_write_data_wb;
    assign data_out_vld = reg_we_wb;
    assign reg_wb       = vd_addr_wb;

    always @(posedge clk) begin
        en_q <= en;
    end

    instruction_fetch #(
        .ADDR_WIDTH(INSTR_ADDR_WIDTH)
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
    assign instr_id = (stall_r) ? instr_sav : instr;

    //=======================================================
    // Instruction Decode Stage
    //=======================================================

    decoder decoder_inst (
        .instr      (instr_id     ),
        .fpu_opcode (fpu_opcode_id),
        // Instruction out
        .vd_addr    (vd_addr_id   ),
        .vs1_addr   (vs1_addr_id  ),
        .vs2_addr   (vs2_addr_id  ),
        .vs3_addr   (vs3_addr_id  ),
        .funct3     (funct3_id    ),
        .imm        (             ),
        .masking    (             ),
        .fpu_src    (fpu_src_id   ),
        // Memory instruction
        .mem_we     (mem_we_id    ),
        .mem_read   (mem_read_id  ),
        .width      (),  
        .mem_addr   (mem_addr_id  ),
        .reg_we     (reg_we_id    ),
        // Control logic
        .vd_addr_ex (vd_addr_ex   ),
        .reg_we_ex  (reg_we_ex    ),
        .stall      (stall        )
    );

    register_file #(
        .ADDR_WIDTH (REG_BANK_ADDR_WIDTH    ),
        .DEPTH      (REG_BANK_DEPTH         ),
        .DATA_WIDTH (VECTOR_LANES*DATA_WIDTH)
    ) register_file_inst (
        .clk        (clk              ),
        .rst_n      (rst_n            ),
        // Write Port
        .wen        (reg_we_wb        ),
        .addr_w     (vd_addr_wb       ),
        .data_w     (reg_write_data_wb),
        // Read Port
        .addr_r1    (vs1_addr_id      ),
        .data_r1    (vs1_data_in      ),
        .addr_r2    (vs2_addr_id      ),
        .data_r2    (vs2_data_id      ),
        .addr_r3    (vs3_addr_id      ),
        .data_r3    (vs3_data_id      )
    );

    assign vs1_data_id = (funct3_id == 3'b101) ? {VECTOR_LANES{vs1_data_in[0]}} : vs1_data_in;

    dff #(5, 1, 1) vd_addr_id2ex  (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vd_addr_id), .out(vd_addr_ex));
    dff #(5, 1, 1) vs1_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs1_addr_id), .out(vs1_addr_ex));
    dff #(5, 1, 1) vs2_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs2_addr_id), .out(vs2_addr_ex));
    dff #(5, 1, 1) vs3_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs3_addr_id), .out(vs3_addr_ex));
    dff #(3, 1, 1) funct3_id2ex   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(funct3_id), .out(funct3_ex));
    dff #(1, 1, 1) fpu_src_id2ex  (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(fpu_src_id & ~rst_id), .out(fpu_src_ex));
    dff #(1, 1, 1) reg_we_id2ex   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_we_id & ~rst_id), .out(reg_we_ex));

    dff #(5, 1, 1) fpu_opcode_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(fpu_opcode_id), .out(fpu_opcode_ex));
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vs1_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs1_data_id), .out(vs1_data_ex));
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vs2_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs2_data_id), .out(vs2_data_ex));
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vs3_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vs3_data_id), .out(vs3_data_ex));

    dff #(1, 1, 1)  mem_we_id2ex   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_we_id & ~rst_id), .out(mem_we_ex));
    dff #(1, 1, 1)  mem_read_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_read_id & ~rst_id), .out(mem_read_ex));
    dff #(12, 1, 1) mem_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_addr_id), .out(mem_addr_ex));

    //=======================================================
    // Execute Stage
    //=======================================================

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] fpu_op1;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] fpu_op2;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] fpu_op3;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out_mem;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mat_out_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mat_out_mem;
    logic                   [DATA_WIDTH-1:0] scalar_out_ex;
    logic                   [DATA_WIDTH-1:0] scalar_out_mem;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_permute_ex;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_permute_mem;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] fpu_result_mem;
    logic [             1:0]                 op_sel;

    assign fpu_op1 = ((vs1_addr_ex == vd_addr_wb) & reg_we_wb) ? reg_write_data_wb : vs1_data_ex;
    assign fpu_op2 = ((vs2_addr_ex == vd_addr_wb) & reg_we_wb) ? reg_write_data_wb : vs2_data_ex;
    assign fpu_op3 = ((vs3_addr_ex == vd_addr_wb) & reg_we_wb) ? reg_write_data_wb : vs3_data_ex;

    fpu #(
        .SIG_WIDTH      (SIG_WIDTH      ),
        .EXP_WIDTH      (EXP_WIDTH      ),
        .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
        .VECTOR_LANES   (VECTOR_LANES   )
    ) fpu_inst (
        .en        (fpu_src_ex   ),
        .opcode    (fpu_opcode_ex),
        .data_a    (fpu_op1      ),
        .data_b    (fpu_op2      ),
        .data_c    (fpu_op3      ),
        .predicate (             ),
        .vec_out   (vec_out_ex   ),
        .mat_out   (mat_out_ex   ),
        .scalar_out(scalar_out_ex)
    );

    vector_permute #(
        .DATA_WIDTH  (DATA_WIDTH  ),
        .VECTOR_LANES(VECTOR_LANES)
    ) vec_permuate_inst (
        .vec_in (fpu_op1           ),
        .func   (fpu_opcode_ex[2:0]),
        .width  (funct3_ex         ),
        .vec_out(vec_permute_ex    )
    );

    dff #(VECTOR_LANES*DATA_WIDTH, 1, 0) vec_out_ex2mem (
        .clk  (clk        ),
        .rst_n(rst_n      ),
        .en   (en_pl      ),
        .in   (vec_out_ex ),
        .out  (vec_out_mem)
    );
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 0) mat_out_ex2mem (
        .clk  (clk        ),
        .rst_n(rst_n      ),
        .en   (en_pl      ),
        .in   (mat_out_ex ),
        .out  (mat_out_mem)
    );
    dff #(DATA_WIDTH, 1, 0) scalar_out_ex2mem (
        .clk  (clk           ),
        .rst_n(rst_n         ),
        .en   (en_pl         ),
        .in   (scalar_out_ex ),
        .out  (scalar_out_mem)
    );
    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) vec_permute_ex2mem (
        .clk  (clk            ),
        .rst_n(rst_n          ),
        .en   (en_pl          ),
        .in   (vec_permute_ex ),
        .out  (vec_permute_mem)
    );

    dff #(2, 1, 1) opcode_ex2mem   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(fpu_opcode_ex[4:3]), .out(op_sel));
    dff #(5, 1, 1) addr_d_ex2mem   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vd_addr_ex), .out(vd_addr_mem));
    dff #(1, 1, 1) reg_we_ex2mem   (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_we_ex), .out(reg_we_mem));
    dff #(1, 1, 1) mem_read_ex2mem (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(mem_read_ex), .out(mem_read_mem));

    //=======================================================
    // Memroy and Ex2 Stage
    //=======================================================

    always_comb begin
        casez (op_sel)
            2'b00:   fpu_result_mem = vec_out_mem;
            2'b01:   fpu_result_mem = mat_out_mem;
            2'b10:   fpu_result_mem = {fpu_op1[VECTOR_LANES-1:1], scalar_out_mem};
            default: fpu_result_mem = vec_permute_mem;
        endcase
    end

    assign mem_write_en = mem_we_ex;
    assign mem_read_en  = mem_read_ex;
    assign mem_addr     = mem_addr_ex;

    // TODO: Write memory with masking
    assign mem_write_data = vs3_data_ex;

    // TODO: Read memory with different width
    assign reg_write_data_mem = mem_read_mem ? mem_read_data : fpu_result_mem;

    dff #(VECTOR_LANES*DATA_WIDTH, 1, 1) reg_write_data_mem2wb (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_write_data_mem), .out(reg_write_data_wb));
    dff #(1, 1, 1) reg_we_mem2wb (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(reg_we_mem), .out(reg_we_wb));
    dff #(5, 1, 1) addr_d_mem2wb (.clk(clk), .rst_n(rst_n), .en(en_pl), .in(vd_addr_mem), .out(vd_addr_wb));

endmodule

