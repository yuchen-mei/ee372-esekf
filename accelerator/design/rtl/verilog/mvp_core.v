module mvp_core (
	clk,
	rst_n,
	en,
	pc,
	instr,
	mem_addr,
	mem_ren,
	mem_we,
	mem_rdata,
	mem_wdata,
	width,
	data_out_vld,
	data_out,
	reg_wb
);
	parameter SIG_WIDTH = 23;
	parameter EXP_WIDTH = 8;
	parameter IEEE_COMPLIANCE = 0;
	parameter VECTOR_LANES = 16;
	parameter ADDR_WIDTH = 12;
	parameter DATA_WIDTH = (SIG_WIDTH + EXP_WIDTH) + 1;
	parameter INSTR_MEM_ADDR_WIDTH = 8;
	parameter DATA_MEM_ADDR_WIDTH = 12;
	parameter REG_BANK_DEPTH = 32;
	parameter REG_ADDR_WIDTH = $clog2(REG_BANK_DEPTH);
	input wire clk;
	input wire rst_n;
	input wire en;
	output wire [INSTR_MEM_ADDR_WIDTH - 1:0] pc;
	input wire [31:0] instr;
	output wire [ADDR_WIDTH - 1:0] mem_addr;
	output wire mem_ren;
	output wire mem_we;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_rdata;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_wdata;
	output wire [2:0] width;
	output wire data_out_vld;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] data_out;
	output wire [4:0] reg_wb;
	reg en_q;
	wire stall;
	wire [4:0] opcode_id;
	reg [4:0] opcode_ex1;
	wire [4:0] vd_addr_id;
	reg [4:0] vd_addr_ex1;
	reg [4:0] vd_addr_ex2;
	reg [4:0] vd_addr_ex3;
	reg [4:0] vd_addr_ex4;
	reg [4:0] vd_addr_wb;
	wire [4:0] vs1_addr_id;
	reg [4:0] vs1_addr_ex1;
	wire [4:0] vs2_addr_id;
	reg [4:0] vs2_addr_ex1;
	wire [4:0] vs3_addr_id;
	reg [4:0] vs3_addr_ex1;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vs1_data_id;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vs1_data_ex1;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vs2_data_id;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vs2_data_ex1;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vs3_data_id;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vs3_data_ex1;
	wire [DATA_WIDTH - 1:0] rs1_data_id;
	wire [DATA_WIDTH - 1:0] rs2_data_id;
	wire [DATA_WIDTH - 1:0] rs3_data_id;
	wire [2:0] funct3_id;
	reg [2:0] funct3_ex1;
	wire [3:0] wb_sel_id;
	reg [3:0] wb_sel_ex1;
	reg [3:0] wb_sel_ex2;
	reg [3:0] wb_sel_ex3;
	reg [3:0] wb_sel_ex4;
	reg [3:0] wb_sel_wb;
	wire reg_we_id;
	reg reg_we_ex1;
	reg reg_we_ex2;
	reg reg_we_ex3;
	reg reg_we_ex4;
	reg reg_we_wb;
	wire mem_we_id;
	reg mem_we_ex1;
	wire [ADDR_WIDTH - 1:0] mem_addr_id;
	reg [ADDR_WIDTH - 1:0] mem_addr_ex1;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_rdata_ex3;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_rdata_ex4;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] mem_rdata_wb;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] reg_wdata_wb;
	wire [INSTR_MEM_ADDR_WIDTH - 1:0] jr_pc_id;
	wire jump_reg_id;
	assign data_out = reg_wdata_wb;
	assign data_out_vld = en && reg_we_wb;
	assign reg_wb = vd_addr_wb;
	always @(posedge clk) begin
		en_q <= en;
		if (data_out_vld) begin
			begin : sv2v_autoblock_1
				reg signed [31:0] i;
				for (i = VECTOR_LANES - 1; i >= 0; i = i - 1)
					$write("%h_", reg_wdata_wb[i * DATA_WIDTH+:DATA_WIDTH]);
			end
			$display;
		end
	end
	instruction_fetch #(.ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH)) if_stage(
		.clk(clk),
		.rst_n(rst_n),
		.en(en & ~stall),
		.jump_reg(jump_reg_id),
		.jr_pc(jr_pc_id),
		.pc(pc)
	);
	assign jr_pc_id = mem_addr_id[INSTR_MEM_ADDR_WIDTH - 1:0];
	decoder decoder_inst(
		.instr(instr),
		.vd_addr(vd_addr_id),
		.vs1_addr(vs1_addr_id),
		.vs2_addr(vs2_addr_id),
		.vs3_addr(vs3_addr_id),
		.mem_addr(mem_addr_id),
		.func_sel(opcode_id),
		.funct3(funct3_id),
		.wb_sel(wb_sel_id),
		.masking(),
		.mem_we(mem_we_id),
		.reg_we(reg_we_id),
		.jump(jump_reg_id),
		.vd_addr_ex1(vd_addr_ex1),
		.vd_addr_ex2(vd_addr_ex2),
		.vd_addr_ex3(vd_addr_ex3),
		.reg_we_ex1(reg_we_ex1),
		.reg_we_ex2(reg_we_ex2),
		.reg_we_ex3(reg_we_ex3),
		.wb_sel_ex1(wb_sel_ex1),
		.wb_sel_ex2(wb_sel_ex2),
		.wb_sel_ex3(wb_sel_ex3),
		.stall(stall)
	);
	vrf #(
		.ADDR_WIDTH(REG_ADDR_WIDTH),
		.DEPTH(REG_BANK_DEPTH),
		.DATA_WIDTH(VECTOR_LANES * DATA_WIDTH)
	) vrf_inst(
		.clk(clk),
		.rst_n(rst_n),
		.wen(en && reg_we_wb),
		.addr_w(vd_addr_wb),
		.data_w(reg_wdata_wb),
		.addr_r1(vs1_addr_id),
		.data_r1(vs1_data_id),
		.addr_r2(vs2_addr_id),
		.data_r2(vs2_data_id),
		.addr_r3(vs3_addr_id),
		.data_r3(vs3_data_id)
	);
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] operand_a;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] operand_b;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] operand_c;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out_ex2;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out_ex3;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out_ex4;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out_wb;
	wire [DATA_WIDTH - 1:0] mfu_out_ex4;
	reg [DATA_WIDTH - 1:0] mfu_out_wb;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vfu_out_ex4;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] vfu_out_wb;
	wire [(9 * DATA_WIDTH) - 1:0] mat_out_wb;
	wire [7:0] status_inst;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] stage2_forward;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] stage3_forward;
	reg [(VECTOR_LANES * DATA_WIDTH) - 1:0] stage4_forward;
	assign stage2_forward = vec_out_ex2;
	assign stage3_forward = (wb_sel_ex3[3] ? mem_rdata_ex3 : vec_out_ex3);
	always @(*)
		case (wb_sel_ex4)
			4'b0001: stage4_forward = mfu_out_ex4;
			4'b0010: stage4_forward = vfu_out_ex4;
			4'b1000: stage4_forward = mem_rdata_ex4;
			default: stage4_forward = vec_out_ex4;
		endcase
	assign operand_a = (((vs1_addr_ex1 == vd_addr_ex2) && reg_we_ex2) && ~|wb_sel_ex2 ? stage2_forward : (((vs1_addr_ex1 == vd_addr_ex3) && reg_we_ex3) && ~|wb_sel_ex3[2:0] ? stage3_forward : (((vs1_addr_ex1 == vd_addr_ex4) && reg_we_ex4) && ~wb_sel_ex4[2] ? stage4_forward : ((vs1_addr_ex1 == vd_addr_wb) && reg_we_wb ? reg_wdata_wb : vs1_data_ex1))));
	assign operand_b = (((vs2_addr_ex1 == vd_addr_ex2) && reg_we_ex2) && ~|wb_sel_ex2 ? stage2_forward : (((vs2_addr_ex1 == vd_addr_ex3) && reg_we_ex3) && ~|wb_sel_ex3[2:0] ? stage3_forward : (((vs2_addr_ex1 == vd_addr_ex4) && reg_we_ex4) && ~wb_sel_ex4[2] ? stage4_forward : ((vs2_addr_ex1 == vd_addr_wb) && reg_we_wb ? reg_wdata_wb : vs2_data_ex1))));
	assign operand_c = (((vs3_addr_ex1 == vd_addr_ex2) && reg_we_ex2) && ~|wb_sel_ex2 ? stage2_forward : (((vs3_addr_ex1 == vd_addr_ex3) && reg_we_ex3) && ~|wb_sel_ex3[2:0] ? stage3_forward : (((vs3_addr_ex1 == vd_addr_ex4) && reg_we_ex4) && ~wb_sel_ex4[2] ? stage4_forward : ((vs3_addr_ex1 == vd_addr_wb) && reg_we_wb ? reg_wdata_wb : vs3_data_ex1))));
	vector_unit #(
		.SIG_WIDTH(SIG_WIDTH),
		.EXP_WIDTH(EXP_WIDTH),
		.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
		.VECTOR_LANES(VECTOR_LANES)
	) vector_unit_inst(
		.clk(clk),
		.en(~|wb_sel_ex1),
		.vec_a(operand_a),
		.vec_b(operand_b),
		.rnd(3'b000),
		.opcode(opcode_ex1),
		.funct(funct3_ex1),
		.vec_out(vec_out_ex2)
	);
	vfpu #(
		.SIG_WIDTH(SIG_WIDTH),
		.EXP_WIDTH(EXP_WIDTH),
		.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
		.VECTOR_LANES(VECTOR_LANES),
		.NUM_STAGES(3)
	) vfpu_inst(
		.clk(clk),
		.en(wb_sel_ex1[1]),
		.vec_a(operand_a),
		.vec_b(operand_b),
		.vec_c(operand_c),
		.rnd(3'b000),
		.opcode(opcode_ex1),
		.funct(funct3_ex1),
		.vec_out(vfu_out_ex4)
	);
	dot_product_unit #(
		.SIG_WIDTH(SIG_WIDTH),
		.EXP_WIDTH(EXP_WIDTH),
		.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
		.VECTOR_LANES(9),
		.NUM_STAGES(4)
	) dp_unit_inst(
		.clk(clk),
		.en(wb_sel_ex1[2]),
		.vec_a(operand_a[0+:DATA_WIDTH * 9]),
		.vec_b(operand_b[0+:DATA_WIDTH * 9]),
		.vec_c(operand_c[0+:DATA_WIDTH * 9]),
		.rnd(3'b000),
		.funct(funct3_ex1),
		.vec_out(mat_out_wb)
	);
	DW_lp_fp_multifunc_DG_inst_pipe #(
		.SIG_WIDTH(SIG_WIDTH),
		.EXP_WIDTH(EXP_WIDTH),
		.IEEE_COMPLIANCE(IEEE_COMPLIANCE),
		.NUM_STAGES(3)
	) mfu_inst(
		.inst_clk(clk),
		.inst_a(operand_a[0+:DATA_WIDTH]),
		.inst_func(funct3_ex1),
		.inst_rnd(3'b000),
		.inst_DG_ctrl(wb_sel_ex1[0]),
		.z_inst(mfu_out_ex4),
		.status_inst(status_inst)
	);
	assign mem_addr = mem_addr_ex1;
	assign mem_we = mem_we_ex1;
	assign mem_ren = wb_sel_ex1[3];
	assign mem_wdata = operand_c;
	assign width = funct3_ex1;
	always @(*)
		case (wb_sel_wb)
			4'b0001: reg_wdata_wb = mfu_out_wb;
			4'b0010: reg_wdata_wb = vfu_out_wb;
			4'b0100: reg_wdata_wb = mat_out_wb;
			4'b1000: reg_wdata_wb = mem_rdata_wb;
			default: reg_wdata_wb = vec_out_wb;
		endcase
	always @(posedge clk)
		if (~rst_n) begin
			vs1_addr_ex1 <= 1'sb0;
			vs2_addr_ex1 <= 1'sb0;
			vs3_addr_ex1 <= 1'sb0;
			mem_addr_ex1 <= 1'sb0;
			vs1_data_ex1 <= 1'sb0;
			vs2_data_ex1 <= 1'sb0;
			vs3_data_ex1 <= 1'sb0;
			vd_addr_ex1 <= 1'sb0;
			vd_addr_ex2 <= 1'sb0;
			vd_addr_ex3 <= 1'sb0;
			vd_addr_ex4 <= 1'sb0;
			vd_addr_wb <= 1'sb0;
			opcode_ex1 <= 1'sb0;
			funct3_ex1 <= 1'sb0;
			mem_we_ex1 <= 1'sb0;
			reg_we_ex1 <= 1'sb0;
			reg_we_ex2 <= 1'sb0;
			reg_we_ex3 <= 1'sb0;
			reg_we_ex4 <= 1'sb0;
			reg_we_wb <= 1'sb0;
			wb_sel_ex1 <= 1'sb0;
			wb_sel_ex2 <= 1'sb0;
			wb_sel_ex3 <= 1'sb0;
			wb_sel_ex4 <= 1'sb0;
			wb_sel_wb <= 1'sb0;
			vec_out_ex3 <= 1'sb0;
			vec_out_ex4 <= 1'sb0;
			vec_out_wb <= 1'sb0;
			vfu_out_wb <= 1'sb0;
			mfu_out_wb <= 1'sb0;
			mem_rdata_ex3 <= 1'sb0;
			mem_rdata_ex4 <= 1'sb0;
			mem_rdata_wb <= 1'sb0;
		end
		else if (en && (en_q || (pc != 0))) begin
			vs1_addr_ex1 <= vs1_addr_id;
			vs2_addr_ex1 <= vs2_addr_id;
			vs3_addr_ex1 <= vs3_addr_id;
			mem_addr_ex1 <= mem_addr_id;
			vs1_data_ex1 <= vs1_data_id;
			vs2_data_ex1 <= vs2_data_id;
			vs3_data_ex1 <= vs3_data_id;
			vd_addr_ex1 <= vd_addr_id;
			vd_addr_ex2 <= vd_addr_ex1;
			vd_addr_ex3 <= vd_addr_ex2;
			vd_addr_ex4 <= vd_addr_ex3;
			vd_addr_wb <= vd_addr_ex4;
			opcode_ex1 <= opcode_id;
			funct3_ex1 <= funct3_id;
			mem_we_ex1 <= mem_we_id && ~stall;
			reg_we_ex1 <= reg_we_id && ~stall;
			reg_we_ex2 <= reg_we_ex1;
			reg_we_ex3 <= reg_we_ex2;
			reg_we_ex4 <= reg_we_ex3;
			reg_we_wb <= reg_we_ex4;
			wb_sel_ex1 <= (~stall ? wb_sel_id : {4 {1'sb0}});
			wb_sel_ex2 <= wb_sel_ex1;
			wb_sel_ex3 <= wb_sel_ex2;
			wb_sel_ex4 <= wb_sel_ex3;
			wb_sel_wb <= wb_sel_ex4;
			vec_out_ex3 <= vec_out_ex2;
			vec_out_ex4 <= vec_out_ex3;
			vec_out_wb <= vec_out_ex4;
			vfu_out_wb <= vfu_out_ex4;
			mfu_out_wb <= mfu_out_ex4;
			mem_rdata_ex3 <= mem_rdata;
			mem_rdata_ex4 <= mem_rdata_ex3;
			mem_rdata_wb <= mem_rdata_ex4;
		end
endmodule


