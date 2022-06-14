`default_nettype none
`define MPRJ_IO_PADS 38

module user_proj_example #(
    parameter BITS = 32,
    parameter WISHBONE_BASE_ADDR = 32'h30000000
) (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i,
    input wire [31:0] wbs_adr_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input  wire [127:0] la_oenb,

    // IOs
    input  wire [`MPRJ_IO_PADS-1:0] io_in,
    output wire [`MPRJ_IO_PADS-1:0] io_out,
    output wire [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout wire [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input wire user_clock2,

    // User maskable interrupt signals
    output wire [2:0] irq
);

    wire        io_clk;
    wire        io_rst_n;
    wire        input_rdy_w;
    wire        input_vld_w;
    wire [15:0] input_data_w;
    wire        output_rdy_w;
    wire        output_vld_w;
    wire [ 7:0] output_data_w;

    assign irq = 3'b0;

    assign io_clk             = io_in[19];
    assign io_rst_n           = io_in[0];
    assign input_data_w[15:0] = io_in[16:1];
    assign input_vld_w        = io_in[17];
    assign output_rdy_w       = io_in[18];

    assign io_out[27:20] = output_data_w[7:0];
    assign io_out[28]    = output_vld_w;
    assign io_out[29]    = input_rdy_w;

    assign io_out[`MPRJ_IO_PADS-1:30] = 8'b0;
    assign io_out[19:0] = 20'b0;
    assign io_oeb = {20'b0, {18{1'b1}}};
    
    assign la_data_out = 128'd0;
    

// ==============================================================================
// Wishbone control
// ==============================================================================

    wire        wbs_debug;
    wire        wbs_fsm_start;

    wire [11:0] wbs_mem_addr;
    wire [31:0] wbs_mem_wdata;
    wire [31:0] wbs_mem_rdata;
    wire        wbs_mem_write;
    wire        wbs_mem_read;
    // clock/reset mux
    wire ckmux_clk;
    wire ckmux_rst;
    ckmux ckmux_u0 (
        .select  (wbs_debug),
        .clk0    (io_clk   ),
        .clk1    (wb_clk_i ),
        .out_clk (ckmux_clk)
    );
    assign ckmux_rst = (wbs_debug) ?  ~wb_rst_i : io_rst_n;

    wishbone_ctl #(
        .WISHBONE_BASE_ADDR(WISHBONE_BASE_ADDR)
    ) wbs_ctl_u0 (
        // wishbone input
        .wb_clk_i      (wb_clk_i     ),
        .wb_rst_i      (wb_rst_i     ),
        .wbs_stb_i     (wbs_stb_i    ),
        .wbs_cyc_i     (wbs_cyc_i    ),
        .wbs_we_i      (wbs_we_i     ),
        .wbs_sel_i     (wbs_sel_i    ),
        .wbs_dat_i     (wbs_dat_i    ),
        .wbs_adr_i     (wbs_adr_i    ),
        // wishbone output
        .wbs_ack_o     (wbs_ack_o    ),
        .wbs_dat_o     (wbs_dat_o    ),
        // output
        .wbs_debug     (wbs_debug    ),
        .wbs_fsm_start (wbs_fsm_start),
        .wbs_mem_addr  (wbs_mem_addr ),
        .wbs_mem_wdata (wbs_mem_wdata),
        .wbs_mem_rdata (wbs_mem_rdata),
        .wbs_mem_write (wbs_mem_write),
        .wbs_mem_read  (wbs_mem_read )
    );

// ==============================================================================
// IO Logic
// ==============================================================================

    accelerator accelerator_inst (
        .clk           (ckmux_clk    ),
        .rst_n         (ckmux_rst    ),

        .input_rdy     (input_rdy_w  ),
        .input_vld     (input_vld_w  ),
        .input_data    (input_data_w ),

        .output_rdy    (output_rdy_w ),
        .output_vld    (output_vld_w ),
        .output_data   (output_data_w),

        .wbs_debug     (wbs_debug    ),
        .wbs_fsm_start (wbs_fsm_start),

        .wbs_mem_addr  (wbs_mem_addr ),
        .wbs_mem_wdata (wbs_mem_wdata),
        .wbs_mem_rdata (wbs_mem_rdata),
        .wbs_mem_write (wbs_mem_write),
        .wbs_mem_read  (wbs_mem_read )
    );

endmodule

`default_nettype wire
