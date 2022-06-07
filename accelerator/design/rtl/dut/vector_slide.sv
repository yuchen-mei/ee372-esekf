module vector_slide #(
    parameter DATA_WIDTH = 32,
    parameter VECTOR_LANES = 16,
    parameter WIDTH = $clog2(VECTOR_LANES)
) (
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] inst_a,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] inst_b,
    input  logic [       WIDTH-1:0]                 shift,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] z_inst
);

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide8up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide4up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide2up;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] slide1up;

    logic [VECTOR_LANES-1:0] mask1;
    logic [VECTOR_LANES-1:0] mask2;
    logic [VECTOR_LANES-1:0] mask3;
    logic [VECTOR_LANES-1:0] mask4;

    assign slide8up = shift[3] ? {inst_a[7:0],    {8{32'b0}}} : inst_a;
    assign slide4up = shift[2] ? {slide8up[11:0], {4{32'b0}}} : slide8up;
    assign slide2up = shift[1] ? {slide4up[13:0], {2{32'b0}}} : slide4up;
    assign slide1up = shift[0] ? {slide2up[14:0], {1{32'b0}}} : slide1up;

    assign mask1 = shift[3] ? 16'hFF00 : 16'h1;
    assign mask2 = shift[2] ? {mask1[11:0], {4{32'b0}}} : mask1;
    assign mask3 = shift[1] ? {mask2[13:0], {2{32'b0}}} : mask2;
    assign mask4 = shift[0] ? {mask3[14:0], {1{32'b0}}} : mask3;

endmodule

