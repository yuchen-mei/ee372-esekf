`timescale 1 ns / 1 ps

`define INPUT_FIFO_WIDTH 16
`define OUTPUT_FIFO_WIDTH 16

`define INPUT_DATA_SIZE 24
`define OUTPUT_DATA_SIZE 24

`define NUM_CONFIGS 5
`define NUM_INSTRUCTIONS 126
`define TOTAL_INPUT_SIZE 120

`define MPRJ_IO_PADS 38

module user_proj_example_tb;

    typedef enum logic [1:0] {
        STANDBY = 2'd0,
        STEP1   = 2'd1,
        STEP2   = 2'd2,
        STEP3   = 2'd3
    } state_t;

    state_t                       state;
    reg                    [11:0] input_adr_r;
    reg                           counter;
    reg                           fsm_start;
    integer                       file;

    reg  [`NUM_CONFIGS-1:0][15:0] config_r;
    reg                    [31:0] instr_memory[`NUM_INSTRUCTIONS-1:0];
    reg                    [31:0] input_memory[`TOTAL_INPUT_SIZE-1:0];

    supply0                       vssd1;
    supply1                       vccd1;

    reg                           clk;
    reg                           rst_n;

    wire                          input_rdy_w;
    reg                           input_vld_r;
    reg   [`INPUT_FIFO_WIDTH-1:0] input_data_r;

    reg                           output_rdy_r;
    wire                          output_vld_w;
    wire [`OUTPUT_FIFO_WIDTH-1:0] output_data_w;

    reg                           wb_clk_i;
    reg                           wb_rst_i;
    reg                           wbs_stb_i;
    reg                           wbs_cyc_i;
    reg                           wbs_we_i;
    reg                     [3:0] wbs_sel_i;
    reg                    [31:0] wbs_dat_i;
    reg                    [31:0] wbs_adr_i;

    wire                          wbs_ack_o;
    wire                   [31:0] wbs_dat_o;

    wire      [`MPRJ_IO_PADS-1:0] io_in;
    wire      [`MPRJ_IO_PADS-1:0] io_out;
    wire      [`MPRJ_IO_PADS-1:0] io_oeb;

    wire                  [127:0] la_data_out;
    wire                    [2:0] user_irq;

    assign io_in[37]      = clk;
    assign io_in[36]      = rst_n;
    assign io_in[15:0]    = input_data_r; 
    assign io_in[16]      = input_vld_r;
    assign io_in[17]      = output_rdy_r;

    assign output_data_w  = io_out[33:18];
    assign output_vld_w   = io_out[34];
    assign input_rdy_w    = io_out[35] & fsm_start;

    always #10 clk = ~clk;

    always #50 wb_clk_i = ~wb_clk_i;

    user_proj_example user_proj_example_inst (
    `ifdef USE_POWER_PINS
        .vccd1       ( vccd1       ),	// User area 1 1.8V supply
        .vssd1       ( vssd1       ),	// User area 1 digital ground
    `endif
        .wb_clk_i    ( wb_clk_i    ),
        .wb_rst_i    ( wb_rst_i    ),
        .wbs_stb_i   ( wbs_stb_i   ),
        .wbs_cyc_i   ( wbs_cyc_i   ),
        .wbs_we_i    ( wbs_we_i    ),
        .wbs_sel_i   ( wbs_sel_i   ),
        .wbs_dat_i   ( wbs_dat_i   ),
        .wbs_adr_i   ( wbs_adr_i   ),

        .wbs_ack_o   ( wbs_ack_o   ),
        .wbs_dat_o   ( wbs_dat_o   ),

        .io_in       ( io_in       ),
        .io_out      ( io_out      ),
        .io_oeb      ( io_oeb      ),

        .la_data_out ( la_data_out ),
        .user_irq    ( user_irq    )
    );

    initial begin
        $readmemb("inputs/instr_data.txt", instr_memory);
        $readmemh("inputs/input_data.txt", input_memory);
        file = $fopen("outputs/output.txt", "w");

        clk          <= 0;
        rst_n        <= 0;

        wb_clk_i     <= 0;
        wb_rst_i     <= 1;
        wbs_stb_i    <= 0;
        wbs_cyc_i    <= 0;
        wbs_we_i     <= 0;
        wbs_sel_i    <= 0;
        wbs_dat_i    <= '0;
        wbs_adr_i    <= '0;

        state        <= STANDBY;
        counter      <= 0;
        fsm_start    <= 0;

        input_adr_r  <= 0;
        input_vld_r  <= 0;
        input_data_r <= 0;
        output_rdy_r <= 1;

        config_r[0]  <= `NUM_INSTRUCTIONS - 1;
        config_r[1]  <= `INPUT_DATA_SIZE - 1;
        config_r[2]  <= 16'h7d0;
        config_r[3]  <= `OUTPUT_DATA_SIZE - 1;
        config_r[4]  <= 16'h7e8;

        #350
        rst_n        <= 1;
        wb_rst_i     <= 0;
        #150
        fsm_start    <= 1;
    end

    always @(posedge clk) begin
        case (state)
            STANDBY: begin
                if (input_rdy_w) begin
                    input_data_r <= config_r[input_adr_r]; 
                    input_adr_r  <= input_adr_r + 1;
                    input_vld_r  <= 1;

                    if (input_adr_r == `NUM_CONFIGS - 1) begin
                        state       <= STEP1;
                        input_adr_r <= 0;
                    end
                end
            end

            STEP1: begin
                if (input_rdy_w) begin
                    input_data_r <= instr_memory[input_adr_r][counter*16+:16]; 
                    input_adr_r  <= (counter == 1) ? input_adr_r + 1 : input_adr_r;
                    input_vld_r  <= (input_adr_r < `NUM_INSTRUCTIONS);
                    counter      <= counter + 1;

                    if (input_adr_r == `NUM_INSTRUCTIONS) begin
                        state       <= STEP2;
                        input_adr_r <= 0;
                        counter     <= 0;
                    end
                end
            end

            STEP2: begin
                if (input_rdy_w) begin
                    input_data_r <= input_memory[input_adr_r][counter*16+:16]; 
                    input_adr_r  <= (counter == 1) ? input_adr_r + 1 : input_adr_r;
                    input_vld_r  <= 1;
                    counter      <= counter + 1;

                    if (input_adr_r == `TOTAL_INPUT_SIZE) begin
                        state       <= STEP3;
                        input_vld_r <= 0;
                    end
                end
            end
        endcase

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
