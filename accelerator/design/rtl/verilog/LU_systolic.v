module LU_systolic (
	clk,
	rst_n,
	vld,
	en,
	mat_in,
	l_out,
	u_out
);
	parameter DWIDTH = 32;
	parameter MATSIZE = 3;
	input wire clk;
	input wire rst_n;
	input wire vld;
	input wire en;
	input wire [((MATSIZE * MATSIZE) * DWIDTH) - 1:0] mat_in;
	output wire [((MATSIZE * MATSIZE) * DWIDTH) - 1:0] l_out;
	output reg [((MATSIZE * MATSIZE) * DWIDTH) - 1:0] u_out;
	reg [DWIDTH - 1:0] vec_in_r [MATSIZE - 1:0];
	wire [DWIDTH - 1:0] ucircle_out [MATSIZE - 1:0];
	wire [DWIDTH - 1:0] asquare_out [((MATSIZE * (MATSIZE - 1)) / 2) - 1:0];
	wire [DWIDTH - 1:0] usquare_out [((MATSIZE * (MATSIZE - 1)) / 2) - 1:0];
	reg [3:0] glb_cnt;
	reg [2:0] state_r;
	genvar i;
	genvar j;
	generate
		for (i = 0; i < MATSIZE; i = i + 1) begin : genblk1
			assign l_out[((i * MATSIZE) + i) * DWIDTH+:DWIDTH] = 32'h3f800000;
		end
		for (i = 0; i < (MATSIZE - 1); i = i + 1) begin : genblk2
			for (j = i + 1; j < MATSIZE; j = j + 1) begin : genblk1
				assign l_out[((i * MATSIZE) + j) * DWIDTH+:DWIDTH] = 32'h00000000;
			end
		end
		for (i = 1; i < MATSIZE; i = i + 1) begin : genblk3
			for (j = 0; j < i; j = j + 1) begin : genblk1
				wire [DWIDTH:1] sv2v_tmp_3DCFC;
				assign sv2v_tmp_3DCFC = 32'h00000000;
				always @(*) u_out[((i * MATSIZE) + j) * DWIDTH+:DWIDTH] = sv2v_tmp_3DCFC;
			end
		end
	endgenerate
	always @(posedge clk)
		if (~rst_n || ~vld)
			glb_cnt <= 'h0;
		else if (en)
			glb_cnt <= glb_cnt + 1'b1;
	always @(posedge clk)
		case (glb_cnt)
			4'h4: u_out[0+:DWIDTH] <= usquare_out[1];
			4'h5: u_out[DWIDTH+:DWIDTH] <= usquare_out[1];
			4'h6: begin
				u_out[2 * DWIDTH+:DWIDTH] <= usquare_out[1];
				u_out[(MATSIZE + 1) * DWIDTH+:DWIDTH] <= usquare_out[2];
			end
			4'h7: u_out[(MATSIZE + 2) * DWIDTH+:DWIDTH] <= usquare_out[2];
			4'h8: u_out[((2 * MATSIZE) + 2) * DWIDTH+:DWIDTH] <= ucircle_out[2];
		endcase
	always @(posedge clk)
		if (~rst_n || ~vld) begin
			state_r <= 'h0;
			vec_in_r[0] <= 'h0;
			vec_in_r[1] <= 'h0;
			vec_in_r[2] <= 'h0;
		end
		else if (en)
			case (state_r)
				4'h0: begin
					vec_in_r[0] <= mat_in[0+:DWIDTH];
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h1;
				end
				4'h1: begin
					vec_in_r[0] <= mat_in[DWIDTH+:DWIDTH];
					vec_in_r[1] <= mat_in[MATSIZE * DWIDTH+:DWIDTH];
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h2;
				end
				4'h2: begin
					vec_in_r[0] <= mat_in[2 * DWIDTH+:DWIDTH];
					vec_in_r[1] <= mat_in[(MATSIZE + 1) * DWIDTH+:DWIDTH];
					vec_in_r[2] <= mat_in[(2 * MATSIZE) * DWIDTH+:DWIDTH];
					state_r <= 4'h3;
				end
				4'h3: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= mat_in[(MATSIZE + 2) * DWIDTH+:DWIDTH];
					vec_in_r[2] <= mat_in[((2 * MATSIZE) + 1) * DWIDTH+:DWIDTH];
					state_r <= 4'h4;
				end
				4'h4: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= mat_in[((2 * MATSIZE) + 2) * DWIDTH+:DWIDTH];
					state_r <= 4'h5;
				end
				4'h5: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h5;
				end
				default: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h0;
				end
			endcase
	circle_PE_LU #(.DWIDTH(DWIDTH)) circle_PE_LU_U11(
		.clk(clk),
		.rst_n(rst_n),
		.vld(vld),
		.en(en),
		.ain(vec_in_r[0]),
		.uout(ucircle_out[0])
	);
	square_PE_LU #(.DWIDTH(DWIDTH)) square_PE_LU_U21(
		.clk(clk),
		.rst_n(rst_n),
		.vld(vld),
		.en(en),
		.i(3'h2),
		.j(3'h1),
		.ain(vec_in_r[1]),
		.uin(ucircle_out[0]),
		.aout(asquare_out[0]),
		.uout(usquare_out[0]),
		.l(l_out[MATSIZE * DWIDTH+:DWIDTH])
	);
	circle_PE_LU #(.DWIDTH(DWIDTH)) circle_PE_LU_U22(
		.clk(clk),
		.rst_n(rst_n),
		.vld(vld),
		.en(en),
		.ain(asquare_out[0]),
		.uout(ucircle_out[1])
	);
	square_PE_LU #(.DWIDTH(DWIDTH)) square_PE_LU_U31(
		.clk(clk),
		.rst_n(rst_n),
		.vld(vld),
		.en(en),
		.i(3'h3),
		.j(3'h1),
		.ain(vec_in_r[2]),
		.uin(usquare_out[0]),
		.aout(asquare_out[1]),
		.uout(usquare_out[1]),
		.l(l_out[(2 * MATSIZE) * DWIDTH+:DWIDTH])
	);
	square_PE_LU #(.DWIDTH(DWIDTH)) square_PE_LU_U32(
		.clk(clk),
		.rst_n(rst_n),
		.vld(vld),
		.en(en),
		.i(3'h3),
		.j(3'h2),
		.ain(asquare_out[1]),
		.uin(ucircle_out[1]),
		.aout(asquare_out[2]),
		.uout(usquare_out[2]),
		.l(l_out[((2 * MATSIZE) + 1) * DWIDTH+:DWIDTH])
	);
	circle_PE_LU #(.DWIDTH(DWIDTH)) circle_PE_LU_U33(
		.clk(clk),
		.rst_n(rst_n),
		.vld(vld),
		.en(en),
		.ain(asquare_out[2]),
		.uout(ucircle_out[2])
	);
endmodule