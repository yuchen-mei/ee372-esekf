module memory_controller (
	clk,
	mem_addr,
	mem_we,
	mem_ren,
	mem_wdata,
	mem_rdata,
	width,
	instr_mem_addr,
	instr_mem_csb,
	instr_mem_web,
	instr_mem_wdata,
	instr_mem_rdata,
	data_mem_addr,
	data_mem_csb,
	data_mem_web,
	data_mem_wmask,
	data_mem_wdata,
	data_mem_rdata,
	mat_inv_in_l,
	mat_inv_in_u
);
	parameter ADDR_WIDTH = 12;
	parameter DATA_WIDTH = 32;
	parameter VECTOR_LANES = 16;
	parameter DATAPATH = 8;
	parameter INSTR_MEM_ADDR_WIDTH = 8;
	parameter DATA_MEM_ADDR_WIDTH = 12;
	input wire clk;
	input wire [ADDR_WIDTH - 1:0] mem_addr;
	input wire mem_we;
	input wire mem_ren;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_wdata;
	output reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_rdata;
	input wire [2:0] width;
	output wire [INSTR_MEM_ADDR_WIDTH - 1:0] instr_mem_addr;
	output reg instr_mem_csb;
	output reg instr_mem_web;
	output wire [31:0] instr_mem_wdata;
	input wire [31:0] instr_mem_rdata;
	output wire [DATA_MEM_ADDR_WIDTH - 1:0] data_mem_addr;
	output reg data_mem_csb;
	output reg data_mem_web;
	output reg [(DATAPATH / 32) - 1:0] data_mem_wmask;
	output wire [DATAPATH - 1:0] data_mem_wdata;
	input wire [DATAPATH - 1:0] data_mem_rdata;
	input wire [(9 * DATA_WIDTH) - 1:0] mat_inv_in_l;
	input wire [(9 * DATA_WIDTH) - 1:0] mat_inv_in_u;
	localparam DATA_MASK = 12'h800;
	localparam DATA_ADDR = 12'h000;
	localparam TEXT_MASK = 12'he00;
	localparam TEXT_ADDR = 12'h800;
	localparam IO_ADDR = 12'ha00;
	localparam INVMAT_ADDR = 12'ha02;
	localparam INVMAT_L_ADDR = 12'ha03;
	localparam INVMAT_U_ADDR = 12'ha04;
	reg [ADDR_WIDTH - 1:0] mem_addr_r;
	always @(posedge clk) mem_addr_r <= mem_addr;
	assign instr_mem_addr = mem_addr[INSTR_MEM_ADDR_WIDTH - 1:0];
	assign instr_mem_wdata = mem_wdata;
	assign data_mem_addr = mem_addr[3+:DATA_MEM_ADDR_WIDTH];
	assign data_mem_wdata = mem_wdata;
	always @(*) begin
		instr_mem_csb = 1'b0;
		instr_mem_web = 1'b0;
		data_mem_web = 1'b0;
		data_mem_web = 1'b0;
		data_mem_wmask = 1'sb1;
		if ((mem_addr & DATA_MASK) == DATA_ADDR) begin
			data_mem_csb = mem_ren || mem_we;
			data_mem_web = mem_we;
		end
		else if ((mem_addr & TEXT_MASK) == TEXT_ADDR) begin
			instr_mem_csb = mem_ren || mem_we;
			instr_mem_web = mem_we;
		end
		if (mem_addr_r == INVMAT_L_ADDR)
			mem_rdata = mat_inv_in_l;
		else if (mem_addr_r == INVMAT_U_ADDR)
			mem_rdata = mat_inv_in_u;
		else if ((mem_addr_r & DATA_MASK) == DATA_ADDR)
			mem_rdata = data_mem_rdata;
		else if ((mem_addr_r & TEXT_MASK) == TEXT_ADDR)
			mem_rdata = instr_mem_rdata;
	end
endmodule