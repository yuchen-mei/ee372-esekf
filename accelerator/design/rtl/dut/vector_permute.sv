module vector_permute #(
    parameter DATA_WIDTH = 32,
    parameter VECTOR_LANES = 16
) (
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_in,
    input  logic [                             2:0] funct,
    input  logic [                             2:0] width,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_in_n;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] skew_symmetric;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] transpose;

    for (genvar i = 0; i < 3; i = i + 1) begin: unpack_inputs
        assign vec_in_n[i] = {~vec_in[i][DATA_WIDTH-1], vec_in[i][DATA_WIDTH-2:0]};
    end

    assign skew_symmetric[0] = 32'b0;
    assign skew_symmetric[1] = vec_in[2];
    assign skew_symmetric[2] = vec_in_n[1];
    assign skew_symmetric[3] = vec_in_n[2];
    assign skew_symmetric[4] = 32'b0;
    assign skew_symmetric[5] = vec_in[0];
    assign skew_symmetric[6] = vec_in[1];
    assign skew_symmetric[7] = vec_in_n[0];
    assign skew_symmetric[8] = 32'b0;
  
    for (genvar i = 0; i < 3; i = i + 1) begin
        for (genvar j = 0; j < 3; j = j + 1) begin
            assign transpose[3*i+j] = vec_in[3*j+i];
        end
    end

    if (VECTOR_LANES > 9) begin
        assign skew_symmetric[VECTOR_LANES-1:9] = '0;
        assign transpose[VECTOR_LANES-1:9]      = '0;
    end

    always_comb begin
        case (funct)
            2'b00:   vec_out = skew_symmetric;
            2'b01:   vec_out = transpose;
            default: vec_out = '0;
        endcase
    end

endmodule
