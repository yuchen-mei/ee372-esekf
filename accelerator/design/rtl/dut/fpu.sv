// module fpu #(
//     parameter SIG_WIDTH       = 23,
//     parameter EXP_WIDTH       = 8,
//     parameter IEEE_COMPLIANCE = 0,
//     parameter VECTOR_LANES    = 16,
//     parameter DATA_WIDTH      = SIG_WIDTH + EXP_WIDTH + 1
// ) (
//     input  wire                                    en,
//     input  wire [VECTOR_LANES-1:0][DATA_WIDTH-1:0] data_a,
//     input  wire [VECTOR_LANES-1:0][DATA_WIDTH-1:0] data_b,
//     input  wire [VECTOR_LANES-1:0][DATA_WIDTH-1:0] data_c,
//     input  wire [             4:0]                 opcode,
//     input  wire [VECTOR_LANES-1:0]                 predicate,
//     output reg  [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out,
//     output reg  [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mat_out,
//     output reg                    [DATA_WIDTH-1:0] scalar_out
// );

//     logic [VECTOR_LANES-1:0] vec_en;
//     logic                    mat_en;
//     logic                    sfu_en;
//     logic [             2:0] vec_func;
//     logic [             3:0] mat_func;
//     logic [             4:0] sfu_func;

//     logic op2_neg, op3_neg;
//     logic [DATA_WIDTH-1:0] op1_w [VECTOR_LANES-1:0];
//     logic [DATA_WIDTH-1:0] op2_w [VECTOR_LANES-1:0];
//     logic [DATA_WIDTH-1:0] op3_w [VECTOR_LANES-1:0];
//     logic [DATA_WIDTH-1:0] vec_out_unpacked [VECTOR_LANES-1:0];
//     logic [DATA_WIDTH-1:0] mat_out_unpacked [VECTOR_LANES-1:0];

//     assign vec_en = {VECTOR_LANES{en & (opcode[4:3] == 2'b00)}};
//     assign mat_en = en & (opcode[4:3] == 2'b01);
//     assign sfu_en = en & (opcode[4:3] == 2'b10);

//     assign op2_neg = ((opcode[4:2] == 3'b001) || (opcode[4:2] == 3'b010)) && opcode[1];
//     assign op3_neg = (opcode == 5'b1) || ((opcode[4:2] == 3'b001) || (opcode[4:2] == 3'b010)) && (opcode[1] ^ opcode[0]);

//     for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin: unpack_inputs
//         assign op1_w[i] = data_a[i];
//         assign op2_w[i] = {op2_neg ^ data_b[i][DATA_WIDTH-1], data_b[i][DATA_WIDTH-2:0]};
//         assign op3_w[i] = {op3_neg ^ data_c[i][DATA_WIDTH-1], data_c[i][DATA_WIDTH-2:0]};
//     end

//     always_comb begin
//         casez (opcode[2:0])
//             3'b00?:  vec_func = 3'b001; // Add/Subtract
//             3'b010:  vec_func = 3'b010; // Multiply
//             3'b1??:  vec_func = 3'b100; // Fused Multiply-Add
//             default: vec_func = 3'b100;
//         endcase

//         casez (opcode[2:0])
//             3'b0??:  mat_func = 4'b0001; // Matrix Multiply-Add
//             3'b100:  mat_func = 4'b0010; // Dot Product
//             3'b101:  mat_func = 4'b0100; // Quaternion Multiplication
//             3'b110:  mat_func = 4'b1000; // Rotation Matrix
//             default: mat_func = 4'b0001;
//         endcase

//         case (opcode[2:0])
//             3'b000:  sfu_func = 5'b00001; // reciprocal, 1/A
//             3'b001:  sfu_func = 5'b00010; // square root of A
//             3'b010:  sfu_func = 5'b00100; // reciprocal square root of A
//             3'b011:  sfu_func = 5'b01000; // sine, sin(A)
//             3'b100:  sfu_func = 5'b10000; // cosine, cos(A)
//             default: sfu_func = 5'b00001;
//         endcase
//     end

//     vector_unit #(
//         .SIG_WIDTH      (SIG_WIDTH      ),
//         .EXP_WIDTH      (EXP_WIDTH      ),
//         .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
//         .VECTOR_LANES   (VECTOR_LANES   )
//     ) vector_unit_inst (
//         .vec_a          (op1_w           ),
//         .vec_b          (op2_w           ),
//         .vec_c          (op3_w           ),
//         .rnd            (3'b0            ),
//         .func           (vec_func        ),
//         .en             (vec_en          ),
//         .vec_out        (vec_out_unpacked),
//         .status         (                )
//     );

//     dot_product_unit #(
//         .SIG_WIDTH      (SIG_WIDTH      ),
//         .EXP_WIDTH      (EXP_WIDTH      ),
//         .IEEE_COMPLIANCE(IEEE_COMPLIANCE),
//         .VECTOR_LANES   (VECTOR_LANES   )
//     ) dp_unit_inst (
//         .vec_a          (op1_w           ),
//         .vec_b          (op2_w           ),
//         .vec_c          (op3_w           ),
//         .func           (mat_func        ),
//         .rnd            (3'b0            ),
//         .en             (mat_en          ),
//         .vec_out        (mat_out_unpacked),
//         .status         (                )
//     );

//     multifunc_unit #(
//         .SIG_WIDTH      (SIG_WIDTH      ),
//         .EXP_WIDTH      (EXP_WIDTH      ),
//         .IEEE_COMPLIANCE(IEEE_COMPLIANCE)
//     ) mfu_inst (
//         .data_in        (data_a[0]      ),
//         .func           (sfu_func       ),
//         .rnd            (3'b0           ),
//         .en             (sfu_en         ),
//         .data_out       (scalar_out     ),
//         .status         (               )
//     );

//     for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin: pack_outputs
//       assign vec_out[i] = vec_out_unpacked[i];
//       assign mat_out[i] = mat_out_unpacked[i];
//     end

// endmodule
