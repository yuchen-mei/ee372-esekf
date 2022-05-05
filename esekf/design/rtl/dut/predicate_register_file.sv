module predicate_register_file #(
  parameter LEN = 9,
  parameter ADDR_WIDTH = 3
) (
  input clk,
  input rst_n,
  input en,
  input [ADDR_WIDTH - 1 : 0] addr_w,
  input data_w[LEN - 1 : 0],

  input [ADDR_WIDTH - 1 : 0] addr_r,
  output data_r[LEN - 1 : 0]
);

  logic [LEN - 1 : 0] regs [ADDR_WIDTH - 1 : 0];

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      regs <= '{default:'0};
    end
    else if (en) begin
      regs[addr_w] <= data_w;
    end
  end

  assign data_r = regs[addr_r];

endmodule
