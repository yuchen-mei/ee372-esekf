module vector_unit (
	clk,
	en,
	vec_a,
	vec_b,
	opcode,
	funct,
	rnd,
	vec_out
);
	parameter SIG_WIDTH = 23;
	parameter EXP_WIDTH = 8;
	parameter IEEE_COMPLIANCE = 0;
	parameter VECTOR_LANES = 16;
	parameter DATA_WIDTH = (SIG_WIDTH + EXP_WIDTH) + 1;
	input wire clk;
	input wire en;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_a;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_b;
	input wire [4:0] opcode;
	input wire [2:0] funct;
	input wire [2:0] rnd;
	output reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out;
	wire [(9 * DATA_WIDTH) - 1:0] vec_a_neg;
	wire [(9 * DATA_WIDTH) - 1:0] skew_symmetric;
	wire [(9 * DATA_WIDTH) - 1:0] transpose;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vpermute;
	genvar i;
	generate
		for (i = 0; i < 9; i = i + 1) begin : negate_inputs
			assign vec_a_neg[i * DATA_WIDTH+:DATA_WIDTH] = {~vec_a[(i * DATA_WIDTH) + (DATA_WIDTH - 1)], vec_a[(i * DATA_WIDTH) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 2 : ((DATA_WIDTH - 2) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)) - 1)-:((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)]};
		end
	endgenerate
	assign skew_symmetric[0+:DATA_WIDTH] = 32'b00000000000000000000000000000000;
	assign skew_symmetric[DATA_WIDTH+:DATA_WIDTH] = vec_a[2 * DATA_WIDTH+:DATA_WIDTH];
	assign skew_symmetric[2 * DATA_WIDTH+:DATA_WIDTH] = vec_a_neg[DATA_WIDTH+:DATA_WIDTH];
	assign skew_symmetric[3 * DATA_WIDTH+:DATA_WIDTH] = vec_a_neg[2 * DATA_WIDTH+:DATA_WIDTH];
	assign skew_symmetric[4 * DATA_WIDTH+:DATA_WIDTH] = 32'b00000000000000000000000000000000;
	assign skew_symmetric[5 * DATA_WIDTH+:DATA_WIDTH] = vec_a[0+:DATA_WIDTH];
	assign skew_symmetric[6 * DATA_WIDTH+:DATA_WIDTH] = vec_a[DATA_WIDTH+:DATA_WIDTH];
	assign skew_symmetric[7 * DATA_WIDTH+:DATA_WIDTH] = vec_a_neg[0+:DATA_WIDTH];
	assign skew_symmetric[8 * DATA_WIDTH+:DATA_WIDTH] = 32'b00000000000000000000000000000000;
	generate
		for (i = 0; i < 3; i = i + 1) begin : genblk2
			genvar j;
			for (j = 0; j < 3; j = j + 1) begin : genblk1
				assign transpose[((3 * i) + j) * DATA_WIDTH+:DATA_WIDTH] = vec_a[((3 * j) + i) * DATA_WIDTH+:DATA_WIDTH];
			end
		end
	endgenerate
	always @(*)
		case (funct)
			3'b000: vpermute = skew_symmetric;
			3'b001: vpermute = transpose;
			default: vpermute = 1'sb0;
		endcase
	generate
		for (i = 0; i < VECTOR_LANES; i = i + 1) begin : genblk3
			wire [DATA_WIDTH - 1:0] inst_a;
			wire [DATA_WIDTH - 1:0] inst_b;
			wire aeqb_inst;
			wire altb_inst;
			wire agtb_inst;
			wire unordered_inst;
			wire [DATA_WIDTH - 1:0] z0_inst;
			wire [DATA_WIDTH - 1:0] z1_inst;
			wire [7:0] status0_inst;
			wire [7:0] status1_inst;
			wire [DATA_WIDTH - 1:0] sgnj;
			wire [DATA_WIDTH - 1:0] sgnjn;
			wire [DATA_WIDTH - 1:0] sgnjx;
			wire [DATA_WIDTH - 1:0] classify;
			assign inst_a = (funct == 3'b101 ? vec_a[0+:DATA_WIDTH] : vec_a[i * DATA_WIDTH+:DATA_WIDTH]);
			assign inst_b = vec_b[i * DATA_WIDTH+:DATA_WIDTH];
			DW_fp_cmp_DG #(
				.sig_width(SIG_WIDTH),
				.exp_width(EXP_WIDTH),
				.ieee_compliance(IEEE_COMPLIANCE)
			) DW_fp_cmp_DG_inst(
				.a(inst_a),
				.b(inst_b),
				.zctr(1'b0),
				.DG_ctrl(en),
				.aeqb(aeqb_inst),
				.altb(altb_inst),
				.agtb(agtb_inst),
				.unordered(unordered_inst),
				.z0(z0_inst),
				.z1(z1_inst),
				.status0(status0_inst),
				.status1(status1_inst)
			);
			assign sgnj = {inst_b[DATA_WIDTH - 1], inst_a[DATA_WIDTH - 2:0]};
			assign sgnjn = {~inst_b[DATA_WIDTH - 1], inst_a[DATA_WIDTH - 2:0]};
			assign sgnjx = {inst_a[DATA_WIDTH - 1] ^ inst_b[DATA_WIDTH - 1], inst_a[DATA_WIDTH - 2:0]};
			wire zero_frac;
			assign zero_frac = inst_a[22:0] == 0;
			wire zero_exp;
			assign zero_exp = inst_a[30:23] == 0;
			assign classify[0] = inst_a == 32'hff800000;
			assign classify[1] = inst_a[31] && (~zero_exp || zero_frac);
			assign classify[2] = inst_a[31] && (zero_exp && ~zero_frac);
			assign classify[3] = (inst_a[31] && zero_exp) && zero_frac;
			assign classify[4] = (~inst_a[31] && zero_exp) && zero_frac;
			assign classify[5] = ~inst_a[31] && (zero_exp && ~zero_frac);
			assign classify[6] = ~inst_a[31] && (~zero_exp || zero_frac);
			assign classify[7] = inst_a == 32'h7f800000;
			assign classify[8] = 0;
			assign classify[9] = 0;
			assign classify[DATA_WIDTH - 1:10] = 1'sb0;
			always @(posedge clk)
				case (opcode)
					5'b01000: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= z0_inst;
					5'b01001: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= z1_inst;
					5'b01101: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= aeqb_inst;
					5'b01110: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= altb_inst;
					5'b01111: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= aeqb_inst || altb_inst;
					5'b01010: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= sgnj;
					5'b01011: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= sgnjn;
					5'b01100: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= sgnjx;
					5'b10000: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= vpermute[i * DATA_WIDTH+:DATA_WIDTH];
					default: vec_out[i * DATA_WIDTH+:DATA_WIDTH] <= 1'sb0;
				endcase
		end
	endgenerate
endmodule


