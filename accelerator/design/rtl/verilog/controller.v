module controller (
	clk,
	rst_n,
	params_fifo_dout,
	params_fifo_deq,
	params_fifo_empty_n,
	instr_wen,
	input_wen,
	output_wb_ren,
	instr_full_n,
	input_full_n,
	output_empty_n,
	instr_wadr,
	input_wadr,
	output_wb_radr,
	mem_addr,
	mem_read,
	mem_write,
	mat_inv_en,
	mat_inv_vld,
	mat_inv_vld_out,
	mvp_core_en
);
	parameter INPUT_FIFO_WIDTH = 16;
	parameter ADDR_WIDTH = 12;
	parameter INSTR_MEM_ADDR_WIDTH = 8;
	parameter DATA_MEM_ADDR_WIDTH = 12;
	parameter NUM_CONFIGS = 5;
	parameter CONFIG_DATA_WIDTH = 16;
	parameter CONFIG_ADDR_WIDTH = $clog2(NUM_CONFIGS);
	input wire clk;
	input wire rst_n;
	input wire [INPUT_FIFO_WIDTH - 1:0] params_fifo_dout;
	output wire params_fifo_deq;
	input wire params_fifo_empty_n;
	input wire instr_wen;
	input wire input_wen;
	input wire output_wb_ren;
	output wire instr_full_n;
	output wire input_full_n;
	output wire output_empty_n;
	output wire [INSTR_MEM_ADDR_WIDTH - 1:0] instr_wadr;
	output wire [DATA_MEM_ADDR_WIDTH - 1:0] input_wadr;
	output wire [DATA_MEM_ADDR_WIDTH - 1:0] output_wb_radr;
	input wire [ADDR_WIDTH - 1:0] mem_addr;
	input wire mem_read;
	input wire mem_write;
	output reg mat_inv_en;
	output wire mat_inv_vld;
	input wire mat_inv_vld_out;
	output reg mvp_core_en;
	localparam IO_ADDR = 12'ha00;
	localparam INVMAT_ADDR = 12'ha02;
	reg [CONFIG_DATA_WIDTH - 1:0] config_r [NUM_CONFIGS - 1:0];
	wire [ADDR_WIDTH - 1:0] instr_max_wadr_c;
	wire [ADDR_WIDTH - 1:0] input_max_wadr_c;
	wire [ADDR_WIDTH - 1:0] input_wadr_offset;
	wire [ADDR_WIDTH - 1:0] output_max_adr_c;
	wire [ADDR_WIDTH - 1:0] output_radr_offset;
	reg [1:0] state_r;
	reg [CONFIG_ADDR_WIDTH - 1:0] config_adr_r;
	reg [ADDR_WIDTH - 1:0] instr_wadr_r;
	reg [ADDR_WIDTH - 1:0] input_wadr_r;
	reg [ADDR_WIDTH - 1:0] output_wbadr_r;
	reg mat_inv_en_r;
	wire config_adr;
	assign config_adr = config_adr_r;
	assign instr_wadr = instr_wadr_r;
	assign input_wadr = input_wadr_r[3+:DATA_MEM_ADDR_WIDTH];
	assign output_wb_radr = output_wbadr_r[3+:DATA_MEM_ADDR_WIDTH];
	assign params_fifo_deq = (state_r == 0) && params_fifo_empty_n;
	assign instr_full_n = (state_r == 1) && (instr_wadr_r <= instr_max_wadr_c);
	assign input_full_n = (state_r == 3) && (input_wadr_r <= (input_wadr_offset + input_max_wadr_c));
	assign output_empty_n = (state_r == 3) && (output_wbadr_r <= (output_radr_offset + output_max_adr_c));
	assign mat_inv_vld = mat_inv_en && ~mat_inv_en_r;
	always @(posedge clk)
		if (~rst_n) begin
			state_r <= 0;
			config_adr_r <= 0;
			instr_wadr_r <= 0;
			input_wadr_r <= 0;
			output_wbadr_r <= 0;
			mat_inv_en <= 0;
			mat_inv_en_r <= 0;
			mvp_core_en <= 0;
		end
		else begin
			mat_inv_en_r <= mat_inv_en;
			if (state_r == 0) begin
				if (params_fifo_empty_n) begin
					config_r[config_adr_r] <= params_fifo_dout;
					config_adr_r <= config_adr_r + 1;
					if (config_adr_r == (NUM_CONFIGS - 1))
						state_r <= 1;
				end
			end
			else if (state_r == 1) begin
				instr_wadr_r <= (instr_wen && (instr_wadr_r <= instr_max_wadr_c) ? instr_wadr_r + 1 : instr_wadr_r);
				if (instr_wadr_r == (instr_max_wadr_c + 1)) begin
					state_r <= 2;
					mvp_core_en <= 1;
				end
			end
			else if (state_r == 2) begin
				if (mem_write && (mem_addr == IO_ADDR)) begin
					state_r <= 3;
					mvp_core_en <= 0;
					input_wadr_r <= input_wadr_offset;
					output_wbadr_r <= output_radr_offset;
				end
				else if (mem_write && (mem_addr == INVMAT_ADDR)) begin
					mvp_core_en <= 0;
					mat_inv_en <= 1;
				end
				else if (mat_inv_en && mat_inv_vld_out) begin
					mvp_core_en <= 1;
					mat_inv_en <= 0;
				end
			end
			else if (state_r == 3) begin
				input_wadr_r <= (input_wen && input_full_n ? input_wadr_r + 8 : input_wadr_r);
				output_wbadr_r <= (output_wb_ren && output_empty_n ? output_wbadr_r + 8 : output_wbadr_r);
				if ((input_wadr_r >= (input_wadr_offset + input_max_wadr_c)) && (output_wbadr_r >= (output_radr_offset + output_max_adr_c))) begin
					mvp_core_en <= 1;
					state_r <= 2;
				end
			end
		end
	assign instr_max_wadr_c = config_r[0];
	assign input_max_wadr_c = config_r[1];
	assign input_wadr_offset = config_r[2];
	assign output_max_adr_c = config_r[3];
	assign output_radr_offset = config_r[4];
endmodule