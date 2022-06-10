module accelerator (
	clk,
	rst_n,
	input_data,
	input_rdy,
	input_vld,
	output_data,
	output_rdy,
	output_vld
);
	parameter SIG_WIDTH = 23;
	parameter EXP_WIDTH = 8;
	parameter IEEE_COMPLIANCE = 0;
	parameter INPUT_FIFO_WIDTH = 16;
	parameter OUTPUT_FIFO_WIDTH = 8;
	parameter CONFIG_DATA_WIDTH = 16;
	parameter VECTOR_LANES = 16;
	parameter DATAPATH = 256;
	parameter INSTR_MEM_BANK_DEPTH = 512;
	parameter INSTR_MEM_ADDR_WIDTH = $clog2(INSTR_MEM_BANK_DEPTH);
	parameter DATA_MEM_BANK_DEPTH = 256;
	parameter DATA_MEM_ADDR_WIDTH = $clog2(DATA_MEM_BANK_DEPTH);
	input wire clk;
	input wire rst_n;
	input wire [INPUT_FIFO_WIDTH - 1:0] input_data;
	output wire input_rdy;
	input wire input_vld;
	output wire [OUTPUT_FIFO_WIDTH - 1:0] output_data;
	input wire output_rdy;
	output wire output_vld;
	localparam DATA_WIDTH = (SIG_WIDTH + EXP_WIDTH) + 1;
	localparam ADDR_WIDTH = 12;
	wire [INPUT_FIFO_WIDTH - 1:0] input_fifo_dout;
	wire params_fifo_deq;
	wire instr_fifo_deq;
	wire input_fifo_deq;
	wire input_fifo_empty_n;
	wire input_rdy_w;
	wire [OUTPUT_FIFO_WIDTH - 1:0] output_fifo_din;
	wire output_fifo_enq;
	wire output_fifo_full_n;
	wire output_vld_w;
	wire instr_wen;
	wire input_wen;
	wire output_wb_ren;
	wire instr_full_n;
	wire input_full_n;
	wire output_empty_n;
	wire [INSTR_MEM_ADDR_WIDTH - 1:0] instr_wadr;
	wire [DATA_MEM_ADDR_WIDTH - 1:0] input_wadr;
	wire [DATA_MEM_ADDR_WIDTH - 1:0] output_wb_radr;
	wire mat_inv_en;
	wire mat_inv_vld;
	wire mvp_core_en;
	wire [11:0] mvp_mem_addr;
	wire mvp_mem_we;
	wire mvp_mem_ren;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mvp_mem_wdata;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mvp_mem_rdata;
	wire [2:0] width;
	wire [INSTR_MEM_ADDR_WIDTH - 1:0] instr_mem_addr;
	wire instr_mem_csb;
	wire instr_mem_web;
	wire [DATA_WIDTH - 1:0] instr_mem_wdata;
	wire [DATA_WIDTH - 1:0] instr_mem_rdata;
	wire [INSTR_MEM_ADDR_WIDTH - 1:0] pc;
	wire [31:0] instr;
	wire [DATA_MEM_ADDR_WIDTH - 1:0] data_mem_addr;
	wire data_mem_csb;
	wire data_mem_web;
	wire [(DATAPATH / 32) - 1:0] data_mem_wmask0;
	wire [DATAPATH - 1:0] data_mem_wdata;
	wire [DATAPATH - 1:0] data_mem_rdata;
	wire [DATAPATH - 1:0] output_wb_data;
	wire mat_inv_vld_out;
	wire [(9 * DATA_WIDTH) - 1:0] mat_inv_out_l;
	wire [(9 * DATA_WIDTH) - 1:0] mat_inv_out_u;
	wire [DATAPATH - 1:0] input_aggregator_dout;
	wire [DATA_WIDTH - 1:0] instr_aggregator_dout;
	mvp_core #(
		.SIG_WIDTH(SIG_WIDTH),
		.EXP_WIDTH(EXP_WIDTH),
		.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
		.VECTOR_LANES(VECTOR_LANES),
		.ADDR_WIDTH(ADDR_WIDTH),
		.INSTR_MEM_ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
		.DATA_MEM_ADDR_WIDTH(DATA_MEM_ADDR_WIDTH)
	) mvp_core_inst(
		.clk(clk),
		.rst_n(rst_n),
		.en(mvp_core_en),
		.pc(pc),
		.instr(instr),
		.mem_addr(mvp_mem_addr),
		.mem_we(mvp_mem_we),
		.mem_ren(mvp_mem_ren),
		.mem_wdata(mvp_mem_wdata),
		.mem_rdata(mvp_mem_rdata),
		.width(width),
		.data_out(),
		.data_out_vld(),
		.reg_wb()
	);
	mat_inv mat_inv_inst(
		.clk(clk),
		.rst_n(rst_n),
		.en(mat_inv_en),
		.vld(mat_inv_vld),
		.mat_in(mvp_mem_wdata[0+:DATA_WIDTH * 9]),
		.rdy(),
		.vld_out(mat_inv_vld_out),
		.mat_inv_out_l(mat_inv_out_l),
		.mat_inv_out_u(mat_inv_out_u)
	);
	ram_sync_1rw1r #(
		.DATA_WIDTH(32),
		.ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
		.DEPTH(INSTR_MEM_BANK_DEPTH)
	) instr_mem(
		.clk(clk),
		.csb0(instr_wen || instr_mem_csb),
		.web0(instr_wen || instr_mem_web),
		.addr0((instr_wen ? instr_wadr : instr_mem_addr)),
		.wmask0(1'b1),
		.din0(instr_aggregator_dout),
		.dout0(instr_mem_rdata),
		.csb1(~instr_full_n),
		.addr1(pc),
		.dout1(instr)
	);
	ram_sync_1rw1r #(
		.DATA_WIDTH(DATAPATH),
		.ADDR_WIDTH(DATA_MEM_ADDR_WIDTH),
		.DEPTH(DATA_MEM_BANK_DEPTH)
	) data_mem(
		.clk(clk),
		.csb0(input_wen || data_mem_csb),
		.web0(input_wen || data_mem_web),
		.addr0((input_wen ? input_wadr : data_mem_addr)),
		.wmask0((input_wen ? 8'hff : data_mem_wmask0)),
		.din0((input_wen ? input_aggregator_dout : data_mem_wdata)),
		.dout0(data_mem_rdata),
		.csb1(output_wb_ren),
		.addr1(output_wb_radr),
		.dout1(output_wb_data)
	);
	memory_controller #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.VECTOR_LANES(VECTOR_LANES),
		.DATAPATH(DATAPATH),
		.INSTR_MEM_ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
		.DATA_MEM_ADDR_WIDTH(DATA_MEM_ADDR_WIDTH)
	) mem_ctrl_inst(
		.clk(clk),
		.mem_addr(mvp_mem_addr),
		.mem_we(mvp_mem_we),
		.mem_ren(mvp_mem_ren),
		.mem_wdata(mvp_mem_wdata),
		.mem_rdata(mvp_mem_rdata),
		.width(width),
		.instr_mem_addr(instr_mem_addr),
		.instr_mem_csb(instr_mem_csb),
		.instr_mem_web(instr_mem_web),
		.instr_mem_wdata(instr_mem_wdata),
		.instr_mem_rdata(instr_mem_rdata),
		.data_mem_addr(data_mem_addr),
		.data_mem_csb(data_mem_csb),
		.data_mem_web(data_mem_web),
		.data_mem_wmask(data_mem_wmask0),
		.data_mem_wdata(data_mem_wdata),
		.data_mem_rdata(data_mem_rdata),
		.mat_inv_in_l(mat_inv_out_l),
		.mat_inv_in_u(mat_inv_out_u)
	);
	fifo #(
		.DATA_WIDTH(INPUT_FIFO_WIDTH),
		.FIFO_DEPTH(3),
		.COUNTER_WIDTH(1)
	) input_fifo_inst(
		.clk(clk),
		.rst_n(rst_n),
		.din(input_data),
		.enq(input_rdy_w && input_vld),
		.full_n(input_rdy_w),
		.dout(input_fifo_dout),
		.deq((params_fifo_deq || instr_fifo_deq) || input_fifo_deq),
		.empty_n(input_fifo_empty_n),
		.clr(1'b0)
	);
	assign input_rdy = input_rdy_w;
	aggregator #(
		.DATA_WIDTH(INPUT_FIFO_WIDTH),
		.FETCH_WIDTH(32 / INPUT_FIFO_WIDTH)
	) instr_aggregator_inst(
		.clk(clk),
		.rst_n(rst_n),
		.sender_data(input_fifo_dout),
		.sender_empty_n(input_fifo_empty_n),
		.sender_deq(instr_fifo_deq),
		.receiver_data(instr_aggregator_dout),
		.receiver_full_n(instr_full_n),
		.receiver_enq(instr_wen)
	);
	aggregator #(
		.DATA_WIDTH(INPUT_FIFO_WIDTH),
		.FETCH_WIDTH(DATAPATH / INPUT_FIFO_WIDTH)
	) input_aggregator_inst(
		.clk(clk),
		.rst_n(rst_n),
		.sender_data(input_fifo_dout),
		.sender_empty_n(input_fifo_empty_n),
		.sender_deq(input_fifo_deq),
		.receiver_data(input_aggregator_dout),
		.receiver_full_n(input_full_n),
		.receiver_enq(input_wen)
	);
	fifo #(
		.DATA_WIDTH(OUTPUT_FIFO_WIDTH),
		.FIFO_DEPTH(3),
		.COUNTER_WIDTH(1)
	) output_fifo_inst(
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
	deaggregator #(
		.DATA_WIDTH(OUTPUT_FIFO_WIDTH),
		.FETCH_WIDTH(DATAPATH / OUTPUT_FIFO_WIDTH)
	) output_deaggregator_inst(
		.clk(clk),
		.rst_n(rst_n),
		.sender_data(output_wb_data),
		.sender_empty_n(output_empty_n),
		.sender_deq(output_wb_ren),
		.receiver_data(output_fifo_din),
		.receiver_full_n(output_fifo_full_n),
		.receiver_enq(output_fifo_enq)
	);
	controller #(
		.INPUT_FIFO_WIDTH(INPUT_FIFO_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.INSTR_MEM_ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
		.DATA_MEM_ADDR_WIDTH(DATA_MEM_ADDR_WIDTH),
		.CONFIG_DATA_WIDTH(CONFIG_DATA_WIDTH)
	) controller_inst(
		.clk(clk),
		.rst_n(rst_n),
		.params_fifo_dout(input_fifo_dout),
		.params_fifo_deq(params_fifo_deq),
		.params_fifo_empty_n(input_fifo_empty_n),
		.instr_full_n(instr_full_n),
		.input_full_n(input_full_n),
		.output_empty_n(output_empty_n),
		.instr_wadr(instr_wadr),
		.input_wadr(input_wadr),
		.output_wb_radr(output_wb_radr),
		.instr_wen(instr_wen),
		.input_wen(input_wen),
		.output_wb_ren(output_wb_ren),
		.mem_addr(mvp_mem_addr),
		.mem_read(mvp_mem_ren),
		.mem_write(mvp_mem_we),
		.mat_inv_en(mat_inv_en),
		.mat_inv_vld(mat_inv_vld),
		.mat_inv_vld_out(mat_inv_vld_out),
		.mvp_core_en(mvp_core_en)
	);
endmodule