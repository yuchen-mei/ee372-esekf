module fpu #(
    parameter SIG_WIDTH       = 23,
    parameter EXP_WIDTH       = 8,
    parameter IEEE_COMPLIANCE = 0
) (
    input  logic [31:0] inst_a,
    input  logic [31:0] inst_b,
    input  logic [ 2:0] inst_rnd,
    input  logic        inst_DG_ctrl,
    input  logic [ 4:0] opcode,
    output logic [31:0] z_inst
);

    localparam DATA_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;

    logic                  aeqb_inst;
    logic                  altb_inst;
    logic                  agtb_inst;
    logic                  unordered_inst;
    logic [DATA_WIDTH-1:0] z0_inst;
    logic [DATA_WIDTH-1:0] z1_inst;
    logic [           7:0] status0_inst;
    logic [           7:0] status1_inst;
    logic [DATA_WIDTH-1:0] flt2i_inst;
    logic [           7:0] flt2i_status;
    logic [DATA_WIDTH-1:0] i2flt_inst;
    logic [           7:0] i2flt_status;
    logic [DATA_WIDTH-1:0] sgnj;
    logic [DATA_WIDTH-1:0] sgnjn;
    logic [DATA_WIDTH-1:0] sgnjx;
    logic [DATA_WIDTH-1:0] fclass_mask;

    DW_fp_cmp_DG #(
        .sig_width      (SIG_WIDTH      ),
        .exp_width      (EXP_WIDTH      ),
        .ieee_compliance(IEEE_COMPLIANCE)
    ) DW_fp_cmp_DG_inst (
        .a              (inst_a         ),
        .b              (inst_b         ),
        .zctr           (1'b0           ),
        .DG_ctrl        (inst_DG_ctrl   ),
        .aeqb           (aeqb_inst      ),
        .altb           (altb_inst      ),
        .agtb           (agtb_inst      ),
        .unordered      (unordered_inst ),
        .z0             (z0_inst        ),
        .z1             (z1_inst        ),
        .status0        (status0_inst   ),
        .status1        (status1_inst   )
    );

    DW_fp_flt2i #(
        .sig_width      (SIG_WIDTH      ),
        .exp_width      (EXP_WIDTH      ),
        .isize          (DATA_WIDTH     ),
        .ieee_compliance(IEEE_COMPLIANCE)
    ) DW_fp_flt2i_inst (
        .a              (inst_b         ),
        .rnd            (inst_rnd       ),
        .z              (flt2i_inst     ),
        .status         (flt2i_status   )
    );

    DW_fp_i2flt #(
        .sig_width      (SIG_WIDTH      ),
        .exp_width      (EXP_WIDTH      ),
        .isize          (DATA_WIDTH     ),
        .isign          (1              )
    ) DW_fp_i2flt_inst (
        .a              (inst_b         ),
        .rnd            (inst_rnd       ),
        .z              (i2flt_inst     ),
        .status         (i2flt_status   )
    );

    assign sgnj  = {inst_b[DATA_WIDTH-1], inst_a[DATA_WIDTH-2:0]};
    assign sgnjn = {~inst_b[DATA_WIDTH-1], inst_a[DATA_WIDTH-2:0]};
    assign sgnjx = {inst_a[DATA_WIDTH-1] ^ inst_b[DATA_WIDTH-1], inst_a[DATA_WIDTH-2:0]};

    wire zero_sig = (inst_b[SIG_WIDTH-1:0] == 0);
    wire zero_exp = (inst_b[SIG_WIDTH+:EXP_WIDTH] == 0);
    wire nan_exp  = &inst_b[SIG_WIDTH+:EXP_WIDTH];

    assign fclass_mask[0] = inst_b[31] && nan_exp && zero_sig;
    assign fclass_mask[1] = inst_b[31] && ~nan_exp && ~zero_exp;
    assign fclass_mask[2] = inst_b[31] && zero_exp && ~zero_sig;
    assign fclass_mask[3] = inst_b[31] && zero_exp && zero_sig;
    assign fclass_mask[4] = ~inst_b[31] && zero_exp && zero_sig;
    assign fclass_mask[5] = ~inst_b[31] && zero_exp && ~zero_sig;
    assign fclass_mask[6] = ~inst_b[31] && ~nan_exp && ~zero_exp;
    assign fclass_mask[7] = ~inst_b[31] && nan_exp && zero_sig;
    assign fclass_mask[8] = nan_exp && ~inst_b[SIG_WIDTH-1] && ~zero_sig;
    assign fclass_mask[9] = nan_exp && inst_b[SIG_WIDTH-1];
    assign fclass_mask[DATA_WIDTH-1:10] = '0;

    always_comb begin
        case (opcode)
            `FMIN:   z_inst = z0_inst;
            `FMAX:   z_inst = z1_inst;
            `FSGNJ:  z_inst = sgnj;
            `FSGNJN: z_inst = sgnjn;
            `FSGNJX: z_inst = sgnjx;
            `FCVTWS: z_inst = flt2i_inst;
            `FCVTSW: z_inst = i2flt_inst;
            `FCMPEQ: z_inst = aeqb_inst;
            `FCMPLT: z_inst = altb_inst;
            `FCMPLE: z_inst = aeqb_inst || altb_inst;
            `FCLASS: z_inst = fclass_mask;
            default: z_inst = '0;
        endcase
    end

endmodule
