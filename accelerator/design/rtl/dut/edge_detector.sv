module edge_detector (
    input  logic sig,
    input  logic clk,
    output logic pe
);

    logic sig_r;

    always @(posedge clk)
        sig_r <= sig;

    assign pe = sig & ~sig_r;

endmodule
