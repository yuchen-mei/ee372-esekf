module instruction_fetch #(
    parameter ADDR_WIDTH = 8
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  en,
    // input  logic jump_target,
    input  logic                  jump,
    input  logic [ADDR_WIDTH-1:0] jump_addr,
    input                         branch,
    input  logic [ADDR_WIDTH-1:0] branch_offset,
    output logic [ADDR_WIDTH-1:0] pc
);

    logic [ADDR_WIDTH-1:0] pc_pipe1, pc_pipe2;
    logic [ADDR_WIDTH-1:0] pc_next;

    assign pc = en ? pc_pipe1 : pc_pipe2;
    assign pc_next = jump   ? jump_addr :
                     branch ? branch_offset : pc + 1;

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
