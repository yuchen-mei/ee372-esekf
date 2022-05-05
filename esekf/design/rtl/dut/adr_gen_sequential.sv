module adr_gen_sequential
#( 
  parameter BANK_ADDR_WIDTH = 32
)(
  input clk,
  input rst_n,
  input adr_en,
  output [BANK_ADDR_WIDTH - 1 : 0] adr,
  input config_en,
  input [BANK_ADDR_WIDTH - 1 : 0] config_data
);

  reg [BANK_ADDR_WIDTH - 1 : 0] config_block_max;

  wire last_adr_w;

  always @ (posedge clk) begin
    if (rst_n) begin
      if (config_en) begin
        config_block_max <= config_data; 
      end
    end else begin
      config_block_max <= 0;
    end
  end
  
  reg [BANK_ADDR_WIDTH - 1 : 0] adr_r;
  
  always @ (posedge clk) begin
    if (rst_n) begin
      if (adr_en) begin
        adr_r <= last_adr_w ? 0 : adr_r + 1;
      end
    end else begin
      adr_r <= 0;
    end
  end

  assign adr = adr_r;
  assign last_adr_w = (adr_r == config_block_max);

endmodule
