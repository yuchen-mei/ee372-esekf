module multifunc_unit #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0,
    parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic                  en,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic [           2:0] funct,
    input  logic [           2:0] rnd,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic [           7:0] status
);

    logic [4:0] func_i;

    always_comb begin
        case (funct)
            3'b000:  func_i = 5'b00001; // reciprocal, 1/A
            3'b001:  func_i = 5'b00010; // square root of A
            3'b010:  func_i = 5'b00100; // reciprocal square root of A
            3'b011:  func_i = 5'b01000; // sine, sin(A)
            3'b100:  func_i = 5'b10000; // cosine, cos(A)
            default: func_i = 5'b00001;
        endcase
    end

    DW_lp_fp_multifunc_DG #(
        .sig_width      (SIG_WIDTH      ),
        .exp_width      (EXP_WIDTH      ),
        .ieee_compliance(IEEE_COMPLIANCE),
        .func_select    (7'b11111       ),
        .pi_multiple    (1'b0           )
    ) DW_lp_fp_multifunc_DG_inst (
        .a              (data_in        ),
        .func           ({11'b0, func_i}),
        .rnd            (rnd            ),
        .DG_ctrl        (en             ),
        .z              (data_out       ),
        .status         (status         )
    );

endmodule
