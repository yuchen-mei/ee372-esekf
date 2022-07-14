module accelerator #(
    parameter SIG_WIDTH            = 23,
    parameter EXP_WIDTH            = 8,
    parameter IEEE_COMPLIANCE      = 0,

    parameter INPUT_FIFO_WIDTH     = 16,
    parameter OUTPUT_FIFO_WIDTH    = 16,
    parameter CONFIG_DATA_WIDTH    = 16,

    parameter VECTOR_LANES         = 16,
    parameter DATAPATH             = 256,

    parameter INSTR_MEM_BANK_DEPTH = 512,
    parameter INSTR_MEM_ADDR_WIDTH = $clog2(INSTR_MEM_BANK_DEPTH),
    parameter DATA_MEM_BANK_DEPTH  = 256,
    parameter DATA_MEM_ADDR_WIDTH  = $clog2(DATA_MEM_BANK_DEPTH)
) (
    input  logic                         clk,
    input  logic                         rst_n,
    input  logic                         wb_clk_i,

    input  logic  [INPUT_FIFO_WIDTH-1:0] input_data,
    output logic                         input_rdy,
    input  logic                         input_vld,

    output logic [OUTPUT_FIFO_WIDTH-1:0] output_data,
    input  logic                         output_rdy,
    output logic                         output_vld,
    // Wishbone
    input  logic                         wbs_debug,
    input  logic                         wbs_fsm_start,
    output logic                         wbs_fsm_done,

    input  logic                         wbs_mem_we,
    input  logic                         wbs_mem_re,
    input  logic                  [11:0] wbs_mem_addr,
    input  logic          [DATAPATH-1:0] wbs_mem_wdata,
    output logic          [DATAPATH-1:0] wbs_mem_rdata
);

    localparam DATA_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;
    localparam ADDR_WIDTH = 12;

    // ---------------------------------------------------------------------------
    // Wires connecting to the interface FIFOs.
    // ---------------------------------------------------------------------------

    logic  [INPUT_FIFO_WIDTH-1:0] input_fifo_dout;
    logic                         input_fifo_deq;
    logic                         input_fifo_empty_n;
    logic                         input_rdy_w;

    logic [OUTPUT_FIFO_WIDTH-1:0] output_fifo_din;
    logic                         output_fifo_enq;
    logic                         output_fifo_full_n;
    logic                         output_vld_w;

    // ---------------------------------------------------------------------------
    // Control signals coming out of aggregators/deaggregator
    // ---------------------------------------------------------------------------

    logic input_fifo_deq_params;
    logic input_fifo_deq_instr;
    logic input_fifo_deq_data;

    logic instr_wen;
    logic input_wen;
    logic output_wb_ren;
    
    // ---------------------------------------------------------------------------
    // Control signals coming out of the convolution controller 
    // ---------------------------------------------------------------------------

    logic                            instr_full_n;
    logic                            input_full_n;
    logic                            output_empty_n;

    logic [INSTR_MEM_ADDR_WIDTH-1:0] instr_wadr;
    logic  [DATA_MEM_ADDR_WIDTH-1:0] input_wadr;
    logic  [DATA_MEM_ADDR_WIDTH-1:0] output_wb_radr;

    logic                            mat_inv_en;
    logic                            mvp_core_en;

    // ---------------------------------------------------------------------------
    // Data connections between the MVP core, matinv, and memory.
    // ---------------------------------------------------------------------------

    logic                               mvp_mem_we;
    logic                               mvp_mem_re;
    logic              [ADDR_WIDTH-1:0] mvp_mem_addr;
    logic [VECTOR_LANES*DATA_WIDTH-1:0] mvp_mem_wdata;
    logic                         [2:0] width;
    logic    [INSTR_MEM_ADDR_WIDTH-1:0] pc;

    logic                               instr_mem_csb;
    logic                               instr_mem_web;
    logic    [INSTR_MEM_ADDR_WIDTH-1:0] instr_mem_addr;
    logic                        [31:0] instr_mem_wdata;
    logic                        [31:0] instr_mem_rdata;
    logic                        [31:0] instr;

    logic                               data_mem_csb;
    logic                               data_mem_web;
    logic             [DATAPATH/32-1:0] data_mem_wmask;
    logic     [DATA_MEM_ADDR_WIDTH-1:0] data_mem_addr;
    logic                [DATAPATH-1:0] data_mem_wdata;
    logic                [DATAPATH-1:0] data_mem_rdata;
    logic                [DATAPATH-1:0] output_wb_data;

    logic                               mem_ctrl_we;
    logic                               mem_ctrl_re;
    logic              [ADDR_WIDTH-1:0] mem_ctrl_addr;
    logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_ctrl_wdata;
    logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_ctrl_rdata;
    logic                         [2:0] mem_ctrl_width;

    logic                               instr_mem_ctrl_csb;
    logic                               instr_mem_ctrl_web;
    logic    [INSTR_MEM_ADDR_WIDTH-1:0] instr_mem_ctrl_addr;
    logic                        [31:0] instr_mem_ctrl_wdata;

    logic                               data_mem_ctrl_csb;
    logic                               data_mem_ctrl_web;
    logic             [DATAPATH/32-1:0] data_mem_ctrl_wmask;
    logic     [DATA_MEM_ADDR_WIDTH-1:0] data_mem_ctrl_addr;
    logic                [DATAPATH-1:0] data_mem_ctrl_wdata;

    logic                               wbs_rst_n;
    logic                               mat_inv_en_sync;
    logic                               mat_inv_vld_i;
    logic            [9*DATA_WIDTH-1:0] mat_inv_in;
    logic                               mat_inv_vld_o;
    logic            [9*DATA_WIDTH-1:0] mat_inv_l_o;
    logic            [9*DATA_WIDTH-1:0] mat_inv_u_o;

    logic                               mat_inv_in_enq;
    logic                               mat_inv_in_vld;

    logic                               mat_inv_out_enq;
    logic                               mat_inv_l_vld;
    logic                               mat_inv_u_vld;
    logic                               mat_inv_out_vld;

    logic            [9*DATA_WIDTH-1:0] mem_wdata_flatten;
    logic            [9*DATA_WIDTH-1:0] mat_inv_l_sync;
    logic            [9*DATA_WIDTH-1:0] mat_inv_u_sync;

    logic                        [31:0] instr_aggregator_dout;
    logic                [DATAPATH-1:0] input_aggregator_dout;


    // ---------------------------------------------------------------------------
    //  MVP Core and memory
    // ---------------------------------------------------------------------------

    mvp_core #(
        .SIG_WIDTH           ( SIG_WIDTH            ),
        .EXP_WIDTH           ( EXP_WIDTH            ),
        .IEEE_COMPLIANCE     ( IEEE_COMPLIANCE      ),
        .VECTOR_LANES        ( VECTOR_LANES         ),
        .INSTR_MEM_ADDR_WIDTH( INSTR_MEM_ADDR_WIDTH )
    ) mvp_core_inst (
        .clk                 ( clk                  ),
        .rst_n               ( rst_n                ),
        .en                  ( mvp_core_en          ),
        .pc                  ( pc                   ),
        .instr               ( instr                ),
        .mem_addr            ( mvp_mem_addr         ),
        .mem_write           ( mvp_mem_we           ),
        .mem_read            ( mvp_mem_re           ),
        .mem_wdata           ( mvp_mem_wdata        ),
        .mem_rdata           ( mem_ctrl_rdata       ),
        .width               ( width                )
    );

    // assign mem_wdata_flatten = mvp_mem_wdata[9*DATA_WIDTH-1:0];

    // SyncBit mat_inv_rst_syncbit (
    //     .sCLK         ( clk             ),
    //     .sRST         ( rst_n           ),
    //     .dCLK         ( wb_clk_i        ),
    //     .sEN          ( 1'b1            ),
    //     .sD_IN        ( rst_n           ),
    //     .dD_OUT       ( wbs_rst_n       )
    // );

    // SyncBit mat_inv_en_syncbit (
    //     .sCLK         ( clk             ),
    //     .sRST         ( rst_n           ),
    //     .dCLK         ( wb_clk_i        ),
    //     .sEN          ( 1'b1            ),
    //     .sD_IN        ( mat_inv_en      ),
    //     .dD_OUT       ( mat_inv_en_sync )
    // );

    // edge_detector mat_inv_in_enq_inst (.clk(clk), .sig(mat_inv_en), .pe(mat_inv_in_enq));

    // SyncFIFO #(
    //     .dataWidth ( 9*32              ),
    //     .depth     ( 2                 ),
    //     .indxWidth ( 1                 )
    // ) mat_inv_in_fifo (
    //     // input clock domain
    //     .sCLK      ( clk               ),
    //     .sRST      ( rst_n             ),
    //     .sENQ      ( mat_inv_in_enq    ),
    //     .sD_IN     ( mem_wdata_flatten ),
    //     .sFULL_N   ( /* unused */      ),
    //     // destination clock domain
    //     .dCLK      ( wb_clk_i          ),
    //     .dDEQ      ( mat_inv_out_enq   ),
    //     .dEMPTY_N  ( mat_inv_in_vld    ),
    //     .dD_OUT    ( mat_inv_in        )
    // );

    // edge_detector mat_inv_in_vld_inst  (.clk(wb_clk_i), .sig(mat_inv_in_vld), .pe(mat_inv_vld_i));
    // edge_detector mat_inv_out_enq_inst (.clk(wb_clk_i), .sig(mat_inv_vld_o),  .pe(mat_inv_out_enq));

    // SyncFIFO #(
    //     .dataWidth ( 9*32              ),
    //     .depth     ( 2                 ),
    //     .indxWidth ( 1                 )
    // ) mat_inv_l_fifo (
    //     // input clock domain
    //     .sCLK      ( wb_clk_i          ),
    //     .sRST      ( wbs_rst_n         ),
    //     .sENQ      ( mat_inv_out_enq   ),
    //     .sD_IN     ( mat_inv_l_o       ),
    //     .sFULL_N   ( /* unused */      ),
    //     // destination clock domain
    //     .dCLK      ( clk               ),
    //     .dDEQ      ( mat_inv_in_enq    ),
    //     .dEMPTY_N  ( mat_inv_l_vld     ),
    //     .dD_OUT    ( mat_inv_l_sync    )
    // );

    // SyncFIFO #(
    //     .dataWidth ( 9*32              ),
    //     .depth     ( 2                 ),
    //     .indxWidth ( 1                 )
    // ) mat_inv_u_fifo (
    //     // input clock domain
    //     .sCLK      ( wb_clk_i          ),
    //     .sRST      ( wbs_rst_n         ),
    //     .sENQ      ( mat_inv_out_enq   ),
    //     .sD_IN     ( mat_inv_u_o       ),
    //     .sFULL_N   ( /* unused */      ),
    //     // destination clock domain
    //     .dCLK      ( clk               ),
    //     .dDEQ      ( mat_inv_in_enq    ),
    //     .dEMPTY_N  ( mat_inv_u_vld     ),
    //     .dD_OUT    ( mat_inv_u_sync    )
    // );

    assign mat_inv_out_vld = 1'b1;

    // edge_detector mat_inv_out_vld_inst (.clk(clk), .sig(mat_inv_l_vld & mat_inv_u_vld), .pe(mat_inv_out_vld));

    // mat_inv #(
    //     .DATA_WIDTH       ( DATA_WIDTH        )
    // ) mat_inv_inst (
    //     .clk              ( wb_clk_i          ),
    //     .rst_n            ( wbs_rst_n         ),
    //     .en               ( mat_inv_en_sync   ),
    //     .vld              ( mat_inv_vld_i     ),
    //     .mat_in           ( mat_inv_in        ),
    //     .rdy              ( /* unused */      ),
    //     .vld_out          ( mat_inv_vld_o     ),
    //     .mat_inv_out_l    ( mat_inv_l_o       ),
    //     .mat_inv_out_u    ( mat_inv_u_o       )
    // );

    ram_sync_1rw1r #(
        .DATA_WIDTH( 32                   ),
        .ADDR_WIDTH( INSTR_MEM_ADDR_WIDTH ),
        .DEPTH     ( INSTR_MEM_BANK_DEPTH )
    ) instr_mem (
        .clk       ( clk                  ),
        .csb0      ( instr_mem_csb        ),
        .web0      ( instr_mem_web        ),
        .addr0     ( instr_mem_addr       ),
        .wmask0    ( 1'b1                 ),
        .din0      ( instr_mem_wdata      ),
        .dout0     ( instr_mem_rdata      ),
        .csb1      ( ~instr_full_n        ),
        .addr1     ( pc                   ),
        .dout1     ( instr                )
    );

    ram_sync_1rw1r #(
        .DATA_WIDTH( DATAPATH            ),
        .ADDR_WIDTH( DATA_MEM_ADDR_WIDTH ),
        .DEPTH     ( DATA_MEM_BANK_DEPTH )
    ) data_mem (
        .clk       ( clk                 ),
        .csb0      ( data_mem_csb        ),
        .web0      ( data_mem_web        ),
        .addr0     ( data_mem_addr       ),
        .wmask0    ( data_mem_wmask      ),
        .din0      ( data_mem_wdata      ),
        .dout0     ( data_mem_rdata      ),
        .csb1      ( output_wb_ren       ),
        .addr1     ( output_wb_radr      ),
        .dout1     ( output_wb_data      )
    );

    memory_controller #(
        .ADDR_WIDTH          ( ADDR_WIDTH           ),
        .DATA_WIDTH          ( DATA_WIDTH           ),
        .VECTOR_LANES        ( VECTOR_LANES         ),
        .DATAPATH            ( DATAPATH             ),
        .INSTR_MEM_ADDR_WIDTH( INSTR_MEM_ADDR_WIDTH ),
        .DATA_MEM_ADDR_WIDTH ( DATA_MEM_ADDR_WIDTH  )
    ) mem_ctrl_inst (
        .clk                 ( clk                  ),
        // Physical memory address
        .mem_we              ( mem_ctrl_we          ),
        .mem_re              ( mem_ctrl_re          ),
        .mem_addr            ( mem_ctrl_addr        ),
        .mem_wdata           ( mem_ctrl_wdata       ),
        .mem_rdata           ( mem_ctrl_rdata       ),
        .width               ( mem_ctrl_width       ),
        // Instruction memory
        .instr_mem_csb       ( instr_mem_ctrl_csb   ),
        .instr_mem_web       ( instr_mem_ctrl_web   ),
        .instr_mem_addr      ( instr_mem_ctrl_addr  ),
        .instr_mem_wdata     ( instr_mem_ctrl_wdata ),
        .instr_mem_rdata     ( instr_mem_rdata      ),
        // Data memory
        .data_mem_csb        ( data_mem_ctrl_csb    ),
        .data_mem_web        ( data_mem_ctrl_web    ),
        .data_mem_addr       ( data_mem_ctrl_addr   ),
        .data_mem_wmask      ( data_mem_ctrl_wmask  ),
        .data_mem_wdata      ( data_mem_ctrl_wdata  ),
        .data_mem_rdata      ( data_mem_rdata       ),
        // Matrix inversion
        .mat_inv_out_l       ( mat_inv_l_sync       ),
        .mat_inv_out_u       ( mat_inv_u_sync       )
    );

    assign wbs_mem_rdata = mem_ctrl_rdata;

    always_comb begin
        if (instr_wen) begin
            instr_mem_csb   = instr_wen;
            instr_mem_web   = 1'b1;
            instr_mem_addr  = instr_wadr;
            instr_mem_wdata = instr_aggregator_dout;
        end else begin
            instr_mem_csb   = instr_mem_ctrl_csb;
            instr_mem_web   = instr_mem_ctrl_web;
            instr_mem_addr  = instr_mem_ctrl_addr;
            instr_mem_wdata = instr_mem_ctrl_wdata;
        end
    end

    always_comb begin
        if (input_wen) begin
            data_mem_csb   = input_wen;
            data_mem_web   = 1'b1;
            data_mem_addr  = input_wadr;
            data_mem_wmask = 8'hFF;
            data_mem_wdata = input_aggregator_dout;
        end else begin
            data_mem_csb   = data_mem_ctrl_csb;
            data_mem_web   = data_mem_ctrl_web;
            data_mem_addr  = data_mem_ctrl_addr;
            data_mem_wmask = data_mem_ctrl_wmask;
            data_mem_wdata = data_mem_ctrl_wdata;
        end
    end

    always_comb begin
        if (wbs_debug && ~mvp_core_en) begin
            mem_ctrl_we    = wbs_mem_we;
            mem_ctrl_re    = wbs_mem_re;
            mem_ctrl_addr  = wbs_mem_addr;
            mem_ctrl_wdata = wbs_mem_wdata;
            mem_ctrl_width = 3'b010;
        end else begin
            mem_ctrl_we    = mvp_mem_we;
            mem_ctrl_re    = mvp_mem_re;
            mem_ctrl_addr  = mvp_mem_addr;
            mem_ctrl_wdata = mvp_mem_wdata;
            mem_ctrl_width = width;
        end
    end

  // ---------------------------------------------------------------------------
  //  Interface fifos
  // ---------------------------------------------------------------------------

    fifo #(
        .DATA_WIDTH   ( INPUT_FIFO_WIDTH        ),
        .FIFO_DEPTH   ( 3                       ),
        .COUNTER_WIDTH( 1                       )
    ) input_fifo_inst (
        .clk          ( clk                     ),
        .rst_n        ( rst_n                   ),
        .din          ( input_data              ),
        .enq          ( input_rdy_w & input_vld ),
        .full_n       ( input_rdy_w             ),
        .dout         ( input_fifo_dout         ),
        .deq          ( input_fifo_deq          ),
        .empty_n      ( input_fifo_empty_n      ),
        .clr          ( 1'b0                    )
    );

    assign input_rdy      = input_rdy_w;
    assign input_fifo_deq = input_fifo_deq_params | input_fifo_deq_instr | input_fifo_deq_data;

    aggregator #(
        .DATA_WIDTH     ( INPUT_FIFO_WIDTH      ),
        .FETCH_WIDTH    ( 32/INPUT_FIFO_WIDTH   )
    ) instr_aggregator_inst (
        .clk            ( clk                   ),
        .rst_n          ( rst_n                 ),
        .sender_data    ( input_fifo_dout       ),
        .sender_empty_n ( input_fifo_empty_n    ),
        .sender_deq     ( input_fifo_deq_instr  ),
        .receiver_data  ( instr_aggregator_dout ),
        .receiver_full_n( instr_full_n          ),
        .receiver_enq   ( instr_wen             )
    );

    aggregator #(
        .DATA_WIDTH     ( INPUT_FIFO_WIDTH          ),
        .FETCH_WIDTH    ( DATAPATH/INPUT_FIFO_WIDTH )
    ) input_aggregator_inst (
        .clk            ( clk                       ),
        .rst_n          ( rst_n                     ),
        .sender_data    ( input_fifo_dout           ),
        .sender_empty_n ( input_fifo_empty_n        ),
        .sender_deq     ( input_fifo_deq_data       ),
        .receiver_data  ( input_aggregator_dout     ),
        .receiver_full_n( input_full_n              ),
        .receiver_enq   ( input_wen                 )
    );

    fifo #(
        .DATA_WIDTH   ( OUTPUT_FIFO_WIDTH          ),
        .FIFO_DEPTH   ( 3                          ),
        .COUNTER_WIDTH( 1                          )
    ) output_fifo_inst (
        .clk          ( clk                        ),
        .rst_n        ( rst_n                      ),
        .din          ( output_fifo_din            ),
        .enq          ( output_fifo_enq            ),
        .full_n       ( output_fifo_full_n         ),
        .dout         ( output_data                ),
        .deq          ( output_rdy && output_vld_w ),
        .empty_n      ( output_vld_w               ),
        .clr          ( 1'b0                       )
    );

    assign output_vld = output_vld_w;

    deaggregator #(
        .DATA_WIDTH     ( OUTPUT_FIFO_WIDTH          ),
        .FETCH_WIDTH    ( DATAPATH/OUTPUT_FIFO_WIDTH )
    ) output_deaggregator_inst (
        .clk            ( clk                        ),
        .rst_n          ( rst_n                      ),
        .sender_data    ( output_wb_data             ),
        .sender_empty_n ( output_empty_n             ),
        .sender_deq     ( output_wb_ren              ),
        .receiver_data  ( output_fifo_din            ),
        .receiver_full_n( output_fifo_full_n         ),
        .receiver_enq   ( output_fifo_enq            )
    );

    controller #(
        .INPUT_FIFO_WIDTH    ( INPUT_FIFO_WIDTH      ),
        .ADDR_WIDTH          ( ADDR_WIDTH            ),
        .INSTR_MEM_ADDR_WIDTH( INSTR_MEM_ADDR_WIDTH  ),
        .DATA_MEM_ADDR_WIDTH ( DATA_MEM_ADDR_WIDTH   ),
        .CONFIG_DATA_WIDTH   ( CONFIG_DATA_WIDTH     )
    ) controller_inst (
        .clk                 ( clk                   ),
        .rst_n               ( rst_n                 ),
        .wbs_debug           ( wbs_debug             ),
        .wbs_fsm_start       ( wbs_fsm_start         ),
        .wbs_fsm_done        ( wbs_fsm_done          ),
        // Configuration data
        .params_fifo_dout    ( input_fifo_dout       ),
        .params_fifo_deq     ( input_fifo_deq_params ),
        .params_fifo_empty_n ( input_fifo_empty_n    ),
        // Aggregator signal
        .instr_full_n        ( instr_full_n          ),
        .input_full_n        ( input_full_n          ),
        .output_empty_n      ( output_empty_n        ),
        // Address generator
        .instr_wadr          ( instr_wadr            ),
        .input_wadr          ( input_wadr            ),
        .output_wb_radr      ( output_wb_radr        ),
        // Input control signal
        .instr_wen           ( instr_wen             ),
        .input_wen           ( input_wen             ),
        .output_wb_ren       ( output_wb_ren         ),
        // Memory control
        .mem_addr            ( mvp_mem_addr          ),
        .mem_read            ( mvp_mem_re            ),
        .mem_write           ( mvp_mem_we            ),
        // MVP and MI ontrol signal
        .mat_inv_en          ( mat_inv_en            ),
        .mat_inv_out_vld     ( mat_inv_out_vld       ),
        .mvp_core_en         ( mvp_core_en           )
    );

endmodule
