`define LOAD_FP  7'b00_000_01
`define STORE_FP 7'b01_000_01

module decoder #(
  parameter DATA_WIDTH = 32,
  parameter LEN = 16,
  parameter INSTRUCTION_WIDTH = 32,
  parameter MEM_ADDR_WIDTH = 12
)
(
  input [INSTRUCTION_WIDTH - 1 : 0] instr,

  output logic [4 : 0] fpu_opcode,
  output logic [4 : 0] vd_addr,
  output logic [4 : 0] vs1_addr,
  output logic [4 : 0] vs2_addr,
  output logic [4 : 0] vs3_addr,
  output logic [3 : 0] imm,
  output logic vm,
  output logic fpu_src,

  output logic mem_we,
  output logic mem_read,
  output logic [2 : 0] mem_width,
  output logic [MEM_ADDR_WIDTH - 1 : 0] mem_addr,
  output logic reg_we,

  input logic [4 : 0] vd_addr_ex,
  input logic reg_we_ex,
  output logic stall
);

  logic [6 : 0] opcode;

  // Instruction Fields
  assign vs3_addr = instr[31 : 27];
  assign vs2_addr = instr[25 : 21];
  assign vs1_addr = mem_we | mem_read ? vd_addr : instr[20 : 16];
  assign imm = instr[15 : 12];
  assign vd_addr = instr[11 : 7];
  assign opcode = instr[6 : 0];

  assign fpu_opcode = opcode[6 : 2];
  assign vm = mem_we | mem_read ? instr[19] : instr[26];

  assign fpu_src = opcode[1:0] == 2'b00;

  // Load and Store
  assign mem_addr = instr[31 : 20];
  assign width = instr[18 : 16]; // Only support 32 bits (010) rn

  assign mem_we = opcode == `STORE_FP;
  assign mem_read = opcode == `LOAD_FP;
  assign reg_we = ~mem_we;

  assign stall = (vs1_addr == vd_addr_ex | vs2_addr == vd_addr_ex | vs3_addr == vd_addr_ex) & reg_we_ex;

endmodule
