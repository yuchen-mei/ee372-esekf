`define CLK_PERIOD 20
`define FINISH_TIME 20000
`define NUM_INSTRUCTIONS 9
`define SIG_WIDTH 23
`define EXP_WIDTH 8
`define IEEE_COMPLIANCE 0
`define INSTRUCTION_WIDTH 32
`define LEN 16

module mvp_core_tb;
  
  localparam ADDR_WIDTH = $clog2(`NUM_INSTRUCTIONS) + 1;
 
  logic clk;
  logic rst_n;
  logic en;
  logic [31 : 0] imu_gnss_data [9 : 0];
  logic [31 : 0] instruction;
  logic instr_vld, instr_rdy;
  logic [31 : 0] data_out [`LEN - 1 : 0];
  logic data_out_vld;

  logic [31 : 0] instructions [`NUM_INSTRUCTIONS - 1 : 0];
  logic [ADDR_WIDTH - 1 : 0] addr_r;

  always #(`CLK_PERIOD/2) clk =~clk;

  mvp_core #(
    .SIG_WIDTH(`SIG_WIDTH),
    .EXP_WIDTH(`EXP_WIDTH),
    .IEEE_COMPLIANCE(`IEEE_COMPLIANCE),
    .LEN(`LEN)
  ) mvp_core_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .instr(instruction),
    .instr_rdy(instr_rdy),
    .instr_vld(instr_vld),
    .mem_write_en(),
    .mem_read_en(),
    .mem_addr(),
    .mem_write_data(),
    .mem_read_data(),
    .data_out_vld(data_out_vld),
    .data_out(data_out)
  );

  initial begin
    // TODO: calculate rotation matrix and store at 10000
    // TODO: load imu_f at 10001

    // Axis angle to quaternion
    // Step 1: Euclidean norm
    // a. dot product
    // b. sqrt
    // c. divide by 2
    // Find cosine and sine of half angle
    // Divide xyz by norm
    // Multiply xyz by sine

    clk <= 0;
    rst_n <= 0;
    en <= 0;
    instruction <= 'b0;
    instr_vld <= 1'b0;
    addr_r <= 0;
    #20 rst_n <= 1;
    en <= 1;
  end

  always @(posedge clk) begin
    if (rst_n) begin
      if (instr_rdy) begin
        if (addr_r < `NUM_INSTRUCTIONS) begin
          instruction <= instructions[addr_r];
          instr_vld <= 1'b1;
          addr_r <= addr_r + 1;
        end
        else begin
          instr_vld <= 1'b0;
        end
      end

      if (data_out_vld) begin
        for (int i = `LEN - 1; i >= 0 ; i = i - 1) begin
          $write("%h_", data_out[i]);
        end
        $display();
      end
    end
  end

  initial begin
    $fsdbDumpfile("outputs/run.fsdb");
    $fsdbDumpvars(0, mvp_core_tb);
    #(`FINISH_TIME);
    $finish(2);
  end

endmodule 
