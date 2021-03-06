module dff2 #(
    parameter WIDTH      = 32,
    parameter ARRAY_SIZE = 16,
    parameter PIPE_DEPTH = 1,
    parameter OUT_REG    = 1
) (
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 en,
    input  logic [WIDTH - 1 : 0] in  [ARRAY_SIZE - 1 : 0],
    output logic [WIDTH - 1 : 0] out [ARRAY_SIZE - 1 : 0]
);

    for (genvar i = 0; i < ARRAY_SIZE; i = i + 1) begin
        dff #(
            .WIDTH     (WIDTH      ),
            .PIPE_DEPTH(PIPE_DEPTH ),
            .OUT_REG   (OUT_REG    )
        ) dff_pipe (
            .clk    (clk        ),
            .rst_n  (rst_n      ),
            .en     (en         ),
            .in     (in[i]      ),
            .out    (out[i]     )
        );
    end

endmodule
