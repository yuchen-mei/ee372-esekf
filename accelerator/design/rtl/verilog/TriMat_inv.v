module TriMat_inv (
	clk,
	rst_n,
	vld,
	en,
	mat_in,
	mat_out
);
	parameter DWIDTH = 32;
	parameter MATSIZE = 3;
	input wire clk;
	input wire rst_n;
	input wire vld;
	input wire en;
	input wire [((MATSIZE * MATSIZE) * DWIDTH) - 1:0] mat_in;
	output reg [((MATSIZE * MATSIZE) * DWIDTH) - 1:0] mat_out;
	wire [DWIDTH - 1:0] zcircle_out [MATSIZE - 1:0];
	wire [DWIDTH - 1:0] zsquare_out [((MATSIZE * (MATSIZE - 1)) / 2) - 1:0];
	wire [DWIDTH - 1:0] xsquare_out [((MATSIZE * (MATSIZE - 1)) / 2) - 1:0];
	reg [DWIDTH - 1:0] vec_in_r [MATSIZE - 1:0];
	genvar i;
	generate
		for (i = 1; i < MATSIZE; i = i + 1) begin : genblk1
			genvar j;
			for (j = 0; j < i; j = j + 1) begin : genblk1
				wire [DWIDTH:1] sv2v_tmp_679E7;
				assign sv2v_tmp_679E7 = 32'h00000000;
				always @(*) mat_out[((i * MATSIZE) + j) * DWIDTH+:DWIDTH] = sv2v_tmp_679E7;
			end
		end
	endgenerate
	reg [3:0] state_r;
	reg [3:0] glb_cnt;
	always @(posedge clk)
		if (~rst_n || ~vld)
			glb_cnt <= 'h0;
		else if (en)
			glb_cnt <= glb_cnt + 1'b1;
	always @(posedge clk)
		case (glb_cnt)
			4'h4: mat_out[0+:DWIDTH] <= zsquare_out[1];
			4'h5: mat_out[DWIDTH+:DWIDTH] <= zsquare_out[2];
			4'h6: begin
				mat_out[2 * DWIDTH+:DWIDTH] <= zcircle_out[2];
				mat_out[(MATSIZE + 1) * DWIDTH+:DWIDTH] <= zsquare_out[2];
			end
			4'h7: mat_out[(MATSIZE + 2) * DWIDTH+:DWIDTH] <= zcircle_out[2];
			4'h8: mat_out[((2 * MATSIZE) + 2) * DWIDTH+:DWIDTH] <= zcircle_out[2];
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
					vec_in_r[0] <= 32'h3f800000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h1;
				end
				4'h1: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h2;
				end
				4'h2: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h3f800000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h3;
				end
				4'h3: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h00000000;
					state_r <= 4'h4;
				end
				4'h4: begin
					vec_in_r[0] <= 32'h00000000;
					vec_in_r[1] <= 32'h00000000;
					vec_in_r[2] <= 32'h3f800000;
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
	circle_PE_Tri #(.DWIDTH(DWIDTH)) circle_PE_Tri_U11(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.xin(vec_in_r[0]),
		.cir_x(mat_in[0+:DWIDTH]),
		.zout(zcircle_out[0])
	);
	square_PE_Tri #(.DWIDTH(DWIDTH)) square_PE_Tri_U12(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.xin(vec_in_r[1]),
		.sqr_x(mat_in[DWIDTH+:DWIDTH]),
		.zin(zcircle_out[0]),
		.xout(xsquare_out[0]),
		.zout(zsquare_out[0])
	);
	square_PE_Tri #(.DWIDTH(DWIDTH)) square_PE_Tri_U13(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.xin(vec_in_r[2]),
		.sqr_x(mat_in[2 * DWIDTH+:DWIDTH]),
		.zin(zsquare_out[0]),
		.xout(xsquare_out[1]),
		.zout(zsquare_out[1])
	);
	circle_PE_Tri #(.DWIDTH(DWIDTH)) circle_PE_Tri_U22(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.xin(xsquare_out[0]),
		.cir_x(mat_in[(MATSIZE + 1) * DWIDTH+:DWIDTH]),
		.zout(zcircle_out[1])
	);
	square_PE_Tri #(.DWIDTH(DWIDTH)) square_PE_Tri_U23(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.xin(xsquare_out[1]),
		.sqr_x(mat_in[(MATSIZE + 2) * DWIDTH+:DWIDTH]),
		.zin(zcircle_out[1]),
		.xout(xsquare_out[2]),
		.zout(zsquare_out[2])
	);
	circle_PE_Tri #(.DWIDTH(DWIDTH)) circle_PE_Tri_U33(
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.xin(xsquare_out[2]),
		.cir_x(mat_in[((2 * MATSIZE) + 2) * DWIDTH+:DWIDTH]),
		.zout(zcircle_out[2])
	);
endmodule