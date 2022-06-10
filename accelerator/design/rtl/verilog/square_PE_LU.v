module square_PE_LU (
	clk,
	rst_n,
	vld,
	en,
	i,
	j,
	ain,
	uin,
	aout,
	uout,
	l
);
	parameter DWIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire vld;
	input wire en;
	input wire [2:0] i;
	input wire [2:0] j;
	input wire [DWIDTH - 1:0] ain;
	input wire [DWIDTH - 1:0] uin;
	output wire [DWIDTH - 1:0] aout;
	output wire [DWIDTH - 1:0] uout;
	output wire [DWIDTH - 1:0] l;
	reg [DWIDTH - 1:0] l_r;
	reg [DWIDTH - 1:0] u_r;
	reg [DWIDTH - 1:0] a_r;
	wire [DWIDTH - 1:0] mac_z0;
	wire [DWIDTH - 1:0] div_z0;
	reg [3:0] cnt;
	always @(posedge clk)
		if (~rst_n || ~vld)
			cnt <= 'h0;
		else if (en)
			cnt <= cnt + 1'b1;
	always @(posedge clk)
		if (~rst_n || ~vld) begin
			a_r <= 'h0;
			u_r <= 'h0;
			l_r <= 'h0;
		end
		else if (en) begin
			u_r <= uin;
			if (cnt == (i + (2 * (j - 1))))
				l_r <= div_z0;
			else
				a_r <= mac_z0;
		end
	assign aout = a_r;
	assign uout = u_r;
	assign l = l_r;
	DW_fp_mac_DG mac_U0(
		.a({~l_r[DWIDTH - 1], l_r[DWIDTH - 2:0]}),
		.b(uin),
		.c(ain),
		.rnd(3'h0),
		.DG_ctrl(en),
		.z(mac_z0),
		.status()
	);
	DW_fp_div_DG div_U0(
		.a(ain),
		.b(uin),
		.rnd(3'h0),
		.DG_ctrl(en),
		.z(div_z0),
		.status()
	);
endmodule