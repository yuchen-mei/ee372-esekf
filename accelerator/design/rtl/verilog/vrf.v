module vrf (
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
	parameter DATA_WIDTH = 512;
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
	reg [(DEPTH * DATA_WIDTH) - 1:0] vectors;
	assign data_r1 = (wen & (addr_w == addr_r1) ? data_w : vectors[addr_r1 * DATA_WIDTH+:DATA_WIDTH]);
	assign data_r2 = (wen & (addr_w == addr_r2) ? data_w : vectors[addr_r2 * DATA_WIDTH+:DATA_WIDTH]);
	assign data_r3 = (wen & (addr_w == addr_r3) ? data_w : vectors[addr_r3 * DATA_WIDTH+:DATA_WIDTH]);
	function automatic [DATA_WIDTH - 1:0] sv2v_cast_A78C9;
		input reg [DATA_WIDTH - 1:0] inp;
		sv2v_cast_A78C9 = inp;
	endfunction
	always @(posedge clk)
		if (~rst_n) begin
			vectors[0+:DATA_WIDTH] <= 1'sb0;
			vectors[DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[2 * DATA_WIDTH+:DATA_WIDTH] <= 96'h3b6d800038a36038b8cbffed;
			vectors[3 * DATA_WIDTH+:DATA_WIDTH] <= 128'h350eca6ab80e4003b7ac04fe3f800000;
			vectors[4 * DATA_WIDTH+:DATA_WIDTH] <= 288'h3f8000000000000000000000000000003f8000000000000000000000000000003f800000;
			vectors[5 * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[6 * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[7 * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[8 * DATA_WIDTH+:DATA_WIDTH] <= 288'h3f8000000000000000000000000000003f8000000000000000000000000000003f800000;
			vectors[9 * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[10 * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[11 * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
			vectors[12 * DATA_WIDTH+:DATA_WIDTH] <= 288'h3f8000000000000000000000000000003f8000000000000000000000000000003f800000;
			vectors[DATA_WIDTH * 13+:DATA_WIDTH * 3] <= {3 {sv2v_cast_A78C9(0)}};
			vectors[16 * DATA_WIDTH+:DATA_WIDTH] <= 32'h348637bd;
			vectors[17 * DATA_WIDTH+:DATA_WIDTH] <= 32'h3dcccccd;
			vectors[18 * DATA_WIDTH+:DATA_WIDTH] <= 32'h420c0000;
			vectors[19 * DATA_WIDTH+:DATA_WIDTH] <= 96'h411cf5c30000000000000000;
			vectors[20 * DATA_WIDTH+:DATA_WIDTH] <= 288'h3f8000000000000000000000000000003f8000000000000000000000000000003f800000;
			vectors[21 * DATA_WIDTH+:DATA_WIDTH] <= 32'h3ba3d70a;
			vectors[22 * DATA_WIDTH+:DATA_WIDTH] <= 32'h37d1b717;
			vectors[23 * DATA_WIDTH+:DATA_WIDTH] <= 32'h3751b717;
			vectors[DATA_WIDTH * 24+:DATA_WIDTH * 8] <= {8 {sv2v_cast_A78C9(0)}};
		end
		else if (wen)
			vectors[addr_w * DATA_WIDTH+:DATA_WIDTH] <= data_w;
endmodule


