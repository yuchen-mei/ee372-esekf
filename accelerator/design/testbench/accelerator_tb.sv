`define INPUT_WIDTH 16
`define OUTPUT_WIDTH 8

`define TOTAL_INPUT_SIZE 48
`define INPUT_DATA_SIZE 24
`define OUTPUT_DATA_SIZE 24

`define INSTR_WIDTH 32
`define NUM_INSTRUCTIONS 76

`define DATA_WIDTH 32
`define ADDR_WIDTH 16

`define CONFIG_WIDTH 16
`define NUM_CONFIGS 5

module accelerator_tb;

    reg clk;
    reg rst_n;

    reg [`ADDR_WIDTH - 1 : 0] config_adr_r;

    wire input_rdy_w;
    reg input_vld_r;
    reg [`INPUT_WIDTH - 1 : 0] input_data_r;
    reg [`ADDR_WIDTH - 1 : 0] input_adr_r;

    wire [`OUTPUT_WIDTH - 1 : 0] output_data_w;
    reg [`ADDR_WIDTH - 1 : 0] output_adr_r;
    reg output_rdy_r;
    wire output_vld_w;

    wire [`ADDR_WIDTH - 1 : 0] instr_max_wadr_c;
    wire [`ADDR_WIDTH - 1 : 0] input_max_wadr_c;
    wire [`ADDR_WIDTH - 1 : 0] output_max_adr_c;
    wire [`ADDR_WIDTH - 1 : 0] input_wadr_offset;
    wire [`ADDR_WIDTH - 1 : 0] output_adr_offset;

    assign instr_max_wadr_c  = `NUM_INSTRUCTIONS - 1;
    assign input_max_wadr_c  = `INPUT_DATA_SIZE - 1;
    assign input_wadr_offset = 16'h7d0;
    assign output_max_adr_c  = `OUTPUT_DATA_SIZE - 1;
    assign output_adr_offset = 16'h7e8;

    reg [7:0] state_r;
    reg counter;

    reg [`CONFIG_WIDTH - 1 : 0] config_r [`NUM_CONFIGS - 1 : 0];
    reg [ `INSTR_WIDTH - 1 : 0] instr_memory [`NUM_INSTRUCTIONS - 1 : 0];
    reg [  `DATA_WIDTH - 1 : 0] input_memory [`TOTAL_INPUT_SIZE - 1 : 0];
    reg [`OUTPUT_WIDTH - 1 : 0] output_memory [`OUTPUT_DATA_SIZE - 1 : 0];

    always #10 clk =~clk;

    accelerator accelerator_inst (
        .clk(clk),
        .rst_n(rst_n),
        .input_data(input_data_r),
        .input_rdy(input_rdy_w),
        .input_vld(input_rdy_w & input_vld_r),
        .output_data(output_data_w),
        .output_rdy(output_rdy_r),
        .output_vld(output_vld_w)
    );

    initial begin
        $readmemb("inputs/instr_data.txt", instr_memory);
        $readmemh("inputs/input_data.txt", input_memory);

        clk <= 0;
        rst_n <= 0;
        state_r <= 0;
        config_adr_r <= 0;
        input_vld_r  <= 0;
        input_adr_r  <= 0;
        input_data_r <= 0;
        output_rdy_r <= 1;
        output_adr_r <= 0;
        counter      <= 0;

        config_r[0]  <=  instr_max_wadr_c;
        config_r[1]  <=  input_max_wadr_c;
        config_r[2]  <=  input_wadr_offset;
        config_r[3]  <=  output_max_adr_c;
        config_r[4]  <=  output_adr_offset;

        #20 rst_n <= 0;
        #20 rst_n <= 1;
    end

    always @ (posedge clk) begin
        if (rst_n) begin
            if (state_r == 0) begin
                if (input_rdy_w) begin
                    input_data_r <= config_r[config_adr_r]; 
                    input_vld_r <= 1;
                    config_adr_r <= config_adr_r + 1;
                    if (config_adr_r == `NUM_CONFIGS - 1) begin
                        state_r <= 1;
                    end
                end
            end
            else if (state_r == 1) begin
                if (input_rdy_w) begin
                    input_data_r <= instr_memory[input_adr_r][counter*16+:16]; 
                    input_adr_r <= (counter == 1) ? input_adr_r + 1 : input_adr_r;
                    input_vld_r <= (input_adr_r < `NUM_INSTRUCTIONS);
                    counter <= counter + 1;
                    if (input_adr_r == `NUM_INSTRUCTIONS) begin
                        state_r <= 2;
                        counter <= 0;
                        input_vld_r <= 1;
                        input_adr_r <= 0;
                    end
                end
            end
            else if (state_r == 2) begin
                if (input_rdy_w) begin
                    input_data_r <= input_memory[input_adr_r][counter*16+:16]; 
                    input_adr_r <= (counter == 1) ? input_adr_r + 1 : input_adr_r;
                    counter <= counter + 1;
                    if (input_adr_r == `TOTAL_INPUT_SIZE) begin
                        state_r <= 3;
                        input_vld_r <= 0;
                    end
                end
            end
        end

        if (output_vld_w) begin

            $display("%t: output_adr_r = %d, output_data_w = %h",
                $time, output_adr_r, output_data_w);

            // $display("%t: output_adr_r = %d, output_data_w = %h, expected output_data_w = %h",
            //     $time, output_adr_r, output_data_w, output_memory[output_adr_r]);
            
            // assert(output_data_w == output_memory[output_adr_r]) else $finish;
            
            output_adr_r <= output_adr_r + 1;

            // if (output_adr_r == `OC0*`OX0*`OY0*`OC1*`OX1*`OY1 - 1) begin
            //     $display("Done layer");
            //     $finish;
            // end
        end
    end

    initial begin
        $fsdbDumpfile("outputs/run.fsdb");
        $fsdbDumpvars(0, accelerator_tb);
        #10000;
        $finish(2);
    end

endmodule
