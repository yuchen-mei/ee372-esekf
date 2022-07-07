`timescale 1 ns / 1 ps

`define INPUT_FIFO_WIDTH 16
`define OUTPUT_FIFO_WIDTH 16

`define INPUT_DATA_SIZE 24
`define OUTPUT_DATA_SIZE 24

`define NUM_CONFIGS 5
`define NUM_INSTRUCTIONS 126
`define TOTAL_INPUT_SIZE 120

`define ADDR_WIDTH 16

`define MPRJ_IO_PADS 38

module user_proj_example_tb;

    // design top variables
    reg clk;
    reg rst_n;
    reg wb_clk_i;
    reg wb_rst_i;

    reg       [`ADDR_WIDTH - 1 : 0] input_adr_r;

    wire                            input_rdy_w;
    reg                             input_vld_r;
    reg   [`INPUT_FIFO_WIDTH - 1:0] input_data_r;

    reg                             output_rdy_r;
    wire                            output_vld_w;
    wire [`OUTPUT_FIFO_WIDTH - 1:0] output_data_w;

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
    reg       counter;
    integer   file;

    reg [15:0] config_r[`NUM_CONFIGS - 1:0];
    reg [31:0] instr_memory[`NUM_INSTRUCTIONS - 1:0];
    reg [31:0] input_memory[`TOTAL_INPUT_SIZE - 1:0];

    // caravel io variables
    wire         wbs_ack_o;
    wire  [31:0] wbs_dat_o;
    wire [127:0] la_data_out;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [              2:0] user_irq;

    supply0 vssd1;
    supply1 vccd1;

    assign io_in[37]   = clk;
    assign io_in[36]   = rst_n;
    assign io_in[15:0] = input_data_r; 
    assign io_in[16]   = input_rdy_w & input_vld_r;
    assign io_in[17]   = output_rdy_r;

    assign output_data_w = io_out[33:18];
    assign output_vld_w  = io_out[34];
    assign input_rdy_w   = io_out[35];

    always #10 clk = ~clk;

    always #50 wb_clk_i = ~wb_clk_i;

    user_proj_example user_proj_example_inst (
    `ifdef USE_POWER_PINS
        .vccd1      (vccd1      ),	// User area 1 1.8V supply
        .vssd1      (vssd1      ),	// User area 1 digital ground
    `endif
        .wb_clk_i   (wb_clk_i   ),
        .wb_rst_i   (wb_rst_i   ),
        // .wbs_stb_i  (wbs_stb_i  ),
        // .wbs_cyc_i  (wbs_cyc_i  ),
        // .wbs_we_i   (wbs_we_i   ),
        // .wbs_sel_i  (wbs_sel_i  ),
        // .wbs_dat_i  (wbs_dat_i  ),
        // .wbs_adr_i  (wbs_adr_i  ),

        .wbs_ack_o  (wbs_ack_o  ),
        .wbs_dat_o  (wbs_dat_o  ),

        .la_data_out(la_data_out),
        .io_in      (io_in      ),
        .io_out     (io_out     ),
        .io_oeb     (io_oeb     ),
        .user_irq   (user_irq   )
    );

    initial begin
        $readmemb("inputs/instr_data.txt", instr_memory);
        $readmemh("inputs/input_data.txt", input_memory);
        file = $fopen("outputs/output.txt", "w");

        clk   <= 0;
        rst_n <= 0;

        wb_clk_i <= 0;
        wb_rst_i <= 1;

        state_r <= 0;
        counter <= 0;

        input_adr_r  <= 0;
        input_vld_r  <= 0;
        input_data_r <= 0;
        output_rdy_r <= 1;

        config_r[0] <= instr_max_wadr_c;
        config_r[1] <= input_max_wadr_c;
        config_r[2] <= input_wadr_offset;
        config_r[3] <= output_max_adr_c;
        config_r[4] <= output_adr_offset;

        #350 rst_n <= 1;
        wb_rst_i <= 0;
    end

    always @ (posedge clk) begin
        if (rst_n) begin
            if (state_r == 0) begin
                if (input_rdy_w) begin
                    input_data_r <= config_r[input_adr_r]; 
                    input_vld_r <= 1;
                    input_adr_r <= input_adr_r + 1;
                    if (input_adr_r == `NUM_CONFIGS - 1) begin
                        state_r <= 1;
                        input_adr_r <= 0;
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
                        input_adr_r <= 0;
                        input_vld_r <= 1;
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
            $fwrite(file, "%h\n", output_data_w);
        end
    end

    initial begin
        // $dumpfile("user_proj_example_tb.vcd");
		// $dumpvars(0, user_proj_example_tb);
        $fsdbDumpfile("outputs/run.fsdb");
        $fsdbDumpvars(0, user_proj_example_tb);
        #50000;
        $finish(2);
    end

    `ifdef GL
    initial begin
        $sdf_annotate("inputs/design.sdf", user_proj_example_tb);
    end
    `endif

endmodule
