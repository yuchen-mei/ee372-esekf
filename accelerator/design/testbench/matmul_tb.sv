`define CLK_PERIOD 20
`define FINISH_TIME 2000000
`define NUM_TEST_VECTORS 10
`define ARRAY_HEIGHT 3
`define ARRAY_WIDTH 3

module matmul_tb;
  
  localparam ADDR_WIDTH = $clog2(`NUM_TEST_VECTORS);
 
  logic clk;
  logic rst_n;
  logic en;
  logic [31 : 0] inst_a [8 : 0];
  logic [31 : 0] inst_b [8 : 0];
  logic [31 : 0] data_out [8 : 0];
  logic [7 : 0] status;

  logic [31 : 0] test_vectors [`NUM_TEST_VECTORS - 1 : 0][2 : 0][8 : 0];
  logic [ADDR_WIDTH - 1 : 0] addr_r;

  always #(`CLK_PERIOD/2) clk =~clk;
  
  matmul matmul_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .matrix_a(inst_a),
    .matrix_b(inst_b),
    .matrix_out(data_out),
    .status(status)
  );

  initial begin
    $readmemh("inputs/test_vectors.txt", test_vectors);

    clk <= 0;
    rst_n <= 0;
    en <= 0;
    inst_a <= '{default:'0};
    inst_b <= '{default:'0};
    addr_r <= 0;
    #20 rst_n <= 1;
    en <= 1;
  end

  always @(posedge clk) begin
    if (rst_n && addr_r < `NUM_TEST_VECTORS) begin
      inst_a <= test_vectors[addr_r][0];
      inst_b <= test_vectors[addr_r][1];
      addr_r <= addr_r + 1;
    end

    if (addr_r > 0) begin
      for (int i = 0; i < 9; i = i + 1) begin
        $display("got c = %h, expected c = %h", data_out[i], test_vectors[addr_r - 1][2][i]);
        assert(data_out[i] == test_vectors[addr_r - 1][2][i]);
      end
      if (addr_r == `NUM_TEST_VECTORS) $finish;
    end
  end

  initial begin
    $dumpfile("run.vcd");
    $dumpvars(0, matmul_tb);
    #(`FINISH_TIME);
    $finish(2);
  end

endmodule 
