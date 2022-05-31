module instruction_fetch #(
    parameter ADDR_WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    input  logic en,
    // input jump_target,
    // input [25:0] instr_id,  // Lower 26 bits of the instruction
    // input jump_reg,
    // input [31:0] jr_pc,
    // input branch,
    // input [31:0] branch_offset,
    output logic [ADDR_WIDTH-1:0] pc
);

    logic [ADDR_WIDTH-1:0] pc_r;

    always @(posedge clk) begin
        if (~rst_n) begin
            pc_r <= 0;
        end
        else if (en) begin
            pc_r <= pc_r + 1;
        end
    end

    assign pc = pc_r;

endmodule
