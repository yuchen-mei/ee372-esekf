`define CLK_PERIOD 20
`define FINISH_TIME 20000
`define NUM_INSTRUCTIONS 16
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
    instructions[0] = 32'b01110_0_10001_10000_0000_10011_1000100; // a = R @ imu_f - g
    instructions[1] = 32'b00001_0_00010_01111_0000_00001_0100100; // p += v * t
    instructions[3] = 32'b00010_0_10011_01111_0000_00010_0100100; // v += a * t
    instructions[2] = 32'b00001_0_10011_01111_0010_00001_0100100; // p += a * 0.5t^2
    // TODO: load imu_w (in quaternion mode) at 10010
    instructions[4] = 32'b00000_0_10010_00011_0000_00011_1010100; // q = q * imu_w

    instructions[5] = 32'b00000_0_00000_10001_0000_10001_0011100; // skew-symmetric
    instructions[6] = 32'b00000_0_10001_10000_0000_10001_1001000; // rot * skew-symmetric
    instructions[7] = 32'b00000_0_10001_01111_0000_10000_0100100; // RST

    // FIXME: Double check algorithm
    // instructions[8] =  32'b00100_0_00111_01111_0000_00100_0100100; // P11 += P21 * t
    // instructions[9] =  32'b00100_0_00101_01111_0000_00100_0100100; // P11 += P12 * t
    // instructions[10] = 32'b00100_0_01000_01111_0001_00100_0100100; // P11 += P22 * t^2

    // instructions[11] = 32'b00101_0_01000_01111_0000_00101_0100100; // P12 += P22 * t
    // instructions[12] = 32'b00101_0_00110_10000_0000_00101_1000000; // P12 += RST @ P13
    // // FIXME: Set reg to 0 first
    // instructions[13] = 32'b00000_0_01001_10000_0000_10001_1000000; // r17 = RST @ P23
    // instructions[14] = 32'b00101_0_10001_01111_0000_00101_0100100; // P12 += r17 * t

    // instructions[15] = 32'b00110_0_01001_01111_0000_00110_0100100; // P13 += P23 * t

    // instructions[16] = 32'b00111_0_01111_01000_0000_00111_0100100; // P21 += P22 * t
    // instructions[17] = 32'b00111_0_10000_01010_0000_00111_1000000; // P21 += P31 @ RST
    // instructions[18] = 32'b00000_0_10000_01011_0000_10001_1000000; // r17 = P32 @ RST
    // instructions[19] = 32'b00111_0_01111_10001_0000_00111_0100100; // P12 += r17 * t

    // instructions[20] = 32'b01000_0_10000_01011_0000_01000_1000000; // P22 += P32 @ RST
    // instructions[21] = 32'b01000_0_01001_10000_0000_01000_1000000; // P22 += RST @ P23
    // instructions[22] = 32'b00000_0_10000_01100_0000_10001_1000000; // r17 = P33 @ RST
    // instructions[23] = 32'b01000_0_10001_10000_0000_01000_1000000; // P22 += RST @ r17
    // instructions[24] = 32'b01000_0_01101_01111_0011_01000_0100100; // P22 += vif * t^2 * I

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
