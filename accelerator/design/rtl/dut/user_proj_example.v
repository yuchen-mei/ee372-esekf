// `default_nettype none
// `define MPRJ_IO_PADS 38

// module user_proj_example #(
//     parameter BITS = 32
// ) (
// `ifdef USE_POWER_PINS
//     inout VDD,	// User area 1 1.8V supply
//     inout VSS,	// User area 1 digital ground
// `endif

//     // Wishbone Slave ports (WB MI A)
//     input wire wb_clk_i,
//     input wire wb_rst_i,
//     input wire wbs_stb_i,
//     input wire wbs_cyc_i,
//     input wire wbs_we_i,
//     input wire [3:0] wbs_sel_i,
//     input wire [31:0] wbs_dat_i,
//     input wire [31:0] wbs_adr_i,
//     output wire wbs_ack_o,
//     output wire [31:0] wbs_dat_o,

//     // Logic Analyzer Signals
//     input  wire [127:0] la_data_in,
//     output wire [127:0] la_data_out,
//     input  wire [127:0] la_oenb,

//     // IOs
//     input  wire [`MPRJ_IO_PADS-1:0] io_in,
//     output wire [`MPRJ_IO_PADS-1:0] io_out,
//     output wire [`MPRJ_IO_PADS-1:0] io_oeb,

//     // Analog (direct connection to GPIO pad---use with caution)
//     // Note that analog I/O is not available on the 7 lowest-numbered
//     // GPIO pads, and so the analog_io indexing is offset from the
//     // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
//     inout wire [`MPRJ_IO_PADS-10:0] analog_io,

//     // Independent clock (on independent integer divider)
//     input wire user_clock2,

//     // User maskable interrupt signals
//     output wire [2:0] user_irq
// );

//     wire in_fifo_rdy;
//     wire [`OUTPUT_WIDTH - 1 : 0] out_fifo_rdata;
//     wire output_vld_w;

//     // IRQ
//     assign io_oeb[19:0] = {18{1'b1}};
//     assign io_oeb[37:20] = {20{1'b0}};

//     // define all IO pin locations
//     assign io_clk = io_in[0];
//     assign io_rst_n = io_in[1];
//     assign in_fifo_data = io_in[17:2];
//     assign in_fifo_enq = io_in[18];
//     assign out_fifo_deq = io_in[19];
//     assign io_out[20] = in_fifo_rdy;
//     assign io_out[28:21] = out_fifo_rdata;
//     assign io_out[29] = output_vld_w;
//     assign io_out[19:0] = 18'd0;
//     assign io_out[37:30] = 3'd0;

//     accelerator acc_inst (
//         `ifdef USE_POWER_PINS
//         .VDD(VDD),	// User area 1 1.8V power
//         .VSS(VSS),	// User area 1 digital ground
//         `endif
//         .clk(io_clk),
//         .rst_n(io_rst_n),
//         .input_data(in_fifo_data),
//         .input_rdy(in_fifo_rdy),
//         .input_vld(in_fifo_enq),
//         .output_data(out_fifo_rdata),
//         .output_rdy(out_fifo_deq),
//         .output_vld(output_vld_w)
//     );

//     // always @ (posedge wb_clk_i) begin
//     //     if (wb_rst_i) begin
//     //         ack <= 1'b0;
//     //     end else begin
//     //         ack <= enq || deq;
//     //     end
//     // end
    
//     // assign wbs_ack_o = ack;

// endmodule

// `default_nettype wire
