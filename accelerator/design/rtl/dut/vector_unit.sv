module vector_unit #(
    parameter  SIG_WIDTH       = 23,
    parameter  EXP_WIDTH       = 8,
    parameter  IEEE_COMPLIANCE = 0,
    parameter  VECTOR_LANES    = 16,
    localparam DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
) (
    input  logic                                    clk,
    input  logic                                    en,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_a,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_b,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_c,
    input  logic [             4:0]                 opcode,
    input  logic [             2:0]                 funct,
    input  logic [             4:0]                 imm,
    input  logic [             2:0]                 rnd,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    // Vector permutation
    logic [             8:0][DATA_WIDTH-1:0] skew_mat;
    logic [             8:0][DATA_WIDTH-1:0] transpose;
    logic [             8:0][DATA_WIDTH-1:0] identity;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vslide_up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vslide_down;

    skew_symmetric #(DATA_WIDTH) vector_skew_inst    (.vec_a(vec_a[8:0]), .vec_out(skew_mat));
    vslide_up      #(DATA_WIDTH) vslide_up_inst      (.vsrc(vec_b), .vdest(vec_c), .shamt(imm), .vec_out(vslide_up  ));
    vslide_down    #(DATA_WIDTH) vslide_down_inst    (.vsrc(vec_b), .vdest(vec_c), .shamt(imm), .vec_out(vslide_down));

    for (genvar i = 0; i < 3; i = i + 1) begin
        for (genvar j = 0; j < 3; j = j + 1) begin
            assign transpose[3*i+j] = vec_a[3*j+i];
        end
    end

    logic [EXP_WIDTH + SIG_WIDTH:0] one;
    logic [EXP_WIDTH - 1:0] one_exp;
    logic [SIG_WIDTH - 1:0] one_sig;

    // integer number 1 with the FP number format
    assign one_exp = ((1 << (EXP_WIDTH-1)) - 1);
    assign one_sig = 0;
    assign one = {1'b0, one_exp, one_sig}; // fp(1)

    assign identity = {one, 32'h0, 32'h0, 32'h0, one, 32'h0, 32'h0, 32'h0, one};

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vfpu;

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        logic [DATA_WIDTH-1:0] inst_a;
        logic [DATA_WIDTH-1:0] inst_b;

        assign inst_a = (funct == 3'b101) ? vec_a[0] : vec_a[i];
        assign inst_b = vec_b[i];

        fpu #(
            .SIG_WIDTH      (SIG_WIDTH      ),
            .EXP_WIDTH      (EXP_WIDTH      ),
            .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
        ) fpu_inst (
            .inst_a         (inst_a         ),
            .inst_b         (inst_b         ),
            .inst_rnd       (rnd            ),
            .inst_DG_ctrl   (en             ),
            .opcode         (opcode         ),
            .z_inst         (vfpu[i]        )
        );
    end

    always @(posedge clk) begin
        case (opcode)
            `SLIDEUP:   vec_out <= vslide_up;
            `SLIDEDOWN: vec_out <= vslide_down;
            `SKEW:      vec_out <= skew_mat;
            `TRANSPOSE: vec_out <= transpose;
            `IDENTITY:  vec_out <= identity;
            default:    vec_out <= vfpu;
        endcase
    end

endmodule
