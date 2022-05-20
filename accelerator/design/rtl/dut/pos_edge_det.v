module pos_edge_det (
    input clk,
    input sig,
    output reg pe
);

    reg sig_dly;

    always @(posedge clk) begin
        sig_dly <= sig;
    end

    assign pe = sig & ~sig_dly;

endmodule
