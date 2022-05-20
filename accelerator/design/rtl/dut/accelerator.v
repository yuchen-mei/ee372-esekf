module accelerator #(
  parameter INPUT_WIDTH = 32,
  parameter INSTR_WIDTH = 32,
  parameter OUTPUT_WIDTH = 32,

  parameter LEN = 16,

  parameter SIG_WIDTH = 23,
  parameter EXP_WIDTH = 8,
  parameter IEEE_COMPLIANCE = 0,

  parameter INSTR_BANK_DEPTH = 512,
  parameter INSTR_BANK_ADDR_WIDTH = $clog2(INSTR_BANK_DEPTH),
  parameter GLB_MEM_BANK_DEPTH = 256,
  parameter GLB_MEM_ADDR_WIDTH = 12,

  parameter CONFIG_DATA_WIDTH = 8,
  parameter CONFIG_ADDR_WIDTH = 8,
  parameter INPUT_FIFO_WORDS = 1
)(
  input clk,
  input rst_n,

  input [INPUT_FIFO_WORDS*INPUT_WIDTH - 1 : 0] input_data,
  output input_rdy,
  input input_vld,

  output [OUTPUT_WIDTH - 1 : 0] output_data,
  input output_rdy,
  output logic output_vld,

  input [CONFIG_ADDR_WIDTH + CONFIG_DATA_WIDTH - 1: 0] config_data,
  output reg config_rdy,
  input config_vld
);

  localparam CONFIG_WIDTH = CONFIG_ADDR_WIDTH + CONFIG_DATA_WIDTH;
  localparam DATA_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;

  // ---------------------------------------------------------------------------
  // Wires connecting to the interface FIFOs.
  // ---------------------------------------------------------------------------

  wire instr_fifo_deq;

  wire [INPUT_FIFO_WORDS*INPUT_WIDTH - 1 : 0] input_fifo_dout;
  wire input_fifo_deq;
  wire input_fifo_empty_n;

  wire [OUTPUT_WIDTH - 1 : 0] output_fifo_din;
  wire output_fifo_enq;
  wire output_fifo_full_n;
  wire output_vld_w;

  wire params_fifo_full_n;
  wire [CONFIG_WIDTH - 1 : 0] params_fifo_dout;
  wire params_fifo_deq;
  wire params_fifo_empty_n;

  // ---------------------------------------------------------------------------
  // Control signals coming out of aggregators/deaggregator
  // ---------------------------------------------------------------------------

  wire instr_wen;
  wire input_wen;
  wire output_wb_ren;
  
  // ---------------------------------------------------------------------------
  // Control signals coming out of the convolution controller 
  // ---------------------------------------------------------------------------

  wire instr_full_n;
  wire input_full_n;
  wire output_empty_n;

  wire [INSTR_BANK_ADDR_WIDTH - 1 : 0] instr_wadr;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] input_wadr;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] output_wb_radr;

  wire mat_inv_en;
  wire mat_inv_vld;

  wire mvp_core_en;

  // ---------------------------------------------------------------------------
  // Data connections between the mvp and memory.
  // ---------------------------------------------------------------------------

  wire [INSTR_BANK_ADDR_WIDTH - 1 : 0] pc;
  wire [31 : 0] instr;
  wire mem_read;
  wire mem_write;
  wire [GLB_MEM_ADDR_WIDTH - 1 : 0] mem_addr;
  wire [LEN*DATA_WIDTH - 1 : 0] mem_write_data;
  wire [LEN*DATA_WIDTH - 1 : 0] mem_read_data;

  wire mat_inv_vld_out;
  wire [LEN*DATA_WIDTH - 1 : 0] mat_inv_out;

  wire [LEN*DATA_WIDTH - 1 : 0] glb_mem_rdata;
  wire [LEN*DATA_WIDTH - 1 : 0] input_aggregator_dout;
  wire [DATA_WIDTH - 1 : 0] instr_aggregator_dout;

  // ---------------------------------------------------------------------------
  //  MVP Core and memory
  // ---------------------------------------------------------------------------

  mvp_core #(
    .SIG_WIDTH(SIG_WIDTH),
    .EXP_WIDTH(EXP_WIDTH),
    .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
    .LEN(LEN),
    .INSTR_BANK_ADDR_WIDTH(INSTR_BANK_ADDR_WIDTH),
    .GLB_MEM_ADDR_WIDTH(GLB_MEM_ADDR_WIDTH)
  ) mvp_core_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(mvp_core_en),
    .pc(pc),
    .instr(instr),
    .mem_write_en(mem_write),
    .mem_read_en(mem_read),
    .mem_addr(mem_addr),
    .mem_write_data(mem_write_data),
    .mem_read_data(mem_read_data),
    
    // Debug signals
    .data_out_vld(),
    .data_out(),
    .reg_wb()
  );

  mat_inv matinv_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(mat_inv_en),
    .vld(mat_inv_vld),
    .rdy(),
    .vld_out(mat_inv_vld_out),
    .mat_in(mem_write_data[9*32-1 : 0]),
    .mat_inv_out(mat_inv_out[9*32-1 : 0])
  );

  if (LEN > 9)
    assign mat_inv_out[LEN - 1 : 9] = '0;

  ram_sync_1rw1r #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(INSTR_BANK_ADDR_WIDTH),
    .DEPTH(INSTR_BANK_DEPTH)
  ) instr_mem (
    .clk(clk),
    .wen(instr_wen),
    .wadr(instr_wadr),
    .wdata(instr_aggregator_dout),
    .ren(~instr_full_n),
    .radr(pc),
    .rdata(instr)
  );

  ram_sync_1rw1r #(
    .DATA_WIDTH(LEN*DATA_WIDTH),
    .ADDR_WIDTH(GLB_MEM_ADDR_WIDTH),
    .DEPTH(GLB_MEM_BANK_DEPTH)
  ) glb_mem (
    .clk(clk),
    .wen(input_wen | mem_write),
    .wadr(input_wen ? input_wadr : mem_addr),
    .wdata(input_wen ? input_aggregator_dout : mem_write_data),
    .ren(output_wb_ren | mem_read),
    .radr(output_wb_ren ? output_wb_radr : mem_addr),
    .rdata(glb_mem_rdata)
  );

  // ---------------------------------------------------------------------------
  //  Interface fifos
  // ---------------------------------------------------------------------------

  fifo
  #(
    .DATA_WIDTH(INPUT_FIFO_WORDS*INPUT_WIDTH),
    .FIFO_DEPTH(3),
    .COUNTER_WIDTH(1)
  ) input_fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .din(input_data),
    .enq(input_rdy_w && input_vld),
    .full_n(input_rdy_w),
    .dout(input_fifo_dout),
    .deq(instr_fifo_deq || input_fifo_deq),
    .empty_n(input_fifo_empty_n),
    .clr(1'b0)
  );

  assign input_rdy = input_rdy_w;

  aggregator
  #(
    .DATA_WIDTH(INSTR_WIDTH),
    .FETCH_WIDTH(1)
  ) instr_aggregator_inst
  (
    .clk(clk),
    .rst_n(rst_n),
    .sender_data(input_fifo_dout),
    .sender_empty_n(input_fifo_empty_n),
    .sender_deq(instr_fifo_deq),
    .receiver_data(instr_aggregator_dout),
    .receiver_full_n(instr_full_n),
    .receiver_enq(instr_wen)
  );

  aggregator
  #(
    .DATA_WIDTH(INPUT_FIFO_WORDS*INPUT_WIDTH),
    .FETCH_WIDTH(LEN/INPUT_FIFO_WORDS)
  ) input_aggregator_inst
  (
    .clk(clk),
    .rst_n(rst_n),
    .sender_data(input_fifo_dout),
    .sender_empty_n(input_fifo_empty_n),
    .sender_deq(input_fifo_deq),
    .receiver_data(input_aggregator_dout),
    .receiver_full_n(~instr_full_n && input_full_n),
    .receiver_enq(input_wen)
  );

  fifo
  #(
    .DATA_WIDTH(OUTPUT_WIDTH),
    .FIFO_DEPTH(3),
    .COUNTER_WIDTH(1)
  ) output_fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .din(output_fifo_din),
    .enq(output_fifo_enq),
    .full_n(output_fifo_full_n),
    .dout(output_data),
    .deq(output_rdy && output_vld_w),
    .empty_n(output_vld_w),
    .clr(1'b0)
  );

  assign output_vld = output_vld_w;

  deaggregator
  #(
    .DATA_WIDTH(OUTPUT_WIDTH),
    .FETCH_WIDTH(LEN)
  ) output_deaggregator_inst
  (
    .clk(clk),
    .rst_n(rst_n),
    .sender_data(glb_mem_rdata),
    .sender_empty_n(output_empty_n),
    .sender_deq(output_wb_ren),
    .receiver_data(output_fifo_din),
    .receiver_full_n(output_fifo_full_n),
    .receiver_enq(output_fifo_enq)
  );

  fifo
  #(
    .DATA_WIDTH(CONFIG_WIDTH),
    .FIFO_DEPTH(3),
    .COUNTER_WIDTH(1)
  ) params_fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .din(config_data),
    .enq(params_fifo_full_n && config_vld),
    .full_n(params_fifo_full_n),
    .dout(params_fifo_dout),
    .deq(params_fifo_deq),
    .empty_n(params_fifo_empty_n),
    .clr(1'b0)
  );
  
  assign config_rdy = params_fifo_full_n;

  controller
  #(
    .DATA_WIDTH(LEN*DATA_WIDTH),
    .INSTR_BANK_ADDR_WIDTH(INSTR_BANK_ADDR_WIDTH),
    .GLB_MEM_ADDR_WIDTH(GLB_MEM_ADDR_WIDTH),
    .CONFIG_ADDR_WIDTH(CONFIG_ADDR_WIDTH),
    .CONFIG_DATA_WIDTH(CONFIG_DATA_WIDTH)
  ) controller_inst
  (
    .clk(clk),
    .rst_n(rst_n),

    .params_fifo_dout(params_fifo_dout),
    .params_fifo_deq(params_fifo_deq),
    .params_fifo_empty_n(params_fifo_empty_n),

    .instr_full_n(instr_full_n),
    .input_full_n(input_full_n),
    .output_empty_n(output_empty_n),

    .instr_wadr(instr_wadr),
    .input_wadr(input_wadr),
    .output_wb_radr(output_wb_radr),

    .input_wen(input_wen),
    .output_wb_ren(output_wb_ren),

    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_addr(mem_addr),
    .mem_read_data(mem_read_data),

    .mat_inv_en(mat_inv_en),
    .mat_inv_vld(mat_inv_vld),
    .mat_inv_vld_out(mat_inv_vld_out),
    .mat_inv_out(mat_inv_out),

    .mvp_core_en(mvp_core_en),

    .state_r(),
    .config_adr(),
    .config_data()
  );

endmodule
