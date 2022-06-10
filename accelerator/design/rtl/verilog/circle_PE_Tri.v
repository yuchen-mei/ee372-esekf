module circle_PE_Tri (
	clk,
	rst_n,
	en,
	xin,
	cir_x,
	zout
);
	parameter DWIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire [DWIDTH - 1:0] xin;
	input wire [DWIDTH - 1:0] cir_x;
	output wire [DWIDTH - 1:0] zout;
	reg [DWIDTH - 1:0] zout_r;
	wire [DWIDTH - 1:0] div_z0;
	always @(posedge clk)
		if (~rst_n)
			zout_r <= 'h0;
		else if (en)
			zout_r <= div_z0;
	assign zout = zout_r;
	DW_fp_div_DG div_U0(
		.a(xin),
		.b(cir_x),
		.rnd(3'h0),
		.DG_ctrl(en),
		.z(div_z0),
		.status()
	);
endmodule