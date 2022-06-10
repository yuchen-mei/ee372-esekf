module regfile (
	clk,
	rst_n,
	wen,
	addr_w,
	data_w,
	addr_r1,
	data_r1,
	addr_r2,
	data_r2,
	addr_r3,
	data_r3
);
	parameter DATA_WIDTH = 32;
	parameter ADDR_WIDTH = 5;
	parameter DEPTH = 32;
	input wire clk;
	input wire rst_n;
	input wire wen;
	input wire [ADDR_WIDTH - 1:0] addr_w;
	input wire [DATA_WIDTH - 1:0] data_w;
	input wire [ADDR_WIDTH - 1:0] addr_r1;
	output wire [DATA_WIDTH - 1:0] data_r1;
	input wire [ADDR_WIDTH - 1:0] addr_r2;
	output wire [DATA_WIDTH - 1:0] data_r2;
	input wire [ADDR_WIDTH - 1:0] addr_r3;
	output wire [DATA_WIDTH - 1:0] data_r3;
	reg [(DEPTH * DATA_WIDTH) - 1:0] regs;
	assign data_r1 = (addr_r1 == 0 ? 0 : (wen & (addr_w == addr_r1) ? data_w : regs[addr_r1 * DATA_WIDTH+:DATA_WIDTH]));
	assign data_r2 = (addr_r2 == 0 ? 0 : (wen & (addr_w == addr_r2) ? data_w : regs[addr_r2 * DATA_WIDTH+:DATA_WIDTH]));
	assign data_r3 = (addr_r3 == 0 ? 0 : (wen & (addr_w == addr_r3) ? data_w : regs[addr_r3 * DATA_WIDTH+:DATA_WIDTH]));
	always @(posedge clk)
		if (~rst_n)
			regs <= 1'sb0;
		else if (wen)
			regs[addr_w * DATA_WIDTH+:DATA_WIDTH] <= data_w;
endmodule


