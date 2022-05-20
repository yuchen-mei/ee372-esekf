// States
`define STATE_WIDTH 2
`define IDLE 0
`define INITIAL_FILL 1
`define INNER_LOOP 2
`define RESET_INNER_LOOP 3

module controller #(
  parameter DATA_WIDTH = 32,

  parameter INSTR_BANK_ADDR_WIDTH = 8,
  parameter GLB_MEM_ADDR_WIDTH = 12,

  parameter CONFIG_ADDR_WIDTH = 8,
  parameter CONFIG_DATA_WIDTH = 8,
  parameter NUM_CONFIGS = 12
)
(
  input clk,
  input rst_n,
  
  input [CONFIG_ADDR_WIDTH + CONFIG_DATA_WIDTH - 1 : 0] params_fifo_dout,
  output params_fifo_deq,
  input params_fifo_empty_n,

  input wire input_wen,
  input wire output_wb_ren,

  output wire instr_full_n,
  output wire input_full_n,
  output reg output_empty_n,

  output [INSTR_BANK_ADDR_WIDTH - 1 : 0] instr_wadr,
  output [GLB_MEM_ADDR_WIDTH - 1 : 0] input_wadr,
  output [GLB_MEM_ADDR_WIDTH - 1 : 0] output_wb_radr,

  input mem_read,
  input mem_write,
  input [GLB_MEM_ADDR_WIDTH - 1 : 0] mem_addr,
  output reg [DATA_WIDTH - 1 : 0] mem_read_data,

  output mat_inv_en,
  output mat_inv_vld,
  input mat_inv_vld_out,
  input [DATA_WIDTH - 1 : 0] mat_inv_out,

  output reg mvp_core_en,

  // FIXME: For testing purpose
  output reg [`STATE_WIDTH - 1 : 0] state_r,
  output [CONFIG_ADDR_WIDTH - 1 : 0] config_adr,
  output [CONFIG_DATA_WIDTH - 1 : 0] config_data
);

  // ---------------------------------------------------------------------------
  // Configuration registers
  // ---------------------------------------------------------------------------

  reg [CONFIG_DATA_WIDTH - 1 : 0] config_r [NUM_CONFIGS - 1 : 0];

  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] instr_max_wadr_c;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] input_max_wadr_c;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] input_wadr_offset;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] output_max_adr_c;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] output_radr_offset;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] mat_inv_offset;

  // ---------------------------------------------------------------------------
  // Registers for keeping track of the state of the accelerator
  // ---------------------------------------------------------------------------

  // reg [`STATE_WIDTH - 1 : 0] state_r;
  reg [GLB_MEM_ADDR_WIDTH - 1 : 0] instr_wadr_r;
  reg [GLB_MEM_ADDR_WIDTH - 1 : 0] input_wadr_r;
  reg [GLB_MEM_ADDR_WIDTH - 1 : 0] output_wbadr_r;

  assign instr_wadr = instr_wadr_r;
  assign input_wadr = input_wadr_r;
  assign output_wb_radr = output_wbadr_r;

  assign instr_full_n = (instr_wadr_r <= instr_max_wadr_c);
  assign input_full_n = (input_wadr_r <= input_wadr_offset + input_max_wadr_c);

  // Connections to the interface FIFO supplying the configuration parameters.

  // wire [CONFIG_ADDR_WIDTH - 1 : 0] config_adr;
  // wire [CONFIG_DATA_WIDTH - 1 : 0] config_data;
  assign config_adr = params_fifo_dout[CONFIG_ADDR_WIDTH + CONFIG_DATA_WIDTH - 1 : CONFIG_DATA_WIDTH];
  assign config_data = params_fifo_dout[CONFIG_DATA_WIDTH - 1 : 0];
  assign params_fifo_deq = params_fifo_empty_n && (state_r == `IDLE);

  reg mem_updated;

  always @ (posedge clk) begin
    if (!rst_n) begin
      state_r <= `IDLE;

      instr_wadr_r <= 0;
      input_wadr_r <= {GLB_MEM_ADDR_WIDTH{1'b1}};;
      output_wbadr_r <= 0;

      output_empty_n <= 0;
      mvp_core_en <= 0;
    end
    else begin
      if (state_r == `IDLE) begin
        if (params_fifo_empty_n) begin
          config_r[config_adr] <= config_data;

          if (config_adr == NUM_CONFIGS - 1) begin
            state_r <= `INITIAL_FILL; 
          end
        end
      end
      else if (state_r == `INITIAL_FILL) begin
        instr_wadr_r <= (input_wen && instr_wadr_r <= instr_max_wadr_c) ? 
          instr_wadr_r + 1 : instr_wadr_r;

        if (instr_wadr_r == instr_max_wadr_c + 1) begin
          state_r <= `INNER_LOOP;
          mvp_core_en <= 1;
        end
      end
      else if (state_r == `INNER_LOOP) begin
        // Special instruction to invoke I/O
        if (mem_read & (mem_addr == input_wadr_offset)) begin
          input_wadr_r <= input_wadr_offset;
          output_wbadr_r <= output_radr_offset;
          output_empty_n <= 1;
          state_r <= `RESET_INNER_LOOP;
        end
        
        // if (mem_write & (mem_addr == output_radr_offset)) begin
        //   output_empty_n <= 1;
        // end
        
        // Halt MVP Core when running matrix inversion
        if (mem_write & (mem_addr == mat_inv_offset)) begin
          mvp_core_en <= 0;
        end
        if (mat_inv_en && mat_inv_vld_out) begin
          mvp_core_en <= 1;
        end

        if (mem_read & (mem_addr == mat_inv_offset))
          mem_read_data <= mat_inv_out;
      end else if (state_r == `RESET_INNER_LOOP) begin
        input_wadr_r <= (input_wen && input_full_n) ? input_wadr_r + 1 : input_wadr_r;
        output_wbadr_r <= (output_wb_ren && output_empty_n) ? output_wbadr_r + 1 : output_wbadr_r;

        output_empty_n <= (output_wbadr_r <= output_radr_offset + output_max_adr_c);

        // Enable MVP Core after complete reading input and sending out outputs
        if ((input_wadr_r >= input_wadr_offset + input_max_wadr_c) && 
            (output_wbadr_r >= output_radr_offset + output_max_adr_c))
          mvp_core_en <= 1;

        // Enter inner loop one cycle later to prevent race condition
        if ((input_wadr_r == input_wadr_offset + input_max_wadr_c + 1) && 
            (output_wbadr_r == output_radr_offset + output_max_adr_c + 1)) begin
          state_r <= `INNER_LOOP;
        end
      end
    end
  end

  assign mat_inv_en = (mem_write & (mem_addr == mat_inv_offset) & ~mat_inv_vld_out);

  pos_edge_det mat_inv_en_ped (.clk(clk), .sig(mat_inv_en), .pe(mat_inv_vld));


  // Assigns values to the configuration registers

  assign instr_max_wadr_c   = {config_r[1], config_r[0]};
  assign input_max_wadr_c   = {config_r[3], config_r[2]};
  assign input_wadr_offset  = {config_r[5], config_r[4]};
  assign output_max_adr_c   = {config_r[7], config_r[6]};
  assign output_radr_offset = {config_r[9], config_r[8]};
  assign mat_inv_offset     = {config_r[11], config_r[10]};

endmodule
