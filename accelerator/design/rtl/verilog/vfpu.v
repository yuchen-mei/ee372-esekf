module vfpu (
	clk,
	en,
	vec_a,
	vec_b,
	vec_c,
	opcode,
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
	input wire [4:0] opcode;
	input wire [2:0] funct;
	input wire [2:0] rnd;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out;
	genvar i;
	generate
		for (i = 0; i < VECTOR_LANES; i = i + 1) begin : genblk1
			wire [DATA_WIDTH - 1:0] inst_a;
			reg [DATA_WIDTH - 1:0] inst_b;
			reg [DATA_WIDTH - 1:0] inst_c;
			wire [DATA_WIDTH - 1:0] z_inst;
			wire [7:0] status_inst;
			wire [DATA_WIDTH - 1:0] b_neg;
			wire [DATA_WIDTH - 1:0] c_neg;
			assign b_neg = {~vec_b[(i * DATA_WIDTH) + (DATA_WIDTH - 1)], vec_b[(i * DATA_WIDTH) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 2 : ((DATA_WIDTH - 2) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)) - 1)-:((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)]};
			assign c_neg = {~vec_c[(i * DATA_WIDTH) + (DATA_WIDTH - 1)], vec_c[(i * DATA_WIDTH) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 2 : ((DATA_WIDTH - 2) + ((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)) - 1)-:((DATA_WIDTH - 2) >= 0 ? DATA_WIDTH - 1 : 3 - DATA_WIDTH)]};
			assign inst_a = (funct == 3'b101 ? vec_a[0+:DATA_WIDTH] : vec_a[i * DATA_WIDTH+:DATA_WIDTH]);
			always @(*) begin
				case (opcode)
					5'b00000, 5'b00001: inst_b = 32'h3f800000;
					5'b00110, 5'b00111: inst_b = b_neg;
					default: inst_b = vec_b[i * DATA_WIDTH+:DATA_WIDTH];
				endcase
				case (opcode)
					5'b00000: inst_c = vec_b[i * DATA_WIDTH+:DATA_WIDTH];
					5'b00001: inst_c = b_neg;
					5'b00010: inst_c = 32'b00000000000000000000000000000000;
					5'b00101, 5'b00110: inst_c = c_neg;
					default: inst_c = vec_c[i * DATA_WIDTH+:DATA_WIDTH];
				endcase
			end
			DW_fp_mac_DG_inst_pipe #(
				.SIG_WIDTH(SIG_WIDTH),
				.EXP_WIDTH(EXP_WIDTH),
				.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
				.NUM_STAGES(NUM_STAGES)
			) U1(
				.inst_clk(clk),
				.inst_a(inst_a),
				.inst_b(inst_b),
				.inst_c(inst_c),
				.inst_rnd(rnd),
				.inst_DG_ctrl(en),
				.z_inst(vec_out[i * DATA_WIDTH+:DATA_WIDTH]),
				.status_inst(status_inst)
			);
		end
	endgenerate
endmodule


