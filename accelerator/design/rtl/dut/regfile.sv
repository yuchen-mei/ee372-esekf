module regfile #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5,
    parameter DEPTH      = 32
) (
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic                  wen,
    input  logic [ADDR_WIDTH-1:0] addr_w,
    input  logic [DATA_WIDTH-1:0] data_w,

    input  logic [ADDR_WIDTH-1:0] addr_r1,
    output logic [DATA_WIDTH-1:0] data_r1,
    input  logic [ADDR_WIDTH-1:0] addr_r2,
    output logic [DATA_WIDTH-1:0] data_r2,
    input  logic [ADDR_WIDTH-1:0] addr_r3,
    output logic [DATA_WIDTH-1:0] data_r3
);

    logic [DEPTH-1:0][DATA_WIDTH-1:0] regs;

    assign data_r1 = (addr_r1 == 0) ? 0 :
                     (wen & (addr_w == addr_r1)) ? data_w : regs[addr_r1];
    assign data_r2 = (addr_r2 == 0) ? 0 :
                     (wen & (addr_w == addr_r2)) ? data_w : regs[addr_r2];
    assign data_r3 = (addr_r3 == 0) ? 0 :
                     (wen & (addr_w == addr_r3)) ? data_w : regs[addr_r3];

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            regs <= '0;
        end
        else if (wen) begin
            regs[addr_w] <= data_w;
        end
    end

endmodule
