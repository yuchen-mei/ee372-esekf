`default_nettype none
`define MPRJ_IO_PADS 38

module user_proj_example #(
    parameter BITS = 32
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
    output wire [2:0] user_irq
);

    wire        io_clk;
    wire        io_rst_n;
    wire        input_rdy_w;
    wire        input_vld_w;
    wire [15:0] input_data_w;
    wire        output_rdy_w;
    wire        output_vld_w;
    wire [15:0] output_data_w;

    assign user_irq = 3'b0;

    assign io_clk       = io_in[37];
    assign io_rst_n     = io_in[36];
    assign input_data_w = io_in[15:0];
    assign input_vld_w  = io_in[16];
    assign output_rdy_w = io_in[17];

    assign io_out[17:0]  = 18'b0;
    assign io_out[33:18] = output_data_w;
    // assign io_out[33:26] = 8'b0; // reserved for output
    assign io_out[34]    = output_vld_w;
    assign io_out[35]    = input_rdy_w;
    assign io_out[37:36] = 2'b0;

    // input - 1 output - 0
    assign io_oeb[17:0]  = {18{1'b1}};
    assign io_oeb[35:18] = 18'b0;
    assign io_oeb[37:36] = {2{1'b1}};

    assign la_data_out = 128'd0;

// ==============================================================================
// Wishbone control
// ==============================================================================

    wire        wbs_debug;
    wire        wbs_fsm_start;
    wire        wbs_fsm_done;

    wire        wbs_debug_synced;
    wire        wbs_fsm_start_synced;
    wire        wbs_fsm_done_synced;

    wire        wbs_mem_we;
    wire        wbs_mem_ren;
    wire [11:0] wbs_mem_addr;
    wire [31:0] wbs_mem_wdata;
    wire [31:0] wbs_mem_rdata;

    // clock/reset mux
    wire user_proj_clk;
    wire user_proj_rst_n;

    clock_mux #(2) clk_mux (
        .clk        ( {io_clk, wb_clk_i}        ),
        .clk_select ( wbs_debug ? 2'b01 : 2'b10 ),
        .clk_out    ( user_proj_clk             )
    );

    assign user_proj_rst_n = (wbs_debug) ? ~wb_rst_i : io_rst_n;

    wishbone_ctl wbs_ctl_u0 (
        // wishbone input
        .wb_clk_i      (wb_clk_i            ),
        .wb_rst_i      (wb_rst_i            ),
        .wbs_stb_i     (wbs_stb_i           ),
        .wbs_cyc_i     (wbs_cyc_i           ),
        .wbs_we_i      (wbs_we_i            ),
        .wbs_sel_i     (wbs_sel_i           ),
        .wbs_dat_i     (wbs_dat_i           ),
        .wbs_adr_i     (wbs_adr_i           ),
        // wishbone output
        .wbs_ack_o     (wbs_ack_o           ),
        .wbs_dat_o     (wbs_dat_o           ),
        // output
        .wbs_debug     (wbs_debug           ),
        .wbs_fsm_start (wbs_fsm_start       ),
        .wbs_fsm_done  (wbs_fsm_done_synced ),

        .wbs_mem_we    (wbs_mem_we          ),
        .wbs_mem_ren   (wbs_mem_ren         ),
        .wbs_mem_addr  (wbs_mem_addr        ),
        .wbs_mem_wdata (wbs_mem_wdata       ),
        .wbs_mem_rdata (wbs_mem_rdata       )
    );

// ==============================================================================
// IO Logic
// ==============================================================================

    accelerator acc_inst (
        .clk           (user_proj_clk       ),
        .rst_n         (user_proj_rst_n     ),

        .input_rdy     (input_rdy_w         ),
        .input_vld     (input_vld_w         ),
        .input_data    (input_data_w        ),

        .output_rdy    (output_rdy_w        ),
        .output_vld    (output_vld_w        ),
        .output_data   (output_data_w       ),

        .wbs_debug     (wbs_debug_synced    ),
        .wbs_fsm_start (wbs_fsm_start_synced),
        .wbs_fsm_done  (wbs_fsm_done        ),

        .wbs_mem_we    (wbs_mem_we          ),
        .wbs_mem_ren   (wbs_mem_ren         ),
        .wbs_mem_addr  (wbs_mem_addr        ),
        .wbs_mem_wdata (wbs_mem_wdata       ),
        .wbs_mem_rdata (wbs_mem_rdata       )
    );

    SyncBit wbs_debug_sync (
        .sCLK          (wb_clk_i            ),
        .sRST          (~wb_rst_i           ),
        .dCLK          (io_clk              ),
        .sEN           (1'b1                ),
        .sD_IN         (wbs_debug           ),
        .dD_OUT        (wbs_debug_synced    )
    );

    SyncPulse wbs_fsm_start_sync (
        .sCLK          (wb_clk_i            ),
        .sRST          (~wb_rst_i           ),
        .dCLK          (io_clk              ),
        .sEN           (wbs_fsm_start       ),
        .dPulse        (wbs_fsm_start_synced)
    );

    SyncBit wbs_fsm_done_sync (
        .sCLK          (io_clk              ),
        .sRST          (io_rst_n            ),
        .dCLK          (wb_clk_i            ),
        .sEN           (1'b1                ),
        .sD_IN         (wbs_fsm_done        ),
        .dD_OUT        (wbs_fsm_done_synced )
    );

endmodule

`default_nettype wire
