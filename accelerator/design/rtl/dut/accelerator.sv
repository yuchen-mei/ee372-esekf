module accelerator #(
    parameter SIG_WIDTH          = 23,
    parameter EXP_WIDTH          = 8,
    parameter IEEE_COMPLIANCE    = 0,

    parameter INPUT_FIFO_WIDTH   = 16,
    parameter OUTPUT_FIFO_WIDTH  = 8,
    parameter CONFIG_DATA_WIDTH  = 8,

    parameter VECTOR_LANES       = 16,

    parameter INSTR_BANK_DEPTH   = 512,
    parameter INSTR_ADDR_WIDTH   = $clog2(INSTR_BANK_DEPTH),
    parameter GLB_MEM_BANK_DEPTH = 256,
    parameter GLB_MEM_ADDR_WIDTH = $clog2(GLB_MEM_BANK_DEPTH)
) (
    input  logic                         clk,
    input  logic                         rst_n,

    input  logic [ INPUT_FIFO_WIDTH-1:0] input_data,
    output logic                         input_rdy,
    input  logic                         input_vld,

    output logic [OUTPUT_FIFO_WIDTH-1:0] output_data,
    input  logic                         output_rdy,
    output logic                         output_vld
);

    localparam DATA_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;

    // ---------------------------------------------------------------------------
    // Wires connecting to the interface FIFOs.
    // ---------------------------------------------------------------------------

    logic [ INPUT_FIFO_WIDTH-1:0] input_fifo_dout;
    logic                         params_fifo_deq;
    logic                         instr_fifo_deq;
    logic                         input_fifo_deq;
    logic                         input_fifo_empty_n;

    logic [OUTPUT_FIFO_WIDTH-1:0] output_fifo_din;
    logic                         output_fifo_enq;
    logic                         output_fifo_full_n;
    logic                         output_vld_w;

    // ---------------------------------------------------------------------------
    // Control signals coming out of aggregators/deaggregator
    // ---------------------------------------------------------------------------

    logic instr_wen;
    logic input_wen;
    logic output_wb_ren;
    
    // ---------------------------------------------------------------------------
    // Control signals coming out of the convolution controller 
    // ---------------------------------------------------------------------------

    logic                          instr_full_n;
    logic                          input_full_n;
    logic                          output_empty_n;

    logic [  INSTR_ADDR_WIDTH-1:0] instr_wadr;
    logic [GLB_MEM_ADDR_WIDTH-1:0] input_wadr;
    logic [GLB_MEM_ADDR_WIDTH-1:0] output_wb_radr;

    logic                          mat_inv_en;
    logic                          mat_inv_vld;
    logic                          mvp_core_en;

    // ---------------------------------------------------------------------------
    // Data connections between the MVP and memory.
    // ---------------------------------------------------------------------------

    logic [INSTR_ADDR_WIDTH-1:0]             pc;
    logic [            31:0]                 instr;

    logic                                    mem_read;
    logic                                    mem_write;
    logic [            11:0]                 mem_addr;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_write_data;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_read_data;

    logic                                    mat_inv_vld_out;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mat_inv_out;

    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] glb_mem_rdata;
    logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] input_aggregator_dout;
    logic [  DATA_WIDTH-1:0]                 instr_aggregator_dout;

    // ---------------------------------------------------------------------------
    //  MVP Core and memory
    // ---------------------------------------------------------------------------

    mvp_core #(
        .SIG_WIDTH         (SIG_WIDTH         ),
        .EXP_WIDTH         (EXP_WIDTH         ),
        .IEEE_COMPLIANCE   (IEEE_COMPLIANCE   ),
        .VECTOR_LANES      (VECTOR_LANES      ),
        .INSTR_ADDR_WIDTH  (INSTR_ADDR_WIDTH  ),
        .GLB_MEM_ADDR_WIDTH(GLB_MEM_ADDR_WIDTH)
    ) mvp_core_inst (
        .clk           (clk           ),
        .rst_n         (rst_n         ),
        .en            (mvp_core_en   ),
        .pc            (pc            ),
        .instr         (instr         ),
        .mem_write_en  (mem_write     ),
        .mem_read_en   (mem_read      ),
        .mem_addr      (mem_addr      ),
        .mem_write_data(mem_write_data),
        .mem_read_data (mem_read_data ),
        // Debug signals
        .data_out_vld  (              ),
        .data_out      (              ),
        .reg_wb        (              )
    );

    mat_inv mat_inv_inst (
        .clk        (clk                ),
        .rst_n      (rst_n              ),
        .en         (mat_inv_en         ),
        .vld        (mat_inv_vld        ),
        .rdy        (                   ),
        .vld_out    (mat_inv_vld_out    ),
        .mat_in     (mem_write_data[8:0]),
        .mat_inv_out(mat_inv_out[8:0]   )
    );

    if (VECTOR_LANES > 9)
        assign mat_inv_out[VECTOR_LANES-1:9] = '0;

    ram_sync_1rw1r #(
        .DATA_WIDTH(32              ),
        .ADDR_WIDTH(INSTR_ADDR_WIDTH),
        .DEPTH     (INSTR_BANK_DEPTH)
    ) instr_mem (
        .clk  (clk                  ),
        .wen  (instr_wen            ),
        .wadr (instr_wadr           ),
        .wdata(instr_aggregator_dout),
        .ren  (~instr_full_n        ),
        .radr (pc                   ),
        .rdata(instr                )
    );

    ram_sync_1rw1r #(
        .DATA_WIDTH(VECTOR_LANES*DATA_WIDTH),
        .ADDR_WIDTH(GLB_MEM_ADDR_WIDTH     ),
        .DEPTH     (GLB_MEM_BANK_DEPTH     )
    ) glb_mem (
        .clk  (clk                                               ),
        .wen  (input_wen | mem_write                             ),
        .wadr (input_wen ? input_wadr : mem_addr[11:4]           ),
        .wdata(input_wen ? input_aggregator_dout : mem_write_data),
        .ren  (output_wb_ren | mem_read                          ),
        .radr (output_wb_ren ? output_wb_radr : mem_addr[11:4]   ),
        .rdata(glb_mem_rdata                                     )
    );

  // ---------------------------------------------------------------------------
  //  Interface fifos
  // ---------------------------------------------------------------------------

    fifo #(
        .DATA_WIDTH   (INPUT_FIFO_WIDTH),
        .FIFO_DEPTH   (3               ),
        .COUNTER_WIDTH(1               )
    ) input_fifo_inst (
        .clk    (clk                     ),
        .rst_n  (rst_n                   ),
        .din    (input_data              ),
        .enq    (input_rdy_w && input_vld),
        .full_n (input_rdy_w             ),
        .dout   (input_fifo_dout         ),
        .deq    (params_fifo_deq || instr_fifo_deq || input_fifo_deq),
        .empty_n(input_fifo_empty_n      ),
        .clr    (1'b0                    )
    );

    assign input_rdy = input_rdy_w;

    aggregator #(
        .DATA_WIDTH (INPUT_FIFO_WIDTH   ),
        .FETCH_WIDTH(32/INPUT_FIFO_WIDTH)
    ) instr_aggregator_inst (
        .clk            (clk                  ),
        .rst_n          (rst_n                ),
        .sender_data    (input_fifo_dout      ),
        .sender_empty_n (input_fifo_empty_n   ),
        .sender_deq     (instr_fifo_deq       ),
        .receiver_data  (instr_aggregator_dout),
        .receiver_full_n(instr_full_n         ),
        .receiver_enq   (instr_wen            )
    );

    aggregator #(
        .DATA_WIDTH (INPUT_FIFO_WIDTH),
        .FETCH_WIDTH(VECTOR_LANES*DATA_WIDTH/INPUT_FIFO_WIDTH)
    ) input_aggregator_inst (
        .clk            (clk                  ),
        .rst_n          (rst_n                ),
        .sender_data    (input_fifo_dout      ),
        .sender_empty_n (input_fifo_empty_n   ),
        .sender_deq     (input_fifo_deq       ),
        .receiver_data  (input_aggregator_dout),
        .receiver_full_n(input_full_n         ),
        .receiver_enq   (input_wen            )
    );

    fifo #(
        .DATA_WIDTH   (OUTPUT_FIFO_WIDTH),
        .FIFO_DEPTH   (3                ),
        .COUNTER_WIDTH(1                )
    ) output_fifo_inst (
        .clk    (clk                       ),
        .rst_n  (rst_n                     ),
        .din    (output_fifo_din           ),
        .enq    (output_fifo_enq           ),
        .full_n (output_fifo_full_n        ),
        .dout   (output_data               ),
        .deq    (output_rdy && output_vld_w),
        .empty_n(output_vld_w              ),
        .clr    (1'b0                      )
    );

    assign output_vld = output_vld_w;

    deaggregator #(
        .DATA_WIDTH (DATA_WIDTH  ),
        .FETCH_WIDTH(VECTOR_LANES)
    ) output_deaggregator_inst (
        .clk            (clk               ),
        .rst_n          (rst_n             ),
        .sender_data    (glb_mem_rdata     ),
        .sender_empty_n (output_empty_n    ),
        .sender_deq     (output_wb_ren     ),
        .receiver_data  (output_fifo_din   ),
        .receiver_full_n(output_fifo_full_n),
        .receiver_enq   (output_fifo_enq   )
    );

    controller #(
        .CONFIG_DATA_WIDTH (CONFIG_DATA_WIDTH      ),
        .DATA_WIDTH        (VECTOR_LANES*DATA_WIDTH),
        .INSTR_ADDR_WIDTH  (INSTR_ADDR_WIDTH       ),
        .GLB_MEM_ADDR_WIDTH(GLB_MEM_ADDR_WIDTH     )
    ) controller_inst (
        .clk                (clk               ),
        .rst_n              (rst_n             ),

        .params_fifo_dout   (input_fifo_dout   ),
        .params_fifo_deq    (params_fifo_deq   ),
        .params_fifo_empty_n(input_fifo_empty_n),
        // Aggregator signal
        .instr_full_n       (instr_full_n      ),
        .input_full_n       (input_full_n      ),
        .output_empty_n     (output_empty_n    ),
        // Address generator
        .instr_wadr         (instr_wadr        ),
        .input_wadr         (input_wadr        ),
        .output_wb_radr     (output_wb_radr    ),
        // Input control signal
        .instr_wen          (instr_wen         ),
        .input_wen          (input_wen         ),
        .output_wb_ren      (output_wb_ren     ),
        // MMIO
        .mem_read           (mem_read          ),
        .mem_write          (mem_write         ),
        .mem_addr           (mem_addr          ),
        .mem_read_data      (mem_read_data     ),
        // Matrix inversion
        .mat_inv_en         (mat_inv_en        ),
        .mat_inv_vld        (mat_inv_vld       ),
        .mat_inv_vld_out    (mat_inv_vld_out   ),
        .mat_inv_out        (mat_inv_out       ),

        .mvp_core_en        (mvp_core_en       ),
        // Debug signal
        .state_r            (                  ),
        .config_adr         (                  ),
        .config_data        (                  )
    );

endmodule
