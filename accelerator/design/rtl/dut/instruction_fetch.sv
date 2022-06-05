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

    logic [ADDR_WIDTH-1:0] pc_pipe1, pc_pipe2;

    always @(posedge clk) begin
        if (~rst_n) begin
            pc_pipe1 <= 0;
            pc_pipe2 <= 0;
        end
        else if (en) begin
            pc_pipe1 <= pc_pipe1 + 1;
            pc_pipe2 <= pc_pipe1;
        end
    end

    assign pc = en ? pc_pipe1 : pc_pipe2;

endmodule
