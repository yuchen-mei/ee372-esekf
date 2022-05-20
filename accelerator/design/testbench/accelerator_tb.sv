`define INPUT_WIDTH 32
`define OUTPUT_WIDTH 32

`define INPUT_FIFO_WORDS 1
`define INPUT_DATA_SIZE 10
`define OUTPUT_DATA_SIZE 3

`define NUM_INSTRUCTIONS 8

`define INSTR_BANK_DEPTH 512
`define INSTR_BANK_ADDR_WIDTH 9
`define GLB_BANK_DEPTH 2048
`define GLB_MEM_ADDR_WIDTH 11

`define CONFIG_ADDR_WIDTH 8
`define CONFIG_DATA_WIDTH 8

module accelerator_tb;

  reg clk;
  reg rst_n;
  
  reg [`GLB_MEM_ADDR_WIDTH - 1 : 0] input_adr_r;
  wire input_rdy_w;

  wire [`OUTPUT_WIDTH - 1 : 0] output_data_w;
  reg output_rdy_r;
  wire output_vld_w;
  reg [`GLB_MEM_ADDR_WIDTH - 1 : 0] ofmap_adr_r; 

  wire config_rdy_w;
  reg  config_vld_r;
  reg [`CONFIG_ADDR_WIDTH + `CONFIG_DATA_WIDTH - 1 : 0] config_data_r;
  reg [`CONFIG_ADDR_WIDTH - 1 : 0] config_adr_r;

  wire [`INSTR_BANK_ADDR_WIDTH - 1 : 0] instr_max_wadr_c;
  wire [`GLB_MEM_ADDR_WIDTH - 1 : 0] input_max_wadr_c;
  wire [`GLB_MEM_ADDR_WIDTH - 1 : 0] output_max_adr_c;
  wire [`GLB_MEM_ADDR_WIDTH - 1 : 0] input_wadr_offset;
  wire [`GLB_MEM_ADDR_WIDTH - 1 : 0] output_adr_offset;
  wire [`GLB_MEM_ADDR_WIDTH - 1 : 0] mat_inv_offset;

  assign instr_max_wadr_c = `NUM_INSTRUCTIONS - 1;
  assign input_max_wadr_c = `INPUT_DATA_SIZE - 1;
  assign output_max_adr_c = `OUTPUT_DATA_SIZE - 1;
  assign input_wadr_offset = 'h3e00;
  assign output_adr_offset = 'h3f00;
  assign mat_inv_offset = 'h4000;

  reg [7:0] state_r;

  reg [`INPUT_WIDTH - 1 : 0] input_memory [`NUM_INSTRUCTIONS + `INPUT_DATA_SIZE - 1 : 0];
  reg [`OUTPUT_WIDTH - 1 : 0] output_memory [`OUTPUT_DATA_SIZE - 1 : 0];
  reg [`CONFIG_DATA_WIDTH - 1 : 0] config_r [9 : 0];

  always #10 clk =~clk;

  accelerator accelerator_inst (
    .clk(clk),
    .rst_n(rst_n),
    .input_data(input_memory[input_adr_r]),
    .input_rdy(input_rdy_w),
    .input_vld(input_rdy_w & (state_r == 2)),
    .output_data(output_data_w),
    .output_rdy(output_rdy_r),
    .output_vld(output_vld_w),
    .config_data(config_data_r),
    .config_rdy(config_rdy_w),
    .config_vld(config_vld_r)
  );

  initial begin
    $readmemb("inputs/test_vectors.txt", input_memory);

    clk <= 0;
    rst_n <= 0;
    state_r <= 0;
    input_adr_r <= 0; 
    output_rdy_r <= 1;
    config_vld_r <= 0;
    config_data_r <= 0;
    config_adr_r <= 0;

    config_r[0] <=  instr_max_wadr_c;
    config_r[1] <= (instr_max_wadr_c >> 8);
    config_r[2] <=  input_max_wadr_c;
    config_r[3] <= (input_max_wadr_c >> 8);
    config_r[4] <=  input_wadr_offset;
    config_r[5] <= (input_wadr_offset >> 8);
    config_r[6] <=  output_max_adr_c;
    config_r[7] <= (output_max_adr_c >> 8);
    config_r[8] <=  output_adr_offset;
    config_r[9] <= (output_adr_offset >> 8);
    config_r[10] <=  mat_inv_offset;
    config_r[11] <= (mat_inv_offset >> 8);

    #20 rst_n <= 0;
    #20 rst_n <= 1;
  end

  always @ (posedge clk) begin
    if (rst_n) begin
      if (state_r == 0) begin
        if (config_rdy_w) begin
          config_data_r <= {config_adr_r, config_r[config_adr_r]}; 
          config_vld_r <= 1;
          config_adr_r <= config_adr_r + 1;
          if (config_adr_r == 11) begin
            state_r <= 1;
          end
        end
      end else if (state_r == 1) begin
        config_vld_r <= 0;
        state_r <= 2;
      end
    end

    // if (output_vld_w) begin
      
    //   $display("%t: output_adr_r = %d, output_data_w = %h, expected output_data_w = %h",
    //     $time, output_adr_r, output_data_w, output_memory[output_adr_r]);
      
    //   assert(output_data_w == output_memory[output_adr_r]) else $finish;
    
    //   output_adr_r <= output_adr_r + 1;

    //   if (output_adr_r == `OC0*`OX0*`OY0*`OC1*`OX1*`OY1 - 1) begin
    //     $display("Done layer");
    //   	$display("Cycles taken = %d", $time/20);
	  //     $display("Ideal cycles = %d", `OX0*`OY0*`OX1*`OY1*`OC1*`IC1*`FX*`FY);
    //     // $display("ifmap_read = %d, ifmap_write = %d, weight_read = %d, weight_write = %d, output_read = %d, output_write = %d",
    //     // ifmap_read, ifmap_write, weight_read, weight_write, output_read, output_write);
	  //     $finish;
    //   end
    // end
  end

  always @ (posedge clk) begin
    if (rst_n) begin
      if (state_r == 2) begin
        if (input_rdy_w) begin
          input_adr_r <= input_adr_r + `INPUT_FIFO_WORDS;
        end
      end
    end else begin
      input_adr_r <= 0;
    end
  end

  initial begin
    $fsdbDumpfile("outputs/run.fsdb");
    $fsdbDumpvars(0, accelerator_tb);
    #2000;
    $finish(2);
  end

endmodule
