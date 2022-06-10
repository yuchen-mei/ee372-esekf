module vslide_up #(
    parameter DATA_WIDTH = 32,
    parameter VECTOR_LANES = 16
) (
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vsrc,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vdest,
    input  logic [             4:0]                 shamt,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] vec_out
);

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide8up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide4up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide2up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide1up;

    logic [VECTOR_LANES-1:0] mask0;
    logic [VECTOR_LANES-1:0] mask1;
    logic [VECTOR_LANES-1:0] mask2;
    logic [VECTOR_LANES-1:0] mask3;
    logic [VECTOR_LANES-1:0] mask4;

    assign slide8up = shamt[3] ? {vsrc[7:0],      {8{32'b0}}} : vsrc;
    assign slide4up = shamt[2] ? {slide8up[11:0], {4{32'b0}}} : slide8up;
    assign slide2up = shamt[1] ? {slide4up[13:0], {2{32'b0}}} : slide4up;
    assign slide1up = shamt[0] ? {slide2up[14:0], {1{32'b0}}} : slide2up;

    assign mask0 = 16'hffff;
    assign mask1 = shamt[3] ? {mask0[7:0],  8'b0} : mask0;
    assign mask2 = shamt[2] ? {mask1[11:0], 4'b0} : mask1;
    assign mask3 = shamt[1] ? {mask2[13:0], 2'b0} : mask2;
    assign mask4 = shamt[0] ? {mask3[14:0], 1'b0} : mask3;

    for (genvar i = 0; i < VECTOR_LANES; i = i + 1) begin
        assign vec_out[i] = mask4[i] ? slide1up[i] : vdest[i];
    end

endmodule
