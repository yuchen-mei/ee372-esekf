module dot_product_unit (
	clk,
	en,
	vec_a,
	vec_b,
	vec_c,
	funct,
	rnd,
	vec_out
);
	parameter SIG_WIDTH = 23;
	parameter EXP_WIDTH = 8;
	parameter IEEE_COMPLIANCE = 0;
	parameter VECTOR_LANES = 16;
	parameter NUM_STAGES = 3;
	parameter DATA_WIDTH = (SIG_WIDTH + EXP_WIDTH) + 1;
	input wire clk;
	input wire en;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_a;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_b;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_c;
	input wire [2:0] funct;
	input wire [2:0] rnd;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out;
	wire [((VECTOR_LANES * 8) * DATA_WIDTH) - 1:0] dp4_mat_in;
	wire [((VECTOR_LANES * 8) * DATA_WIDTH) - 1:0] dp4_dot_in;
	wire [((VECTOR_LANES * 8) * DATA_WIDTH) - 1:0] dp4_qmul_in;
	wire [((VECTOR_LANES * 8) * DATA_WIDTH) - 1:0] dp4_rot_in;
	reg [((VECTOR_LANES * 8) * DATA_WIDTH) - 1:0] inst_dp4;
	wire [(VECTOR_LANES * 8) - 1:0] status_inst;
	genvar i;
	generate
		for (i = 0; i < 3; i = i + 1) begin : mat_col
			genvar j;
			for (j = 0; j < 3; j = j + 1) begin : mat_row
				assign dp4_mat_in[(((3 * i) + j) * 8) * DATA_WIDTH+:DATA_WIDTH] = vec_a[j * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 1) * DATA_WIDTH+:DATA_WIDTH] = vec_b[(3 * i) * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 2) * DATA_WIDTH+:DATA_WIDTH] = vec_a[(3 + j) * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 3) * DATA_WIDTH+:DATA_WIDTH] = vec_b[((3 * i) + 1) * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 4) * DATA_WIDTH+:DATA_WIDTH] = vec_a[(6 + j) * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 5) * DATA_WIDTH+:DATA_WIDTH] = vec_b[((3 * i) + 2) * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 6) * DATA_WIDTH+:DATA_WIDTH] = vec_c[((3 * i) + j) * DATA_WIDTH+:DATA_WIDTH];
				assign dp4_mat_in[((((3 * i) + j) * 8) + 7) * DATA_WIDTH+:DATA_WIDTH] = 32'h3f800000;
			end
		end
		for (i = 0; i < (VECTOR_LANES / 4); i = i + 1) begin : dot_product
			assign dp4_dot_in[((4 * i) * 8) * DATA_WIDTH+:DATA_WIDTH] = vec_a[(4 * i) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 1) * DATA_WIDTH+:DATA_WIDTH] = vec_b[(4 * i) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 2) * DATA_WIDTH+:DATA_WIDTH] = vec_a[((4 * i) + 1) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 3) * DATA_WIDTH+:DATA_WIDTH] = vec_b[((4 * i) + 1) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 4) * DATA_WIDTH+:DATA_WIDTH] = vec_a[((4 * i) + 2) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 5) * DATA_WIDTH+:DATA_WIDTH] = vec_b[((4 * i) + 2) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 6) * DATA_WIDTH+:DATA_WIDTH] = vec_a[((4 * i) + 3) * DATA_WIDTH+:DATA_WIDTH];
			assign dp4_dot_in[(((4 * i) * 8) + 7) * DATA_WIDTH+:DATA_WIDTH] = vec_b[((4 * i) + 3) * DATA_WIDTH+:DATA_WIDTH];
		end
	endgenerate
	wire [DATA_WIDTH - 1:0] a_neg [VECTOR_LANES - 1:0];
	generate
		for (i = 0; i < VECTOR_LANES; i = i + 1) begin : genblk3
			assign a_neg[i] = {~vec_a[(i * DATA_WIDTH) + (DATA_WIDTH - 1)], vec_a[(i * DATA_WIDTH) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 2 : ((DATA_WIDTH - 2) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)) - 1)-:((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)]};
		end
	endgenerate
	assign dp4_qmul_in[0+:DATA_WIDTH * 8] = {vec_a[0+:DATA_WIDTH], vec_b[0+:DATA_WIDTH], a_neg[1], vec_b[DATA_WIDTH+:DATA_WIDTH], a_neg[2], vec_b[2 * DATA_WIDTH+:DATA_WIDTH], a_neg[3], vec_b[3 * DATA_WIDTH+:DATA_WIDTH]};
	assign dp4_qmul_in[DATA_WIDTH * 8+:DATA_WIDTH * 8] = {vec_a[0+:DATA_WIDTH], vec_b[DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_b[0+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_b[3 * DATA_WIDTH+:DATA_WIDTH], a_neg[3], vec_b[2 * DATA_WIDTH+:DATA_WIDTH]};
	assign dp4_qmul_in[DATA_WIDTH * 16+:DATA_WIDTH * 8] = {vec_a[0+:DATA_WIDTH], vec_b[2 * DATA_WIDTH+:DATA_WIDTH], a_neg[1], vec_b[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_b[0+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_b[3 * DATA_WIDTH+:DATA_WIDTH]};
	assign dp4_qmul_in[DATA_WIDTH * 24+:DATA_WIDTH * 8] = {vec_a[0+:DATA_WIDTH], vec_b[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_b[2 * DATA_WIDTH+:DATA_WIDTH], a_neg[2], vec_b[DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_b[0+:DATA_WIDTH]};
	assign dp4_rot_in[0+:DATA_WIDTH * 8] = {vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], a_neg[2], a_neg[3], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[0+:DATA_WIDTH]};
	assign dp4_rot_in[DATA_WIDTH * 8+:DATA_WIDTH * 8] = {vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH]};
	assign dp4_rot_in[DATA_WIDTH * 16+:DATA_WIDTH * 8] = {vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], a_neg[2], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], a_neg[2], vec_a[0+:DATA_WIDTH]};
	assign dp4_rot_in[DATA_WIDTH * 24+:DATA_WIDTH * 8] = {vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], a_neg[3], vec_a[0+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], a_neg[3]};
	assign dp4_rot_in[DATA_WIDTH * 32+:DATA_WIDTH * 8] = {vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], a_neg[1], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], a_neg[3]};
	assign dp4_rot_in[DATA_WIDTH * 40+:DATA_WIDTH * 8] = {vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH]};
	assign dp4_rot_in[DATA_WIDTH * 48+:DATA_WIDTH * 8] = {vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH]};
	assign dp4_rot_in[DATA_WIDTH * 56+:DATA_WIDTH * 8] = {vec_a[2 * DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], a_neg[1], vec_a[0+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], a_neg[1], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[2 * DATA_WIDTH+:DATA_WIDTH]};
	assign dp4_rot_in[DATA_WIDTH * 64+:DATA_WIDTH * 8] = {vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[3 * DATA_WIDTH+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[0+:DATA_WIDTH], vec_a[DATA_WIDTH+:DATA_WIDTH], a_neg[1], a_neg[2], vec_a[2 * DATA_WIDTH+:DATA_WIDTH]};
	generate
		if (VECTOR_LANES > 4) begin : genblk4
			assign dp4_qmul_in[DATA_WIDTH * (8 * (((VECTOR_LANES - 1) >= 4 ? VECTOR_LANES - 1 : ((VECTOR_LANES - 1) + ((VECTOR_LANES - 1) >= 4 ? VECTOR_LANES - 4 : 6 - VECTOR_LANES)) - 1) - (((VECTOR_LANES - 1) >= 4 ? VECTOR_LANES - 4 : 6 - VECTOR_LANES) - 1)))+:DATA_WIDTH * (8 * ((VECTOR_LANES - 1) >= 4 ? VECTOR_LANES - 4 : 6 - VECTOR_LANES))] = 1'sb0;
			assign dp4_dot_in[DATA_WIDTH * 8+:DATA_WIDTH * 24] = 1'sb0;
			assign dp4_dot_in[DATA_WIDTH * 40+:DATA_WIDTH * 32] = 1'sb0;
		end
		if (VECTOR_LANES > 9) begin : genblk5
			assign dp4_mat_in[DATA_WIDTH * (8 * (((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 1 : ((VECTOR_LANES - 1) + ((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 9 : 11 - VECTOR_LANES)) - 1) - (((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 9 : 11 - VECTOR_LANES) - 1)))+:DATA_WIDTH * (8 * ((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 9 : 11 - VECTOR_LANES))] = 1'sb0;
			assign dp4_rot_in[DATA_WIDTH * (8 * (((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 1 : ((VECTOR_LANES - 1) + ((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 9 : 11 - VECTOR_LANES)) - 1) - (((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 9 : 11 - VECTOR_LANES) - 1)))+:DATA_WIDTH * (8 * ((VECTOR_LANES - 1) >= 9 ? VECTOR_LANES - 9 : 11 - VECTOR_LANES))] = 1'sb0;
		end
	endgenerate
	always @(*)
		case (funct)
			3'b000: inst_dp4 = dp4_mat_in;
			3'b001: inst_dp4 = dp4_dot_in;
			3'b010: inst_dp4 = dp4_qmul_in;
			3'b011: inst_dp4 = dp4_rot_in;
			default: inst_dp4 = 1'sb0;
		endcase
	generate
		for (i = 0; i < VECTOR_LANES; i = i + 1) begin : genblk6
			DW_fp_dp4_inst_pipe #(
				.SIG_WIDTH(SIG_WIDTH),
				.EXP_WIDTH(EXP_WIDTH),
				.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
				.ARCH_TYPE(1),
				.NUM_STAGES(NUM_STAGES)
			) DW_lp_fp_dp4_inst(
				.inst_clk(clk),
				.inst_a(inst_dp4[(i * 8) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_b(inst_dp4[((i * 8) + 1) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_c(inst_dp4[((i * 8) + 2) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_d(inst_dp4[((i * 8) + 3) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_e(inst_dp4[((i * 8) + 4) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_f(inst_dp4[((i * 8) + 5) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_g(inst_dp4[((i * 8) + 6) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_h(inst_dp4[((i * 8) + 7) * DATA_WIDTH+:DATA_WIDTH]),
				.inst_rnd(rnd),
				.z_inst(vec_out[i * DATA_WIDTH+:DATA_WIDTH]),
				.status_inst(status_inst[i * 8+:8])
			);
		end
	endgenerate
endmodule