module instruction_fetch #(
    parameter ADDR_WIDTH = 8
) (
    input  logic clk,
    input  logic rst_n,
    input  logic en,
    // input  logic jump_target,
    input  logic jump_reg,
    input  logic [ADDR_WIDTH-1:0] jr_pc,
    // input branch,
    // input [31:0] branch_offset,
    output logic [ADDR_WIDTH-1:0] pc
);

    logic [ADDR_WIDTH-1:0] pc_pipe1, pc_pipe2;
    logic [ADDR_WIDTH-1:0] pc_next;

    assign pc = en ? pc_pipe1 : pc_pipe2;
    assign pc_next = jump_reg ? jr_pc : pc + 1;

    always @(posedge clk) begin
        if (~rst_n) begin
            pc_pipe1 <= 0;
            pc_pipe2 <= 0;
        end
        else if (en) begin
            pc_pipe1 <= pc_next;
            pc_pipe2 <= pc_pipe1;
        end
    end

endmodule
