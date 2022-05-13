module accelerator_top #(
  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,

  parameter MATRIX_HEIGHT = 3,
  parameter MATRIX_WIDTH = 3,
  parameter LEN = 9,

  parameter WEIGHT_BANK_ADDR_WIDTH = 8, // Should be ceil(log2(WEIGHT_BANK_DEPTH))
  parameter WEIGHT_BANK_DEPTH = 256,

  parameter CONFIG_DATA_WIDTH = 8,
  parameter CONFIG_ADDR_WIDTH = 8,

  parameter INSTRUCTION_WIDTH = 32,
  parameter ADDR_WIDTH = 5,
  parameter DEPTH = 32
)(
  input clk,
  input rst_n,

  input [IFMAP_FIFO_WORDS*IFMAP_WIDTH - 1 : 0] ifmap_data,
  output ifmap_rdy,
  input ifmap_vld,

  output [OFMAP_WIDTH - 1 : 0] ofmap_data,
  input ofmap_rdy,
  output logic ofmap_vld,

  input [CONFIG_ADDR_WIDTH + CONFIG_DATA_WIDTH - 1: 0] config_data,
  output logic config_rdy,
  input config_vld
);

  logic config_en;

  // TODO: Instantiate global memory here

  adr_gen_sequential #( 
    .BANK_ADDR_WIDTH(WEIGHT_BANK_ADDR_WIDTH)
  ) instr_wadr_gen_inst (
    .clk(clk),
    .rst_n(rst_n),
    .adr_en(instr_wen),
    .adr(instr_wadr),
    .config_en(config_en),
    .config_data(instr_max_adr_c)
  );

  

endmodule