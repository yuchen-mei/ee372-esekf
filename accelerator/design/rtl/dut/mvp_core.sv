module mvp_core #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 16,
  parameter REG_BANK_DEPTH = 32,
  parameter REG_BANK_ADDR_WIDTH = $clog2(REG_BANK_DEPTH),
  parameter INSTR_BANK_ADDR_WIDTH = 10,
  parameter GLB_MEM_ADDR_WIDTH = 12
)(
  input clk,
  input rst_n,
  input en,

  output [INSTR_BANK_ADDR_WIDTH - 1 : 0] pc,
  input [31 : 0] instr,

  output mem_write_en,
  output mem_read_en,
  output [GLB_MEM_ADDR_WIDTH - 1 : 0] mem_addr,
  output [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] mem_write_data,
  input  [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] mem_read_data,

  output data_out_vld,
  output [LEN * (SIG_WIDTH + EXP_WIDTH + 1) - 1 : 0] data_out,
  output [4 : 0] reg_wb
);

  localparam DATA_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;

  logic [INSTR_BANK_ADDR_WIDTH - 1 : 0] pc_if, pc_id;
  logic [31 : 0] instr_sav, instr_id;
  logic [4 : 0] fpu_opcode_id, fpu_opcode_ex;
  logic [2 : 0] funct3_id, funct3_ex;
  logic [4 : 0] vd_addr_id, vd_addr_ex, vd_addr_mem, vd_addr_wb;
  logic [4 : 0] vs1_addr_id, vs1_addr_ex;
  logic [4 : 0] vs2_addr_id, vs2_addr_ex;
  logic [4 : 0] vs3_addr_id, vs3_addr_ex;
  logic forward_vs1, forward_vs2, forward_vs3;
  logic reg_we_id, reg_we_ex, reg_we_mem, reg_we_wb;
  logic mem_we_id, mem_we_ex;
  logic mem_read_id, mem_read_ex, mem_read_mem;
  logic [GLB_MEM_ADDR_WIDTH - 1 : 0] mem_addr_id, mem_addr_ex;
  logic fpu_src_id, fpu_src_ex;
  logic stall, stall_r;
  logic en_if;
  logic rst_id;

  logic [LEN*DATA_WIDTH - 1 : 0] vs1_data, vs1_data_id, vs2_data_id, vs3_data_id;
  logic [LEN*DATA_WIDTH - 1 : 0] vs1_data_ex, vs2_data_ex, vs3_data_ex;

  logic [LEN*DATA_WIDTH - 1 : 0] fpu_op1, fpu_op2, fpu_op3;
  logic [LEN*DATA_WIDTH - 1 : 0] fpu_out, vec_permute;
  logic [LEN*DATA_WIDTH - 1 : 0] fpu_result_ex;
  logic [LEN*DATA_WIDTH - 1 : 0] fpu_result_mem;

  logic [LEN*DATA_WIDTH - 1 : 0] reg_write_data_mem;
  logic [LEN*DATA_WIDTH - 1 : 0] reg_write_data_wb;

  assign en_if = ~stall & en;
  assign rst_id = stall & en;

  assign data_out = reg_write_data_wb;
  assign data_out_vld = reg_we_wb;
  assign reg_wb = vd_addr_wb;

  instruction_fetch #(
    .ADDR_WIDTH(INSTR_BANK_ADDR_WIDTH)
  ) if_stage
  (
    .clk           (clk),
    .rst_n         (rst_n),
    .en            (en_if),
    // .jump_target   (jump_target_id),
    // .instr_id      (instr_id[25:0]),

    // .branch        (jump_branch_id),
    // .branch_offset (branch_offset_id),

    // .jump_reg      (jump_reg_id),
    // .jr_pc         (jr_pc_id),

    .pc            (pc_if)
  );

  assign pc = pc_if; // output pc to parent module

  // needed for D stage
  dff #(INSTR_BANK_ADDR_WIDTH, 1, 1) pc_if2id (.clk(clk), .rst_n(rst_n), .en(en_if), .in(pc_if), .out(pc_id));

  // Saved ID instruction after a stall
  dff #(32, 1, 1) instr_sav_dff (.clk(clk), .rst_n(rst_n), .en(en), .in(instr), .out(instr_sav));
  dff #(1, 1, 1) stall_f_dff (.clk(clk), .rst_n(rst_n), .en(en), .in(stall), .out(stall_r));
  assign instr_id = (stall_r) ? instr_sav : instr;

  decoder #(
    .ADDR_WIDTH(GLB_MEM_ADDR_WIDTH)
  ) decoder_inst (
    .instr      (instr_id),
    .fpu_opcode (fpu_opcode_id),
    
    .vd_addr    (vd_addr_id),
    .vs1_addr   (vs1_addr_id),
    .vs2_addr   (vs2_addr_id),
    .vs3_addr   (vs3_addr_id),
    .funct3     (funct3_id),
    .imm        (),
    .masking    (),
    .fpu_src    (fpu_src_id),

    .mem_we     (mem_we_id),
    .mem_read   (mem_read_id),
    .width      (),
    .mem_addr   (mem_addr_id),
    .reg_we     (reg_we_id),

    .vd_addr_ex (vd_addr_ex),
    .reg_we_ex  (reg_we_ex),
    .stall      (stall)
  );

  register_file #(
    .DATA_WIDTH (LEN*DATA_WIDTH),
    .ADDR_WIDTH (REG_BANK_ADDR_WIDTH),
    .DEPTH      (REG_BANK_DEPTH)
  ) register_file_inst (
    .clk        (clk),
    .rst_n      (rst_n),
    .wen        (reg_we_wb),
    .addr_w     (vd_addr_wb),
    .data_w     (reg_write_data_wb),
    .addr_r1    (vs1_addr_id),
    .data_r1    (vs1_data),
    .addr_r2    (vs2_addr_id),
    .data_r2    (vs2_data_id),
    .addr_r3    (vs3_addr_id),
    .data_r3    (vs3_data_id)
  );

  assign vs1_data_id = (funct3_id[2] == 3'b101) ? {LEN{vs1_data[0]}} : vs1_data;

  dff #(5, 1, 1) vd_addr_id2ex  (.clk(clk), .rst_n(rst_n), .en(en), .in(vd_addr_id), .out(vd_addr_ex));
  dff #(5, 1, 1) vs1_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs1_addr_id), .out(vs1_addr_ex));
  dff #(5, 1, 1) vs2_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs2_addr_id), .out(vs2_addr_ex));
  dff #(5, 1, 1) vs3_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs3_addr_id), .out(vs3_addr_ex));
  dff #(3, 1, 1) funct3_id2ex   (.clk(clk), .rst_n(rst_n), .en(en), .in(funct3_id), .out(funct3_ex));
  dff #(1, 1, 1) fpu_src_id2ex  (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_src_id), .out(fpu_src_ex));
  dff #(1, 1, 1) reg_we_id2ex   (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_we_id & ~rst_id), .out(reg_we_ex));

  dff #(5, 1, 1) fpu_opcode_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_opcode_id), .out(fpu_opcode_ex));
  dff #(LEN*DATA_WIDTH, 1, 1) vs1_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs1_data_id), .out(vs1_data_ex));
  dff #(LEN*DATA_WIDTH, 1, 1) vs2_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs2_data_id), .out(vs2_data_ex));
  dff #(LEN*DATA_WIDTH, 1, 1) vs3_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs3_data_id), .out(vs3_data_ex));

  dff #(1, 1, 1) mem_we_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_we_id & ~rst_id), .out(mem_we_ex));
  dff #(1, 1, 1) mem_read_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_read_id & ~rst_id), .out(mem_read_ex));
  dff #(GLB_MEM_ADDR_WIDTH, 1, 1) mem_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_addr_id), .out(mem_addr_ex));

  // Forwarding logic
  assign forward_vs1 = vs1_addr_ex == vd_addr_wb & reg_we_wb;
  assign forward_vs2 = vs2_addr_ex == vd_addr_wb & reg_we_wb;
  assign forward_vs3 = vs3_addr_ex == vd_addr_wb & reg_we_wb;

  assign fpu_op1 = forward_vs1 ? reg_write_data_wb : vs1_data_ex;
  assign fpu_op2 = forward_vs2 ? reg_write_data_wb : vs2_data_ex;
  assign fpu_op3 = forward_vs3 ? reg_write_data_wb : vs3_data_ex;

  fpu #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .LEN(LEN)
  ) fpu_inst (
    .en        (fpu_src_ex),
    .opcode    (fpu_opcode_ex),
    .data_a    (fpu_op1),
    .data_b    (fpu_op2),
    .data_c    (fpu_op3),
    .predicate (),
    .data_out  (fpu_out)
  );

  vector_permute #(DATA_WIDTH, LEN) vec_permuate_inst (
    .src(fpu_op1), .func(fpu_opcode_ex[2:0]), .width(funct3_ex), .vec_out(vec_permute));

  assign fpu_result_ex = fpu_src_ex ? fpu_out : vec_permute;

  dff #(LEN*DATA_WIDTH, 1, 0) fpu_result_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_result_ex), .out(fpu_result_mem));
  dff #(5, 1, 1) addr_d_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(vd_addr_ex), .out(vd_addr_mem));
  dff #(1, 1, 1) mem_read_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_read_ex), .out(mem_read_mem));
  dff #(1, 1, 1) reg_we_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_we_ex), .out(reg_we_mem));

  assign mem_read_en = mem_read_ex;
  assign mem_addr = mem_addr_ex;

  // TODO: Write memory with masking
  assign mem_write_data = vs3_data_ex;

  // TODO: Read memory with different width
  assign reg_write_data_mem = mem_read_mem ? mem_read_data : fpu_result_mem;

  dff #(LEN*DATA_WIDTH, 1, 1) reg_write_data_mem2wb (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_write_data_mem), .out(reg_write_data_wb));
  dff #(1, 1, 1) reg_we_mem2wb (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_we_mem), .out(reg_we_wb));
  dff #(REG_BANK_ADDR_WIDTH, 1, 1) addr_d_mem2wb (.clk(clk), .rst_n(rst_n), .en(en), .in(vd_addr_mem), .out(vd_addr_wb));

endmodule

