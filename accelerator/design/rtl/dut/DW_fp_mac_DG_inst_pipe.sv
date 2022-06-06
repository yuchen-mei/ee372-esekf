module DW_fp_mac_DG_inst_pipe #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
	parameter NUM_STAGES      = 4
) (
    input  logic                           inst_clk,
    input  logic [SIG_WIDTH+EXP_WIDTH : 0] inst_a,
    input  logic [SIG_WIDTH+EXP_WIDTH : 0] inst_b,
    input  logic [SIG_WIDTH+EXP_WIDTH : 0] inst_c,
    input  logic [                  2 : 0] inst_rnd,
    input  logic                           inst_DG_ctrl,
    output logic [SIG_WIDTH+EXP_WIDTH : 0] z_inst,
    output logic [                  7 : 0] status_inst
);

    logic [SIG_WIDTH+EXP_WIDTH : 0] inst_a_reg;
    logic [SIG_WIDTH+EXP_WIDTH : 0] inst_b_reg;
    logic [SIG_WIDTH+EXP_WIDTH : 0] inst_c_reg;
    logic                           inst_DG_ctrl_reg;

    logic [SIG_WIDTH+EXP_WIDTH : 0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
    logic [SIG_WIDTH+EXP_WIDTH : 0] z_inst_internal;

    logic [7 : 0] status_inst_pipe1, status_inst_pipe2, status_inst_pipe3, status_inst_pipe4;
    logic [7 : 0] status_inst_internal;

    // Instance of DW_fp_mac_DG    
    DW_fp_mac_DG #(
        .sig_width      (SIG_WIDTH           ),
        .exp_width      (EXP_WIDTH           ),
        .ieee_compliance(IEEE_COMPLIANCE     )
    ) DW_fp_mac_DG_inst (
        .a              (inst_a_reg          ),
        .b              (inst_b_reg          ),
        .c              (inst_c_reg          ),
        .rnd            (inst_rnd            ),
        .DG_ctrl        (inst_DG_ctrl_reg    ),
        .z              (z_inst_internal     ),
        .status         (status_inst_internal)
    );

    always @(posedge inst_clk) begin
        inst_a_reg <= inst_a;
        inst_b_reg <= inst_b;
        inst_c_reg <= inst_c;
        inst_DG_ctrl_reg <= inst_DG_ctrl;

        //Output to be registered by only allowing 5 pipeline stages to be moved

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

