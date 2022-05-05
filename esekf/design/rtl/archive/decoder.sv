// module decoder #(
//   parameter INSTRUCTION_WIDTH = 32,
//   parameter ADDR_WIDTH = 5
// )(
//   input [INSTRUCTION_WIDTH - 1 : 0] instr,

//   output [ADDR_WIDTH - 1 : 0] addr_da,
//   output [ADDR_WIDTH - 1 : 0] addr_n,
//   output [ADDR_WIDTH - 1 : 0] addr_m,
//   output [4 : 0] index,
//   output [4 : 0] addr_p,
//   output logic [7 : 0] opcode,

// );

//   assign addr_da = instr[4:0];
//   assign addr_n = instr[9:5];
//   assign addr_m = instr[14:10];
//   assign index = instr[18:15];
//   assign addr_p = instr[23:19];
//   assign opcode = instr[31:24];

//   logic [15:0] immediate = instr[15:0];

// endmodule

