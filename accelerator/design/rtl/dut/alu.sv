module alu (
    input  logic [31:0] inst_a,
    input  logic [31:0] inst_b,
    input  logic [ 3:0] opcode,
    output logic [31:0] z_inst
);

//******************************************************************************
// Shift operation: ">>>" will perform an arithmetic shift, but the operand
// must be reg signed, also useful for signed vs. unsigned comparison.
//******************************************************************************
    wire signed [31:0] inst_a_signed = inst_a;
    wire signed [31:0] inst_b_signed = inst_b;

//******************************************************************************
// ALU datapath
//******************************************************************************

    always_comb begin
        case (opcode)
            `ALU_ADD:  z_inst = inst_a + inst_b;
            `ALU_SUB:  z_inst = inst_a - inst_b;
            `ALU_SLT:  z_inst = inst_a_signed < inst_b_signed;
            `ALU_SLTU: z_inst = inst_a < inst_b;
            `ALU_AND:  z_inst = inst_a & inst_b;
            `ALU_OR:   z_inst = inst_a | inst_b;
            `ALU_XOR:  z_inst = inst_a ^ inst_b;
            `ALU_SLL:  z_inst = inst_b << inst_a[4:0];
            `ALU_SRL:  z_inst = inst_b >> inst_a[4:0];
            `ALU_SRA:  z_inst = inst_b_signed >>> inst_a[4:0];
            `ALU_MUL:  z_inst = inst_a * inst_b;
            default:   z_inst = 32'b0;
        endcase
    end

endmodule

