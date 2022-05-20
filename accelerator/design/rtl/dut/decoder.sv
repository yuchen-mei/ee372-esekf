`define LOAD_FP  7'b0000001
`define STORE_FP 7'b0100001

module decoder #(
  parameter ADDR_WIDTH = 10
)
(
  input [31 : 0] instr,

  output wire [4 : 0] fpu_opcode,
  output wire [4 : 0] vd_addr,
  output wire [4 : 0] vs1_addr,
  output wire [4 : 0] vs2_addr,
  output wire [4 : 0] vs3_addr,
  output wire [2 : 0] funct3,
  output wire [3 : 0] imm,
  output wire masking,
  output wire fpu_src,

  output logic mem_we,
  output logic mem_read,
  output logic [2 : 0] width,
  output logic [ADDR_WIDTH - 1 : 0] mem_addr,
  output logic reg_we,

  input logic [4 : 0] vd_addr_ex,
  input logic reg_we_ex,
  output logic stall
);

  wire [6 : 0] opcode;
  wire [5 : 0] funct6;

  // RVV Instruction Fields
  assign opcode   = instr[6  : 0 ];
  assign vd_addr  = instr[11 : 7 ];
  assign funct3   = instr[14 : 12];
  assign vs1_addr = instr[19 : 15];
  assign vs2_addr = instr[24 : 20];
  assign funct6   = instr[31 : 26];

  // Third operand
  assign vs3_addr = (mem_we) ? vd_addr : instr[31 : 27];

  // always @(*) begin
  //   casex ({opcode, funct6})
  //     {`OP_V, `VFADD}:    fpu_opcode = `FPU_ADD;
  //     {`OP_V, `VFSUB}:    fpu_opcode = `FPU_SUB;
  //     {`OP_V, `VFMUL}:    fpu_opcode = `FPU_MUL;
  //     {`OP_V, `VFMADD}:   fpu_opcode = `FPU_FMA;
  //     {`OP_V, `VFNMADD}:  fpu_opcode = `FPU_NFMA;
  //     {`OP_V, `VFMSUB}:   fpu_opcode = `FPU_FMS;
  //     {`OP_V, `VFNMSUB}:  fpu_opcode = `FPU_NFMS;
  //   endcase
  // end

  assign fpu_opcode = opcode[6 : 2];
  assign masking = (mem_we | mem_read) ? instr[19] : instr[26];
  assign fpu_src = (opcode[6:5] != 2'b11) && (opcode[1:0] == 2'b00);

  // Load and Store
  assign mem_addr = instr[31 : 20];
  assign imm = instr[18 : 15];
  assign width = instr[14 : 12];

  assign mem_we = opcode == `STORE_FP;
  assign mem_read = opcode == `LOAD_FP;
  assign reg_we = ~mem_we;

  assign stall = (vs1_addr == vd_addr_ex | vs2_addr == vd_addr_ex | vs3_addr == vd_addr_ex) & reg_we_ex;

endmodule
