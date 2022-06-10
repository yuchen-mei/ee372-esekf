module circle_PE_LU (
	clk,
	rst_n,
	vld,
	en,
	ain,
	uout
);
	parameter DWIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire vld;
	input wire en;
	input wire [DWIDTH - 1:0] ain;
	output wire [DWIDTH - 1:0] uout;
	reg [DWIDTH - 1:0] ain_r;
	always @(posedge clk)
		if (~rst_n || ~vld)
			ain_r <= 'h0;
		else if (en)
			ain_r <= ain;
	assign uout = ain_r;
endmodule