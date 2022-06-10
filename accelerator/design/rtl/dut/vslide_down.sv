module vslide_down #(
    parameter DATA_WIDTH = 32,
    parameter VECTOR_LANES = 16
) (
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vsrc,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vdest,
    input  logic [             4:0]                 shamt,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide8down;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide4down;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide2down;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide1down;

    logic [VECTOR_LANES-1:0] mask0;
    logic [VECTOR_LANES-1:0] mask1;
    logic [VECTOR_LANES-1:0] mask2;
    logic [VECTOR_LANES-1:0] mask3;
    logic [VECTOR_LANES-1:0] mask4;

    assign slide8down = shamt[3] ? {{8{32'b0}}, vsrc[15:8]      } : vsrc;
    assign slide4down = shamt[2] ? {{4{32'b0}}, slide8down[15:4]} : slide8down;
    assign slide2down = shamt[1] ? {{2{32'b0}}, slide4down[15:2]} : slide4down;
    assign slide1down = shamt[0] ? {{1{32'b0}}, slide2down[15:1]} : slide2down;

    assign mask0 = 16'hffff;
    assign mask1 = shamt[3] ? {8'b0, mask0[15:8]} : mask0;
    assign mask2 = shamt[2] ? {4'b0, mask1[15:4]} : mask1;
    assign mask3 = shamt[1] ? {2'b0, mask2[15:2]} : mask2;
    assign mask4 = shamt[0] ? {1'b0, mask3[15:1]} : mask3;

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        assign vec_out[i] = mask4[i] ? slide1down[i] : vdest[i];
    end

endmodule
