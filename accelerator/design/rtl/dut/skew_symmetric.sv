module skew_symmetric #(
    parameter DATA_WIDTH = 32
) (
    input  logic [8:0][DATA_WIDTH-1:0] vec_a,
    output logic [8:0][DATA_WIDTH-1:0] vec_out
);

    logic [8:0][DATA_WIDTH-1:0] vec_a_neg;

    for (genvar i = 0; i < 9; i = i + 1) begin: negate_inputs
        assign vec_a_neg[i] = {~vec_a[i][DATA_WIDTH-1], vec_a[i][DATA_WIDTH-2:0]};
    end

    assign vec_out[0] = '0;
    assign vec_out[1] = vec_a[2];
    assign vec_out[2] = vec_a_neg[1];
    assign vec_out[3] = vec_a_neg[2];
    assign vec_out[4] = '0;
    assign vec_out[5] = vec_a[0];
    assign vec_out[6] = vec_a[1];
    assign vec_out[7] = vec_a_neg[0];
    assign vec_out[8] = '0;

endmodule
