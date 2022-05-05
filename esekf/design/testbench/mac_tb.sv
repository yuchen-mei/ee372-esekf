`define CLK_PERIOD 20
`define FINISH_TIME 2000000
`define NUM_TEST_VECTORS 100

module mac_tb;
  
  localparam ADDR_WIDTH = $clog2(`NUM_TEST_VECTORS);
 
  logic clk;
  logic rst_n;
  logic en;
  logic [31 : 0] inst_a, inst_b;
  logic [2 : 0] inst_rnd_r;
  logic [31 : 0] data_out;
  logic [7 : 0] status;

  logic [32 * 4 - 1 : 0] test_vectors [`NUM_TEST_VECTORS - 1 : 0];
  logic [ADDR_WIDTH - 1 : 0] addr_r;

  always #(`CLK_PERIOD/2) clk =~clk;
  
  mac mac_inst
  (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .data_a(inst_a),
    .data_b(inst_b),
    .rnd(inst_rnd_r),
    .data_out(data_out),
    .status(status)
  );

  initial begin
    $readmemh("inputs/test_vectors.txt", test_vectors);

    clk <= 0;
    rst_n <= 0;
    en <= 0;
    inst_a <= 0;
    inst_b <= 0;
    addr_r <= 0;
    inst_rnd_r <= 3'b0;
    #20 rst_n <= 1;
    en <= 1;
  end

  always @(posedge clk) begin
    if (rst_n) begin
      inst_a <= test_vectors[addr_r][31 : 0];
      inst_b <= test_vectors[addr_r][63 : 32];
      addr_r <= addr_r + 1;
    end

    if (addr_r > 1) begin
      $display("got c = %h, expected c = %h", data_out, test_vectors[addr_r - 2][95 : 64]);
      assert(data_out == test_vectors[addr_r - 2][95 : 64]);
      if (addr_r == `NUM_TEST_VECTORS + 1) $finish;
    end
  end

  initial begin
    $dumpfile("run.vcd");
    $dumpvars(0, mac_tb);
    #(`FINISH_TIME);
    $finish(2);
  end

endmodule 
