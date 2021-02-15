//-----------------------------------------------------------------------------
// SramWrapper
//-----------------------------------------------------------------------------

module SramWrapper(
  clk, csb, web, addr, din, dout
);

  parameter DATA_WIDTH = 2;
  parameter ADDR_WIDTH = 4;

  input clk; // clock
  input csb; // active low chip select
  input web; // active low write control
  input [ADDR_WIDTH-1:0] addr;
  input [DATA_WIDTH-1:0] din;
  output [DATA_WIDTH-1:0] dout;

  reg csb_r;
  reg web_r;
  reg [ADDR_WIDTH - 1 : 0] addr_r;
  reg [DATA_WIDTH - 1 : 0] din_r;
  reg [DATA_WIDTH - 1 : 0] dout_r;
  
  wire [DATA_WIDTH - 1 : 0] dout_w;

  always @ (posedge clk) begin
    csb_r <= csb;
    web_r <= web;
    addr_r <= addr;
    din_r <= din;
    dout_r <= dout_w - 1;
  end
  
  assign dout = dout_r;

  sram sram(
    .clk0(clk),
    .csb0(csb_r),
    .web0(web_r),
    .addr0(addr_r),
    .din0(din_r + 2'b1),
    .dout0(dout_w)
  );

endmodule
