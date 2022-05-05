module mvp_core #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,
  parameter MATRIX_HEIGHT = 3,
  parameter MATRIX_WIDTH = 3,
  parameter LEN = 9,
  parameter INSTRUCTION_WIDTH = 32,
  parameter ADDR_WIDTH = 5,
  parameter DEPTH = 32
)(
  input clk,
  input rst_n,
  input en,

  input [INSTRUCTION_WIDTH - 1 : 0] instr,
  output instr_rdy,
  input instr_vld,

  // output addr_mem,
  // output addr_mem_vld,
  // input data_mem,

  output data_out_vld,
  output [SIG_WIDTH + EXP_WIDTH : 0] data_out [LEN - 1 : 0]
);

  logic [INSTRUCTION_WIDTH - 1 : 0] instr_r;
  logic instr_vld_id, instr_vld_ex1, instr_vld_ex2, instr_vld_wb;
  logic [7 : 0] fpu_opcode_id, fpu_opcode_ex1;
  logic [3 : 0] vec_index_id, vec_index_ex1;
  logic [ADDR_WIDTH - 1 : 0] addr_d_id, addr_d_ex1, addr_d_ex2, addr_d_wb;
  logic [ADDR_WIDTH - 1 : 0] addr_a_id, addr_a_ex1;
  logic [ADDR_WIDTH - 1 : 0] addr_n_id, addr_n_ex1;
  logic [ADDR_WIDTH - 1 : 0] addr_m_id, addr_m_ex1;
  logic forward_za, forward_zn, forward_zm;
  logic za_ex2_dependency, zn_ex2_dependency, zm_ex2_dependency, stall;

  logic [SIG_WIDTH + EXP_WIDTH : 0] data_n_id [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_m_id [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_a_id [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] data_n_ex [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_m_ex [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_a_ex [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] data_a [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_n [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] data_m [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] fpu_out [LEN - 1 : 0];

  logic [SIG_WIDTH + EXP_WIDTH : 0] reg_write_data_ex2 [LEN - 1 : 0];
  logic [SIG_WIDTH + EXP_WIDTH : 0] reg_write_data_wb [LEN - 1 : 0];

  assign data_out = reg_write_data_wb;
  assign data_out_vld = instr_vld_wb;
  assign instr_rdy = ~stall;

  always @(posedge clk) begin
    if (!rst_n) begin
      instr_r <= 'b0;
      instr_vld_id <= 'b0;
    end
    else if (instr_rdy) begin
      instr_r <= instr;
      instr_vld_id <= instr_vld;
    end
  end

  // Instruction fetch

  // Instruction decode and register fetch
  
  assign addr_d_id = instr_r[4:0];
  assign addr_a_id = instr_r[9:5];
  assign addr_n_id = instr_r[14:10];
  assign addr_m_id = instr_r[19:15];
  assign vec_index_id = instr_r[23:20];
  assign fpu_opcode_id = instr_r[31:24];

  register_file #(
    .LEN(LEN),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DEPTH(DEPTH),
    .DATA_WIDTH(SIG_WIDTH + EXP_WIDTH + 1)
  ) register_file_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(instr_vld_wb),
    .addr_w(addr_d_wb),
    .data_w(reg_write_data_wb),
    .addr_r1(addr_n_id),
    .data_r1(data_n_id),
    .addr_r2(addr_m_id),
    .data_r2(data_m_id),
    .addr_r3(addr_a_id),
    .data_r3(data_a_id)
  );

  dff #(1, 1, 1) instr_vld_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(instr_vld_id), .out(instr_vld_ex1));
  dff #(ADDR_WIDTH, 1, 1) addr_d_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(addr_d_id), .out(addr_d_ex1));
  dff #(ADDR_WIDTH, 1, 1) addr_a_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(addr_a_id), .out(addr_a_ex1));
  dff #(ADDR_WIDTH, 1, 1) addr_n_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(addr_n_id), .out(addr_n_ex1));
  dff #(ADDR_WIDTH, 1, 1) addr_m_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(addr_m_id), .out(addr_m_ex1));

  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) data_n_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(data_n_id), .out(data_n_ex));
  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) data_m_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(data_m_id), .out(data_m_ex));
  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) data_a_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(data_a_id), .out(data_a_ex));
  dff #(8, 1, 1) fpu_opcode_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(fpu_opcode_id), .out(fpu_opcode_ex1));
  dff #(4, 1, 1) vec_index_id2ex1 (.clk(clk), .rst_n(rst_n), .en(en & ~stall), .in(vec_index_id), .out(vec_index_ex1));

  // Execute

  assign forward_zn = (addr_n_ex1 == addr_d_wb) & instr_vld_wb;
  assign forward_zm = (addr_m_ex1 == addr_d_wb) & instr_vld_wb;
  assign forward_za = (addr_a_ex1 == addr_d_wb) & instr_vld_wb;

  assign data_n = forward_zn ? reg_write_data_wb : data_n_ex;
  assign data_m = forward_zm ? reg_write_data_wb : data_m_ex;
  assign data_a = forward_za ? reg_write_data_wb : data_a_ex;

  assign za_ex2_dependency = addr_a_ex1 == addr_d_ex2;
  assign zn_ex2_dependency = addr_n_ex1 == addr_d_ex2;
  assign zm_ex2_dependency = addr_m_ex1 == addr_d_ex2;

  assign stall = (za_ex2_dependency | zn_ex2_dependency | zm_ex2_dependency) && instr_vld_ex2;

  fpu #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .MATRIX_HEIGHT(MATRIX_HEIGHT),
    .MATRIX_WIDTH(MATRIX_WIDTH),
    .LEN(LEN)
  ) fpu_inst (
    .en(instr_vld_ex1),
    .opcode(fpu_opcode_ex1),
    .data_n(data_n),
    .data_m(data_m),
    .data_a(data_a),
    .index(vec_index_ex1),
    .predicate(),
    .data_out(fpu_out)
  );

  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 0) data_out_ex12ex2 (.clk(clk), .rst_n(rst_n), .en(en), .in(fpu_out), .out(reg_write_data_ex2));
  dff #(1, 1, 0) instr_vld_ex12ex2 (.clk(clk), .rst_n(rst_n), .en(en), .in(instr_vld_ex1 & ~stall), .out(instr_vld_ex2));
  dff #(ADDR_WIDTH, 1, 0) addr_d_ex12ex2 (.clk(clk), .rst_n(rst_n), .en(en), .in(addr_d_ex1), .out(addr_d_ex2));

  dff2 #(SIG_WIDTH + EXP_WIDTH + 1, LEN, 1, 1) data_out_ex22wb (.clk(clk), .rst_n(rst_n), .en(en), .in(reg_write_data_ex2), .out(reg_write_data_wb));
  dff #(1, 1, 1) instr_vld_ex22wb (.clk(clk), .rst_n(rst_n), .en(en), .in(instr_vld_ex2), .out(instr_vld_wb));
  dff #(ADDR_WIDTH, 1, 1) addr_d_ex22wb (.clk(clk), .rst_n(rst_n), .en(en), .in(addr_d_ex2), .out(addr_d_wb));

endmodule

