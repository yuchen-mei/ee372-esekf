module DW_fp_dp4_inst_pipe #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter ARCH_TYPE       = 1,
	parameter NUM_STAGES      = 4
) (
	input  logic                         inst_clk,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_a,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_b,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_c,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_d,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_e,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_f,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_g,
	input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_h,
	input  logic                   [2:0] inst_rnd,
	output logic [SIG_WIDTH+EXP_WIDTH:0] z_inst,
	output logic                   [7:0] status_inst
);

	logic [SIG_WIDTH+EXP_WIDTH:0] inst_a_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_b_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_c_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_d_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_e_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_f_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_g_reg;
	logic [SIG_WIDTH+EXP_WIDTH:0] inst_h_reg;

	logic [SIG_WIDTH+EXP_WIDTH:0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
	logic [SIG_WIDTH+EXP_WIDTH:0] z_inst_internal;

	logic [7:0] status_inst_pipe1, status_inst_pipe2, status_inst_pipe3, status_inst_pipe4;
	logic [7:0] status_inst_internal;

    // Instance of DW_fp_dp4
    DW_fp_dp4 #(
		.sig_width      ( SIG_WIDTH            ),
		.exp_width      ( EXP_WIDTH            ),
		.ieee_compliance( IEEE_COMPLIANCE      ),
		.arch_type      ( ARCH_TYPE            )
	) U1 (
		.a              ( inst_a_reg           ),
		.b              ( inst_b_reg           ),
		.c              ( inst_c_reg           ),
		.d              ( inst_d_reg           ),
		.e              ( inst_e_reg           ),
		.f              ( inst_f_reg           ),
		.g              ( inst_g_reg           ),
		.h              ( inst_h_reg           ),
		.rnd            ( inst_rnd             ),
		.z              ( z_inst_internal      ),
		.status         ( status_inst_internal )
	);

	always @(posedge inst_clk) begin
		inst_a_reg <= inst_a;
		inst_b_reg <= inst_b;
		inst_c_reg <= inst_c;
		inst_d_reg <= inst_d;
		inst_e_reg <= inst_e;
		inst_f_reg <= inst_f;
		inst_g_reg <= inst_g;
		inst_h_reg <= inst_h;

		// Output to be registered by only allowing 5 pipeline stages to be moved

		z_inst_pipe1 <= z_inst_internal;
		z_inst_pipe2 <= z_inst_pipe1;
		z_inst_pipe3 <= z_inst_pipe2;
		z_inst_pipe4 <= z_inst_pipe3;

		status_inst_pipe1 <= status_inst_internal;
		status_inst_pipe2 <= status_inst_pipe1;
		status_inst_pipe3 <= status_inst_pipe2;
		status_inst_pipe4 <= status_inst_pipe3;
	end

	assign z_inst = (NUM_STAGES == 5) ? z_inst_pipe4 :
					(NUM_STAGES == 4) ? z_inst_pipe3 :
					(NUM_STAGES == 3) ? z_inst_pipe2 : z_inst_pipe1;

	assign status_inst = (NUM_STAGES == 5) ? status_inst_pipe4 :
						 (NUM_STAGES == 4) ? status_inst_pipe3 :
						 (NUM_STAGES == 3) ? status_inst_pipe2 : status_inst_pipe1;

endmodule

