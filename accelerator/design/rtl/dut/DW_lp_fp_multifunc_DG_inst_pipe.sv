module DW_lp_fp_multifunc_DG_inst_pipe #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter NUM_STAGES      = 4
) (
    input  logic                         inst_clk,
    input  logic [SIG_WIDTH+EXP_WIDTH:0] inst_a,
    input  logic                   [2:0] inst_func,
    input  logic                   [2:0] inst_rnd,
    input  logic                         inst_DG_ctrl,
    output logic [SIG_WIDTH+EXP_WIDTH:0] z_inst,
    output logic                   [7:0] status_inst
);

    logic [SIG_WIDTH+EXP_WIDTH:0] inst_a_reg;
    logic                  [15:0] inst_func_reg;
    logic                         inst_DG_ctrl_reg;

    logic [SIG_WIDTH+EXP_WIDTH:0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
    logic [SIG_WIDTH+EXP_WIDTH:0] z_inst_internal;

    logic [7:0] status_inst_pipe1, status_inst_pipe2, status_inst_pipe3, status_inst_pipe4;
    logic [7:0] status_inst_internal;

    DW_lp_fp_multifunc_DG #(
        .sig_width      ( SIG_WIDTH            ),
        .exp_width      ( EXP_WIDTH            ),
        .ieee_compliance( IEEE_COMPLIANCE      ),
        .func_select    ( 127                  ),
        .pi_multiple    ( 0                    )
    ) DW_lp_fp_multifunc_DG_inst (
        .a              ( inst_a_reg           ),
        .func           ( inst_func_reg        ),
        .rnd            ( inst_rnd             ),
        .DG_ctrl        ( inst_DG_ctrl_reg     ),
        .z              ( z_inst_internal      ),
        .status         ( status_inst_internal )
    );

    always @(posedge inst_clk) begin
        inst_a_reg       <= inst_a;
        inst_DG_ctrl_reg <= inst_DG_ctrl;

        case (inst_func)
            3'b000:  inst_func_reg <= 16'b00000001; // reciprocal, 1/A
            3'b001:  inst_func_reg <= 16'b00000010; // square root of A
            3'b010:  inst_func_reg <= 16'b00000100; // reciprocal square root of A
            3'b011:  inst_func_reg <= 16'b00001000; // sine, sin(A)
            3'b100:  inst_func_reg <= 16'b00010000; // cosine, cos(A)
            3'b101:  inst_func_reg <= 16'b00100000; // base-2 logarithm
            3'b110:  inst_func_reg <= 16'b01000000; // base-2 exponential
            default: inst_func_reg <= 16'b00000000;
        endcase

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

