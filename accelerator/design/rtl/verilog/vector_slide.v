module vector_slide (
	vec_a,
	vec_b,
	shift,
	vec_out
);
	parameter DATA_WIDTH = 32;
	parameter VECTOR_LANES = 16;
	parameter WIDTH = $clog2(VECTOR_LANES);
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_a;
	input wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_b;
	input wire [WIDTH - 1:0] shift;
	output wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] vec_out;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] slide8up;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] slide4up;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] slide2up;
	wire [(VECTOR_LANES * DATA_WIDTH) - 1:0] slide1up;
	wire [VECTOR_LANES - 1:0] mask1;
	wire [VECTOR_LANES - 1:0] mask2;
	wire [VECTOR_LANES - 1:0] mask3;
	wire [VECTOR_LANES - 1:0] mask4;
	assign slide8up = (shift[3] ? {vec_a[0+:DATA_WIDTH * 8], {8 {32'b00000000000000000000000000000000}}} : vec_a);
	assign slide4up = (shift[2] ? {slide8up[0+:DATA_WIDTH * 12], {4 {32'b00000000000000000000000000000000}}} : slide8up);
	assign slide2up = (shift[1] ? {slide4up[0+:DATA_WIDTH * 14], {2 {32'b00000000000000000000000000000000}}} : slide4up);
	assign slide1up = (shift[0] ? {slide2up[0+:DATA_WIDTH * 15], 32'b00000000000000000000000000000000} : slide1up);
	assign mask1 = (shift[3] ? 16'hff00 : 16'hffff);
	assign mask2 = (shift[2] ? {mask1[11:0], {4 {32'b00000000000000000000000000000000}}} : mask1);
	assign mask3 = (shift[1] ? {mask2[13:0], {2 {32'b00000000000000000000000000000000}}} : mask2);
	assign mask4 = (shift[0] ? {mask3[14:0], 32'b00000000000000000000000000000000} : mask3);
	genvar i;
	generate
		for (i = 0; i < VECTOR_LANES; i = i + 1) begin : genblk1
			assign vec_out[i * DATA_WIDTH+:DATA_WIDTH] = (mask4[i] ? slide1up[i * DATA_WIDTH+:DATA_WIDTH] : vec_b[i * DATA_WIDTH+:DATA_WIDTH]);
		end
	endgenerate
endmodule


