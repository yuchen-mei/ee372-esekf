module multifunc_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter NUM_STAGES      = 2,
    parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic                  clk,
    input  logic                  en,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic            [2:0] funct,
    input  logic            [2:0] rnd,
    output logic [DATA_WIDTH-1:0] data_out
);
    logic [           7:0] status;
    logic [          15:0] inst_func;
    logic [DATA_WIDTH-1:0] z_inst_pipe1, z_inst_pipe2, z_inst_pipe3, z_inst_pipe4;
    logic [DATA_WIDTH-1:0] z_inst_internal;

    always_comb begin
        case (funct)
            3'b000:  inst_func = 16'b0000_0001; // reciprocal, 1/A
            3'b001:  inst_func = 16'b0000_0010; // square root of A
            3'b010:  inst_func = 16'b0000_0100; // reciprocal square root of A
            3'b011:  inst_func = 16'b0000_1000; // sine, sin(A)
            3'b100:  inst_func = 16'b0001_0000; // cosine, cos(A)
            3'b101:  inst_func = 16'b0010_0000; // base-2 logarithm
            3'b110:  inst_func = 16'b0100_0000; // base-2 exponential
            default: inst_func = 16'b0000_0000;
        endcase
    end

    DW_lp_fp_multifunc_DG #(
        .sig_width      (SIG_WIDTH      ),
        .exp_width      (EXP_WIDTH      ),
        .ieee_compliance(IEEE_COMPLIANCE),
        .func_select    (127            ),
        .pi_multiple    (0              )
    ) DW_lp_fp_multifunc_DG_inst (
        .a              (data_in        ),
        .func           (inst_func      ),
        .rnd            (rnd            ),
        .DG_ctrl        (en             ),
        .z              (z_inst_internal),
        .status         (status         )
    );

    // assign data_out = z_inst_internal;

    always @(posedge clk) begin
        z_inst_pipe1 <= z_inst_internal;
        z_inst_pipe2 <= z_inst_pipe1;
        z_inst_pipe3 <= z_inst_pipe2;
        z_inst_pipe4 <= z_inst_pipe3;
    end

    assign data_out = (NUM_STAGES == 4) ? z_inst_pipe4 :
                      (NUM_STAGES == 3) ? z_inst_pipe3 :
                      (NUM_STAGES == 2) ? z_inst_pipe2 : z_inst_pipe1;

endmodule
