module mvp_core #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter LEN = 16,
  parameter INSTRUCTION_WIDTH = 32,
  parameter MEM_ADDR_WIDTH = 12,
  parameter REG_BANK_DEPTH = 32,
  parameter REG_BANK_ADDR_WIDTH = 5
)(
  input clk,
  input rst_n,
  input en,

  input [INSTRUCTION_WIDTH - 1 : 0] instr,
  output instr_rdy,
  input instr_vld,

  output mem_write_en,
  output mem_read_en,
  output [MEM_ADDR_WIDTH : 0] mem_addr,
  output [SIG_WIDTH + EXP_WIDTH : 0] mem_write_data,
  input [SIG_WIDTH + EXP_WIDTH : 0] mem_read_data,

  output data_out_vld,
  output [SIG_WIDTH + EXP_WIDTH : 0] data_out [LEN - 1 : 0]
);

  logic [INSTRUCTION_WIDTH - 1 : 0] instr_r;
  logic instr_vld_r;
  logic stall;
  logic rst_id;
  logic [4 : 0] fpu_opcode_id, fpu_opcode_ex;
  logic [3 : 0] imm_id, imm_ex, imm_mem;
  logic [4 : 0] vd_addr_id, vd_addr_ex, vd_addr_mem, vd_addr_wb;
  logic [4 : 0] vs1_addr_id, vs1_addr_ex;
  logic [4 : 0] vs2_addr_id, vs2_addr_ex;
  logic [4 : 0] vs3_addr_id, vs3_addr_ex;
  logic forward_vs1, forward_vs2, forward_vs3;
  logic reg_we_id, reg_we_ex, reg_we_mem, reg_we_wb;
  logic mem_we_id, mem_we_ex;
  logic mem_read_id, mem_read_ex;
  logic [MEM_ADDR_WIDTH - 1 : 0] mem_addr_id, mem_addr_ex;
  logic fpu_src_id, fpu_src_ex;

  logic [SIG_WIDTH + EXP_WIDTH : 0] vs1_data_id [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vs2_data_id [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vs3_data_id [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] vs1_data_ex [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vs2_data_ex [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] vs3_data_ex [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_op1 [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_op2 [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_op3 [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_out [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_result_ex [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_result_mem [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] reg_write_data_mem [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] reg_write_data_wb [LEN - 1 : 0];

  assign instr_rdy = ~stall;
  assign rst_id = instr_vld_r & ~stall;
  assign data_out = reg_write_data_wb;
  assign data_out_vld = reg_we_wb;

  always @(posedge clk) begin
    if (!rst_n) begin
      instr_r <= 1'b0;
      instr_vld_r <= 1'b0;
    end
    else if (instr_rdy) begin
      instr_r <= instr;
      instr_vld_r <= instr_vld;
    end
  end

  decoder #(
    .DATA_WIDTH(SIG_WIDTH + EXP_WIDTH + 1),
    .LEN(LEN),
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
    .MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
  ) decoder_inst (
    .instr(instr_r),
    .vm(),
    .imm(imm_id),
    .fpu_opcode(fpu_opcode_id),
    .vd_addr(vd_addr_id),
    .vs1_addr(vs1_addr_id),
    .vs2_addr(vs2_addr_id),
    .vs3_addr(vs3_addr_id),
    .fpu_src(fpu_src_id),
    .mem_we(mem_we_id),
    .mem_read(mem_read_id),
    .mem_width(),
    .mem_addr(mem_addr_id),
    .reg_we(reg_we_id),
    .vd_addr_ex(vd_addr_ex),
    .reg_we_ex(reg_we_ex),
    .stall(stall)
  );

  register_file #(
    .LEN(LEN),
    .DATA_WIDTH(SIG_WIDTH + EXP_WIDTH + 1),
    .ADDR_WIDTH(REG_BANK_ADDR_WIDTH),
    .DEPTH(REG_BANK_DEPTH)
  ) register_file_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(reg_we_wb),
    .addr_w(vd_addr_wb),
    .data_w(reg_write_data_wb),
    .addr_r1(vs1_addr_id),
    .data_r1(vs1_data_id),
    .addr_r2(vs2_addr_id),
    .data_r2(vs2_data_id),
    .addr_r3(vs3_addr_id),
    .data_r3(vs3_data_id)
  );

  dff #(1, 1, 1) reg_we_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_we_id & rst_id), .out(reg_we_ex));
  dff #(5, 1, 1) vs1_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs1_addr_id), .out(vs1_addr_ex));
  dff #(5, 1, 1) vs2_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs2_addr_id), .out(vs2_addr_ex));
  dff #(5, 1, 1) vs3_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs3_addr_id), .out(vs3_addr_ex));
  dff #(5, 1, 1) vd_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vd_addr_id), .out(vd_addr_ex));
  dff #(1, 1, 1) fpu_src_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_src_id & rst_id), .out(fpu_src_ex));

  dff #(5, 1, 1) fpu_opcode_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_opcode_id), .out(fpu_opcode_ex));
  dff #(4, 1, 1) imm_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(imm_id), .out(imm_ex));
  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) vs1_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs1_data_id), .out(vs1_data_ex));
  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) vs2_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs2_data_id), .out(vs2_data_ex));
  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) vs3_data_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(vs3_data_id), .out(vs3_data_ex));

  dff #(1, 1, 1) mem_we_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_we_id & rst_id), .out(mem_we_ex));
  dff #(1, 1, 1) mem_read_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_read_id & rst_id), .out(mem_read_ex));
  dff #(MEM_ADDR_WIDTH, 1, 1) mem_addr_id2ex (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_addr_id), .out(mem_addr_ex));

  // Execute Stage

  // Forwarding logic
  assign forward_vs1 = vs1_addr_ex == vd_addr_wb & reg_we_wb;
  assign forward_vs2 = vs2_addr_ex == vd_addr_wb & reg_we_wb;
  assign forward_vs3 = vs3_addr_ex == vd_addr_wb & reg_we_wb;

  assign fpu_op1 = forward_vs1 ? reg_write_data_wb : vs1_data_ex;
  assign fpu_op2 = forward_vs2 ? reg_write_data_wb : vs2_data_ex;
  assign fpu_op3 = forward_vs3 ? reg_write_data_wb : vs3_data_ex;

  fpu #(
    .LEN(LEN),
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
  ) fpu_inst (
    .en(fpu_src_ex),
    .opcode(fpu_opcode_ex),
    .data_a(fpu_op1),
    .data_b(fpu_op2),
    .data_c(fpu_op3),
    .index(imm_ex),
    .predicate(),
    .data_out(fpu_out)
  );

  assign fpu_result_ex = fpu_src_ex ? fpu_out : vs1_data_ex;

  dff2 #(32, LEN, 1, 0) fpu_result_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_result_ex), .out(fpu_result_mem));
  dff #(5, 1, 1) addr_d_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(vd_addr_ex), .out(vd_addr_mem));
  dff #(4, 1, 1) imm_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(imm_ex), .out(imm_mem));
  dff #(1, 1, 1) mem_read_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(mem_read_ex), .out(mem_read_mem));
  dff #(1, 1, 1) reg_we_ex2mem (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_we_ex), .out(reg_we_mem));

  assign mem_read_en = mem_read_ex;
  assign mem_addr = mem_addr_ex;
  assign mem_write_data = vs2_data_ex[imm_ex];

  for (genvar i = 0; i < LEN; i = i + 1) begin
    assign reg_write_data_mem[i] = (mem_read_mem & i == imm_mem) ? mem_read_data : fpu_result_mem[i];
  end

  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) reg_write_data_mem2wb (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_write_data_mem), .out(reg_write_data_wb));
  dff #(1, 1, 1) reg_we_mem2wb (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_we_mem), .out(reg_we_wb));
  dff #(REG_BANK_ADDR_WIDTH, 1, 1) addr_d_mem2wb (.clk(clk), .rst_n(rst_n), .en(en), .in(vd_addr_mem), .out(vd_addr_wb));

endmodule

