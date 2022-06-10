module instruction_fetch (
	clk,
	rst_n,
	en,
	jump_reg,
	jr_pc,
	pc
);
	parameter ADDR_WIDTH = 8;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire jump_reg;
	input wire [ADDR_WIDTH - 1:0] jr_pc;
	output wire [ADDR_WIDTH - 1:0] pc;
	reg [ADDR_WIDTH - 1:0] pc_pipe1;
	reg [ADDR_WIDTH - 1:0] pc_pipe2;
	wire [ADDR_WIDTH - 1:0] pc_next;
	assign pc = (en ? pc_pipe1 : pc_pipe2);
	assign pc_next = (jump_reg ? jr_pc : pc + 1);
	always @(posedge clk)
		if (~rst_n) begin
			pc_pipe1 <= 0;
			pc_pipe2 <= 0;
		end
		else if (en) begin
			pc_pipe1 <= pc_next;
			pc_pipe2 <= pc_pipe1;
		end
endmodule