module mat_inv (
	clk,
	rst_n,
	en,
	vld,
	mat_in,
	rdy,
	vld_out,
	mat_inv_out_l,
	mat_inv_out_u
);
	parameter DATA_WIDTH = 32;
	parameter MATSIZE = 3;
	parameter VECTOR_LANES = MATSIZE * MATSIZE;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire vld;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mat_in;
	output wire rdy;
	output wire vld_out;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mat_inv_out_l;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mat_inv_out_u;
	reg data_vld;
	reg vld_out_r1;
	reg [7:0] vld_cnt;
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] mat_in_r;
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] mat_row_major;
	genvar i;
	generate
		for (i = 0; i < 3; i = i + 1) begin : genblk1
			genvar j;
			for (j = 0; j < 3; j = j + 1) begin : genblk1
				assign mat_row_major[((i * MATSIZE) + j) * DATA_WIDTH+:DATA_WIDTH] = mat_in[((3 * j) + i) * DATA_WIDTH+:DATA_WIDTH];
			end
		end
	endgenerate
	function automatic [(MATSIZE * DATA_WIDTH) - 1:0] sv2v_cast_E468C;
		input reg [(MATSIZE * DATA_WIDTH) - 1:0] inp;
		sv2v_cast_E468C = inp;
	endfunction
	always @(posedge clk)
		if (~rst_n) begin
			data_vld <= 'h0;
			vld_out_r1 <= 'h0;
			mat_in_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
		end
		else if (en)
			if (vld) begin
				data_vld <= 'h1;
				vld_out_r1 <= 'h0;
				mat_in_r <= mat_row_major;
			end
			else begin
				if (vld_cnt != 'h14)
					data_vld <= data_vld;
				else begin
					data_vld <= 1'b0;
					vld_out_r1 <= 1'b1;
				end
				mat_in_r <= mat_in_r;
			end
	always @(posedge clk)
		if (~rst_n)
			vld_cnt <= 'h0;
		else if (en)
			if (data_vld && (vld_cnt != 'h14))
				vld_cnt <= vld_cnt + 1'b1;
			else
				vld_cnt <= 'h0;
	assign vld_out = vld_out_r1;
	reg [3:0] LU_cnt;
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat;
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] u_mat;
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat_r;
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] u_mat_r;
	always @(posedge clk) begin
		if (~rst_n || ~data_vld) begin
			LU_cnt <= 4'b0000;
			l_mat_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
			u_mat_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
		end
		else if (en)
			if (LU_cnt != 'ha)
				LU_cnt <= LU_cnt + 1'b1;
		if (LU_cnt == 'h9) begin
			l_mat_r <= l_mat;
			u_mat_r <= u_mat;
		end
	end
	LU_systolic #(
		.DWIDTH(DATA_WIDTH),
		.MATSIZE(MATSIZE)
	) LU_systolic_U0(
		.clk(clk),
		.rst_n(rst_n),
		.vld(data_vld),
		.en(en),
		.mat_in(mat_in_r),
		.l_out(l_mat),
		.u_out(u_mat)
	);
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat_in_r;
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] u_mat_in_r;
	reg Tri_vld;
	always @(posedge clk)
		if (~rst_n || ~data_vld) begin
			l_mat_in_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
			u_mat_in_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
			Tri_vld <= 1'b0;
		end
		else if (en)
			if (LU_cnt == 'ha) begin
				l_mat_in_r <= l_mat_r;
				u_mat_in_r <= u_mat_r;
				Tri_vld <= 1'b1;
			end
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat_in_r_t;
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat_inv;
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat_t_inv;
	wire [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] u_mat_inv;
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] l_mat_inv_r;
	reg [((MATSIZE * MATSIZE) * DATA_WIDTH) - 1:0] u_mat_inv_r;
	reg [7:0] triinv_cnt;
	reg rdy_r1;
	generate
		for (i = 0; i < MATSIZE; i = i + 1) begin : genblk2
			genvar j;
			for (j = 0; j < MATSIZE; j = j + 1) begin : genblk1
				assign l_mat_in_r_t[((i * MATSIZE) + j) * DATA_WIDTH+:DATA_WIDTH] = l_mat_in_r[((j * MATSIZE) + i) * DATA_WIDTH+:DATA_WIDTH];
				assign l_mat_inv[((i * MATSIZE) + j) * DATA_WIDTH+:DATA_WIDTH] = l_mat_t_inv[((j * MATSIZE) + i) * DATA_WIDTH+:DATA_WIDTH];
			end
		end
	endgenerate
	TriMat_inv #(
		.DWIDTH(DATA_WIDTH),
		.MATSIZE(MATSIZE)
	) TriMat_inv_U(
		.clk(clk),
		.rst_n(rst_n),
		.vld(Tri_vld),
		.en(en),
		.mat_in(u_mat_in_r),
		.mat_out(u_mat_inv)
	);
	TriMat_inv #(
		.DWIDTH(DATA_WIDTH),
		.MATSIZE(MATSIZE)
	) TriMat_inv_LT(
		.clk(clk),
		.rst_n(rst_n),
		.vld(Tri_vld),
		.en(en),
		.mat_in(l_mat_in_r_t),
		.mat_out(l_mat_t_inv)
	);
	always @(posedge clk)
		if (~rst_n || ~data_vld) begin
			triinv_cnt <= 4'b0000;
			if (~rst_n) begin
				u_mat_inv_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
				l_mat_inv_r <= {MATSIZE {sv2v_cast_E468C(1'sb0)}};
				rdy_r1 <= 1'b0;
			end
			if (~data_vld)
				rdy_r1 <= 1'b1;
		end
		else if (en) begin
			if (triinv_cnt != 'h19)
				triinv_cnt <= triinv_cnt + 1'b1;
			if (triinv_cnt == 'h14) begin
				u_mat_inv_r <= u_mat_inv;
				l_mat_inv_r <= l_mat_inv;
			end
			if (triinv_cnt == 'h14)
				rdy_r1 <= 1'b1;
			if (data_vld)
				rdy_r1 <= 1'b0;
		end
	assign rdy = rdy_r1;
	generate
		for (i = 0; i < 3; i = i + 1) begin : genblk3
			genvar j;
			for (j = 0; j < 3; j = j + 1) begin : genblk1
				assign mat_inv_out_u[((3 * j) + i) * DATA_WIDTH+:DATA_WIDTH] = u_mat_inv_r[((i * MATSIZE) + j) * DATA_WIDTH+:DATA_WIDTH];
				assign mat_inv_out_l[((3 * j) + i) * DATA_WIDTH+:DATA_WIDTH] = l_mat_inv_r[((i * MATSIZE) + j) * DATA_WIDTH+:DATA_WIDTH];
			end
		end
	endgenerate
endmodule