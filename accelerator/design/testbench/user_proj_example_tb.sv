`define INPUT_WIDTH 16
`define OUTPUT_WIDTH 8

`define TOTAL_INPUT_SIZE 48
`define INPUT_DATA_SIZE 24
`define OUTPUT_DATA_SIZE 24

`define INSTR_WIDTH 32
`define NUM_INSTRUCTIONS 74

`define DATA_WIDTH 32
`define ADDR_WIDTH 16

`define CONFIG_WIDTH 16
`define NUM_CONFIGS 5

`define MPRJ_IO_PADS 38

module user_proj_example_tb;

    // design top variables
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

    // caravel io variables
    wire wbs_ack_o;
    wire [31:0] wbs_dat_o;
    wire [127:0] la_data_out;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;
    wire [2:0] user_irq;

    // connect to io_in[19:0]
    assign io_in[19] = clk;
    assign io_in[0] = rst_n;
    for (genvar i = 0; i < 16; i = i + 1) begin
        assign io_in[i + 1] = input_data_r[i];
    end
    assign io_in[17] = input_rdy_w & input_vld_r;
    assign io_in[18] = output_rdy_r;

    // connect to io_out[27:20]
    for (genvar i = 20; i < 28; i = i + 1) begin
        assign output_data_w[i-20] = io_out[i];
    end
    assign output_vld_w = io_out[28];
    assign input_rdy_w = io_out[29];

    // connect to the rest of io_in pins
    assign io_in[`MPRJ_IO_PADS-1:20] = 18'd0;

    always #10 clk =~clk;

    user_proj_example user_proj_example_inst (
        .wbs_ack_o(wbs_ack_o),
        .wbs_dat_o(wbs_dat_o),
        .la_data_out(la_data_out),
        .io_in(io_in),
        .io_out(io_out),
        .io_oeb(io_oeb),
        .user_irq(user_irq)
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
        $fsdbDumpvars(0, user_proj_example_tb);
        #10000;
        $finish(2);
    end

endmodule
