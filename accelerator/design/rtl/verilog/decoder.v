module decoder (
	instr,
	vd_addr,
	vs1_addr,
	vs2_addr,
	vs3_addr,
	func_sel,
	funct3,
	wb_sel,
	masking,
	reg_we,
	jump,
	mem_we,
	mem_addr,
	vd_addr_ex1,
	vd_addr_ex2,
	vd_addr_ex3,
	reg_we_ex1,
	reg_we_ex2,
	reg_we_ex3,
	wb_sel_ex1,
	wb_sel_ex2,
	wb_sel_ex3,
	stall
);
	input wire [31:0] instr;
	output wire [4:0] vd_addr;
	output wire [4:0] vs1_addr;
	output wire [4:0] vs2_addr;
	output wire [4:0] vs3_addr;
	output reg [4:0] func_sel;
	output wire [2:0] funct3;
	output reg [3:0] wb_sel;
	output wire masking;
	output wire reg_we;
	output wire jump;
	output wire mem_we;
	output wire [11:0] mem_addr;
	input wire [4:0] vd_addr_ex1;
	input wire [4:0] vd_addr_ex2;
	input wire [4:0] vd_addr_ex3;
	input wire reg_we_ex1;
	input wire reg_we_ex2;
	input wire reg_we_ex3;
	input wire [3:0] wb_sel_ex1;
	input wire [3:0] wb_sel_ex2;
	input wire [3:0] wb_sel_ex3;
	output wire stall;
	wire [6:0] opcode;
	wire [4:0] dest;
	wire [4:0] src1;
	wire [4:0] src2;
	wire [5:0] funct6;
	assign opcode = instr[6:0];
	assign dest = instr[11:7];
	assign funct3 = instr[14:12];
	assign src1 = instr[19:15];
	assign src2 = instr[24:20];
	assign masking = instr[25];
	assign funct6 = instr[31:26];
	wire overwrite_multiplicand;
	assign overwrite_multiplicand = (((opcode == 6'b101100) || (opcode == 6'b101101)) || (opcode == 6'b101110)) || (opcode == 6'b101111);
	assign vs1_addr = src1;
	assign vs2_addr = (overwrite_multiplicand ? dest : src2);
	assign vs3_addr = (opcode == 7'b0001011 ? instr[31:27] : (overwrite_multiplicand ? src2 : dest));
	assign vd_addr = dest;
	always @(*) begin
		case ({opcode, funct6})
			13'b1010111000000: func_sel = 5'b00000;
			13'b1010111000010: func_sel = 5'b00001;
			13'b1010111000100: func_sel = 5'b01000;
			13'b1010111000110: func_sel = 5'b01001;
			13'b1010111001000: func_sel = 5'b01010;
			13'b1010111001001: func_sel = 5'b01011;
			13'b1010111001010: func_sel = 5'b01100;
			13'b1010111011000: func_sel = 5'b01101;
			13'b1010111011001: func_sel = 5'b01111;
			13'b1010111011011: func_sel = 5'b01110;
			13'b1010111100100: func_sel = 5'b00010;
			13'b1010111101000: func_sel = 5'b00100;
			13'b1010111101001: func_sel = 5'b00110;
			13'b1010111101010: func_sel = 5'b00101;
			13'b1010111101011: func_sel = 5'b00111;
			13'b1010111101100: func_sel = 5'b00100;
			13'b1010111101101: func_sel = 5'b00110;
			13'b1010111101110: func_sel = 5'b00101;
			13'b1010111101111: func_sel = 5'b00111;
			13'b1010111010010: func_sel = 5'b10000;
			default: func_sel = 5'b00000;
		endcase
		case (opcode)
			7'b1010011: wb_sel = 4'b0001;
			7'b1010111: wb_sel = 4'b0010;
			7'b0001011: wb_sel = 4'b0100;
			7'b0000111: wb_sel = 4'b1000;
			default: wb_sel = 4'b0000;
		endcase
		if (|func_sel[4:3])
			wb_sel = 4'b0000;
	end
	assign mem_addr = instr[31:20];
	assign mem_we = opcode == 7'b0100111;
	assign jump = opcode == 7'b1100111;
	assign reg_we = ~mem_we && ~jump;
	wire stage1_dependency;
	wire stage2_dependency;
	wire stage3_dependency;
	assign stage1_dependency = (((vs1_addr == vd_addr_ex1) || (vs2_addr == vd_addr_ex1)) || (vs3_addr == vd_addr_ex1)) && reg_we_ex1;
	assign stage2_dependency = (((vs1_addr == vd_addr_ex2) || (vs2_addr == vd_addr_ex2)) || (vs3_addr == vd_addr_ex2)) && reg_we_ex2;
	assign stage3_dependency = (((vs1_addr == vd_addr_ex3) || (vs2_addr == vd_addr_ex3)) || (vs3_addr == vd_addr_ex3)) && reg_we_ex3;
	assign stall = ((stage1_dependency && |wb_sel_ex1) || (stage2_dependency && |wb_sel_ex2[2:0])) || (stage3_dependency && wb_sel_ex3[2]);
endmodule


