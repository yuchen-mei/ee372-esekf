module square_PE_Tri (
	clk,
	rst_n,
	en,
	xin,
	sqr_x,
	zin,
	xout,
	zout
);
	parameter DWIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire [DWIDTH - 1:0] xin;
	input wire [DWIDTH - 1:0] sqr_x;
	input wire [DWIDTH - 1:0] zin;
	output wire [DWIDTH - 1:0] xout;
	output wire [DWIDTH - 1:0] zout;
	reg [DWIDTH - 1:0] zout_r;
	reg [DWIDTH - 1:0] xout_r;
	wire [DWIDTH - 1:0] mac_z0;
	always @(posedge clk)
		if (~rst_n) begin
			zout_r <= 'h0;
			xout_r <= 'h0;
		end
		else if (en) begin
			zout_r <= zin;
			xout_r <= mac_z0;
		end
	assign xout = xout_r;
	assign zout = zout_r;
	DW_fp_mac_DG mac_U0(
		.a({~zin[DWIDTH - 1], zin[DWIDTH - 2:0]}),
		.b(sqr_x),
		.c(xin),
		.rnd(3'h0),
		.DG_ctrl(en),
		.z(mac_z0),
		.status()
	);
endmodule


