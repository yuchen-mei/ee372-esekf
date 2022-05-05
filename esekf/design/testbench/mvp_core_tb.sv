`define CLK_PERIOD 20
`define FINISH_TIME 20000
`define NUM_INSTRUCTIONS 29
`define SIG_WIDTH 23
`define EXP_WIDTH 8
`define IEEE_COMPLIANCE 0
`define INSTRUCTION_WIDTH 32
`define MATRIX_HEIGHT 3
`define MATRIX_WIDTH 3
`define LEN 9

module esekf_top_tb;
  
  localparam ADDR_WIDTH = $clog2(`NUM_INSTRUCTIONS) + 1;
 
  logic clk;
  logic rst_n;
  logic en;
  logic [31 : 0] imu_gnss_data [9 : 0];
  logic [31 : 0] instruction;
  logic instr_vld, instr_rdy;
  logic [31 : 0] data_out [8 : 0];
  logic data_out_vld;

  logic [31 : 0] instructions [`NUM_INSTRUCTIONS - 1 : 0];
  logic [ADDR_WIDTH - 1 : 0] addr_r;

  always #(`CLK_PERIOD/2) clk =~clk;

  mvp_core #(
    .SIG_WIDTH(`SIG_WIDTH),
    .EXP_WIDTH(`EXP_WIDTH),
    .IEEE_COMPLIANCE(`IEEE_COMPLIANCE),
    .MATRIX_HEIGHT(`MATRIX_HEIGHT),
    .MATRIX_WIDTH(`MATRIX_WIDTH),
    .LEN(`LEN)
  ) mvp_core_inst (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .imu_gnss_data(),
    .imu_gnss_rdy(),
    .imu_gnss_vld(),
    .instr(instruction),
    .instr_rdy(instr_rdy),
    .instr_vld(instr_vld),
    .data_out_vld(data_out_vld),
    .data_out(data_out)
  );

  initial begin
    // TODO: calculate rotation matrix and store at 10000
    // TODO: load imu_f at 10001
    instructions[0] = 'b000_00011_0000_10001_10000_01101_10010; // a = R @ imu_f - g
    instructions[1] = 'b001_00100_0010_01110_10010_00000_00000; // p += a * 0.5t^2
    instructions[2] = 'b001_00100_0000_01110_00001_00000_00000; // p += v * t
    instructions[3] = 'b001_00100_0000_01110_10010_00001_00001; // v += a * t
    // TODO: load imu_w (in quaternion mode) at 10010
    instructions[4] = 'b000_00100_0000_10010_00010_01111_00010; // q = q * imu_w

    instructions[5] = 'b011_00000_0000_01111_10001_01111_10001; // skew-symmetric
    instructions[6] = 'b000_00000_0000_10001_10000_01111_10001; // rot * skew-symmetric
    instructions[7] = 'b001_01101_0000_01110_10001_01111_10000; // RST

    instructions[8] = 'b001_00100_0000_01110_00110_00011_00011; // P11 += P21 * t
    instructions[9] = 'b001_00100_0000_01110_00100_00011_00011; // P11 += P12 * t
    instructions[10] = 'b001_00100_0001_01110_00111_00011_00011; // P11 += P22 * t^2

    instructions[11] = 'b001_00100_0000_01110_00111_00100_00100; // P12 += P22 * t
    instructions[12] = 'b000_00000_0000_00101_10000_00100_00100; // P12 += RST @ P13
    instructions[13] = 'b000_00000_0000_01000_10000_01111_10001; // r17 = RST @ P23
    instructions[14] = 'b001_00100_0000_01110_10001_00100_00100; // P12 += r17 * t

    instructions[15] = 'b001_00100_0000_01110_01000_00101_00101; // P13 += P23 * t

    instructions[16] = 'b000_00000_0000_10000_01001_00110_00110; // P21 += P31 @ RST
    instructions[17] = 'b001_00100_0000_01110_01000_00110_00110; // P21 += P22 * t
    instructions[18] = 'b000_00000_0000_10000_01010_01111_10001; // r17 = P32 @ RST
    instructions[19] = 'b001_00100_0000_01110_10001_00110_00110; // P12 += r17 * t

    instructions[20] = 'b000_00000_0000_10000_01010_00111_00111; // P22 += P32 @ RST
    instructions[21] = 'b000_00000_0000_01000_10000_00111_00111; // P22 += RST @ P23
    instructions[22] = 'b000_00000_0000_10000_01011_01111_10001; // r17 = P33 @ RST
    instructions[23] = 'b000_00000_0000_10001_10000_00111_00111; // P22 += RST @ r17
    instructions[24] = 'b001_00100_0011_01110_01100_00111_00111; // P22 += vif * t^2 * I

    instructions[25] = 'b000_00000_0000_10000_01011_01000_01000; // P23 += P33 @ RST

    instructions[26] = 'b001_00100_0000_01110_01010_01001_01001; // P31 += P32 * t
    instructions[27] = 'b000_00000_0000_10000_01011_01010_01010; // P32 += P33 @ RST
    instructions[28] = 'b001_00100_0000_01110_01100_01011_01011; // P33 += viw * t^2

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
    $fsdbDumpvars(0, esekf_top_tb);
    #(`FINISH_TIME);
    $finish(2);
  end

endmodule 
