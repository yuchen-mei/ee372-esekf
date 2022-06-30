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
    // GPIO
    input  logic [ INPUT_FIFO_WIDTH-1:0] input_data,
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
    input  logic [                 11:0] wbs_mem_addr,
    input  logic [                 31:0] wbs_mem_wdata,
    output logic [                 31:0] wbs_mem_rdata
);

    localparam DATA_WIDTH = SIG_WIDTH + EXP_WIDTH + 1;
    localparam ADDR_WIDTH = 12;

    // ---------------------------------------------------------------------------
    // Wires connecting to the interface FIFOs.
    // ---------------------------------------------------------------------------

    logic [ INPUT_FIFO_WIDTH-1:0] input_fifo_dout;
    logic                         params_fifo_deq;
    logic                         instr_fifo_deq;
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
    logic [ DATA_MEM_ADDR_WIDTH-1:0] input_wadr;
    logic [ DATA_MEM_ADDR_WIDTH-1:0] output_wb_radr;

    logic                            mat_inv_en;
    logic                            mat_inv_vld;
    logic                            mvp_core_en;

    // ---------------------------------------------------------------------------
    // Data connections between the MVP and memory.
    // ---------------------------------------------------------------------------

    logic                                            mvp_mem_we;
    logic                                            mvp_mem_re;
    logic [          ADDR_WIDTH-1:0]                 mvp_mem_addr;
    logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] mvp_mem_wdata;
    logic [                     2:0]                 width;

    logic                                            instr_mem_csb;
    logic                                            instr_mem_web;
    logic [INSTR_MEM_ADDR_WIDTH-1:0]                 instr_mem_addr;
    logic [          DATA_WIDTH-1:0]                 instr_mem_wdata;
    logic [          DATA_WIDTH-1:0]                 instr_mem_rdata;
    logic [INSTR_MEM_ADDR_WIDTH-1:0]                 pc;
    logic [                    31:0]                 instr;

    logic                                            data_mem_csb;
    logic                                            data_mem_web;
    logic [         DATAPATH/32-1:0]                 data_mem_wmask;
    logic [ DATA_MEM_ADDR_WIDTH-1:0]                 data_mem_addr;
    logic [            DATAPATH-1:0]                 data_mem_wdata;
    logic [            DATAPATH-1:0]                 data_mem_rdata;
    logic [            DATAPATH-1:0]                 output_wb_data;

    logic                                            mem_ctrl_we;
    logic                                            mem_ctrl_re;
    logic [          ADDR_WIDTH-1:0]                 mem_ctrl_addr;
    logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_ctrl_wdata;
    logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_ctrl_rdata;
    logic [                     2:0]                 mem_ctrl_width;

    logic                                            instr_mem_ctrl_csb;
    logic                                            instr_mem_ctrl_web;
    logic [INSTR_MEM_ADDR_WIDTH-1:0]                 instr_mem_ctrl_addr;
    logic [          DATA_WIDTH-1:0]                 instr_mem_ctrl_wdata;

    logic                                            data_mem_ctrl_csb;
    logic                                            data_mem_ctrl_web;
    logic [         DATAPATH/32-1:0]                 data_mem_ctrl_wmask;
    logic [ DATA_MEM_ADDR_WIDTH-1:0]                 data_mem_ctrl_addr;
    logic [            DATAPATH-1:0]                 data_mem_ctrl_wdata;

    logic                                            mat_inv_vld_out;
    logic [        9*DATA_WIDTH-1:0]                 mat_inv_out_l;
    logic [        9*DATA_WIDTH-1:0]                 mat_inv_out_u;

    logic [                    31:0]                 instr_aggregator_dout;
    logic [            DATAPATH-1:0]                 input_aggregator_dout;


    // ---------------------------------------------------------------------------
    //  MVP Core and memory
    // ---------------------------------------------------------------------------

    mvp_core #(
        .SIG_WIDTH           (SIG_WIDTH           ),
        .EXP_WIDTH           (EXP_WIDTH           ),
        .IEEE_COMPLIANCE     (IEEE_COMPLIANCE     ),
        .VECTOR_LANES        (VECTOR_LANES        ),
        .INSTR_MEM_ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH)
    ) mvp_core_inst (
        .clk                 (clk                 ),
        .rst_n               (rst_n               ),
        .en                  (mvp_core_en         ),
        .pc                  (pc                  ),
        .instr               (instr               ),
        .mem_addr            (mvp_mem_addr        ),
        .mem_write           (mvp_mem_we          ),
        .mem_read            (mvp_mem_re          ),
        .mem_wdata           (mvp_mem_wdata       ),
        .mem_rdata           (mem_ctrl_rdata      ),
        .width               (width               )
    );

    mat_inv #(
        .DATA_WIDTH   (DATA_WIDTH        )
    ) mat_inv_inst (
        .clk          (clk               ),
        .rst_n        (rst_n             ),
        .en           (mat_inv_en        ),
        .vld          (mat_inv_vld       ),
        .mat_in       (mvp_mem_wdata[8:0]),
        .rdy          (                  ),
        .vld_out      (mat_inv_vld_out   ),
        .mat_inv_out_l(mat_inv_out_l     ),
        .mat_inv_out_u(mat_inv_out_u     )
    );

    ram_sync_1rw1r #(
        .DATA_WIDTH(32                  ),
        .ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
        .DEPTH     (INSTR_MEM_BANK_DEPTH)
    ) instr_mem (
        .clk       (clk                 ),
        .csb0      (instr_mem_csb       ),
        .web0      (instr_mem_web       ),
        .addr0     (instr_mem_addr      ),
        .wmask0    (1'b1                ),
        .din0      (instr_mem_wdata     ),
        .dout0     (instr_mem_rdata     ),
        .csb1      (~instr_full_n       ),
        .addr1     (pc                  ),
        .dout1     (instr               )
    );

    ram_sync_1rw1r #(
        .DATA_WIDTH(DATAPATH           ),
        .ADDR_WIDTH(DATA_MEM_ADDR_WIDTH),
        .DEPTH     (DATA_MEM_BANK_DEPTH)
    ) data_mem (
        .clk       (clk                ),
        .csb0      (data_mem_csb       ),
        .web0      (data_mem_web       ),
        .addr0     (data_mem_addr      ),
        .wmask0    (data_mem_wmask     ),
        .din0      (data_mem_wdata     ),
        .dout0     (data_mem_rdata     ),
        .csb1      (output_wb_ren      ),
        .addr1     (output_wb_radr     ),
        .dout1     (output_wb_data     )
    );

    always_comb begin
        if (instr_wen) begin
            instr_mem_csb   = instr_wen;
            instr_mem_web   = 1'b1;
            instr_mem_addr  = instr_wadr;
            instr_mem_wdata = instr_aggregator_dout;
        end
        else begin
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
        end
        else begin
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
        end
        else begin
            mem_ctrl_we    = mvp_mem_we;
            mem_ctrl_re    = mvp_mem_re;
            mem_ctrl_addr  = mvp_mem_addr;
            mem_ctrl_wdata = mvp_mem_wdata;
            mem_ctrl_width = width;
        end
    end

    memory_controller #(
        .ADDR_WIDTH          (ADDR_WIDTH          ),
        .DATA_WIDTH          (DATA_WIDTH          ),
        .VECTOR_LANES        (VECTOR_LANES        ),
        .DATAPATH            (DATAPATH            ),
        .INSTR_MEM_ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
        .DATA_MEM_ADDR_WIDTH (DATA_MEM_ADDR_WIDTH )
    ) mem_ctrl_inst (
        .clk                 (clk                 ),
        // Physical memory address
        .mem_we              (mem_ctrl_we         ),
        .mem_re              (mem_ctrl_re         ),
        .mem_addr            (mem_ctrl_addr       ),
        .mem_wdata           (mem_ctrl_wdata      ),
        .mem_rdata           (mem_ctrl_rdata      ),
        .width               (mem_ctrl_width      ),
        // Instruction memory
        .instr_mem_csb       (instr_mem_ctrl_csb  ),
        .instr_mem_web       (instr_mem_ctrl_web  ),
        .instr_mem_addr      (instr_mem_ctrl_addr ),
        .instr_mem_wdata     (instr_mem_ctrl_wdata),
        .instr_mem_rdata     (instr_mem_rdata     ),
        // Data memory
        .data_mem_csb        (data_mem_ctrl_csb   ),
        .data_mem_web        (data_mem_ctrl_web   ),
        .data_mem_addr       (data_mem_ctrl_addr  ),
        .data_mem_wmask      (data_mem_ctrl_wmask ),
        .data_mem_wdata      (data_mem_ctrl_wdata ),
        .data_mem_rdata      (data_mem_rdata      ),
        // Matrix inversion
        .mat_inv_out_l       (mat_inv_out_l       ),
        .mat_inv_out_u       (mat_inv_out_u       )
    );

    assign wbs_mem_rdata = mem_ctrl_rdata;

  // ---------------------------------------------------------------------------
  //  Interface fifos
  // ---------------------------------------------------------------------------

    fifo #(
        .DATA_WIDTH   (INPUT_FIFO_WIDTH        ),
        .FIFO_DEPTH   (3                       ),
        .COUNTER_WIDTH(1                       )
    ) input_fifo_inst (
        .clk          (clk                     ),
        .rst_n        (rst_n                   ),
        .din          (input_data              ),
        .enq          (input_rdy_w && input_vld),
        .full_n       (input_rdy_w             ),
        .dout         (input_fifo_dout         ),
        .deq          (params_fifo_deq | instr_fifo_deq | input_fifo_deq),
        .empty_n      (input_fifo_empty_n      ),
        .clr          (1'b0                    )
    );

    assign input_rdy = input_rdy_w;

    aggregator #(
        .DATA_WIDTH     (INPUT_FIFO_WIDTH     ),
        .FETCH_WIDTH    (32/INPUT_FIFO_WIDTH  )
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
        .DATA_WIDTH     (INPUT_FIFO_WIDTH         ),
        .FETCH_WIDTH    (DATAPATH/INPUT_FIFO_WIDTH)
    ) input_aggregator_inst (
        .clk            (clk                      ),
        .rst_n          (rst_n                    ),
        .sender_data    (input_fifo_dout          ),
        .sender_empty_n (input_fifo_empty_n       ),
        .sender_deq     (input_fifo_deq           ),
        .receiver_data  (input_aggregator_dout    ),
        .receiver_full_n(input_full_n             ),
        .receiver_enq   (input_wen                )
    );

    fifo #(
        .DATA_WIDTH   (OUTPUT_FIFO_WIDTH         ),
        .FIFO_DEPTH   (3                         ),
        .COUNTER_WIDTH(1                         )
    ) output_fifo_inst (
        .clk          (clk                       ),
        .rst_n        (rst_n                     ),
        .din          (output_fifo_din           ),
        .enq          (output_fifo_enq           ),
        .full_n       (output_fifo_full_n        ),
        .dout         (output_data               ),
        .deq          (output_rdy && output_vld_w),
        .empty_n      (output_vld_w              ),
        .clr          (1'b0                      )
    );

    assign output_vld = output_vld_w;

    deaggregator #(
        .DATA_WIDTH     (OUTPUT_FIFO_WIDTH         ),
        .FETCH_WIDTH    (DATAPATH/OUTPUT_FIFO_WIDTH)
    ) output_deaggregator_inst (
        .clk            (clk                       ),
        .rst_n          (rst_n                     ),
        .sender_data    (output_wb_data            ),
        .sender_empty_n (output_empty_n            ),
        .sender_deq     (output_wb_ren             ),
        .receiver_data  (output_fifo_din           ),
        .receiver_full_n(output_fifo_full_n        ),
        .receiver_enq   (output_fifo_enq           )
    );

    controller #(
        .INPUT_FIFO_WIDTH    (INPUT_FIFO_WIDTH    ),
        .ADDR_WIDTH          (ADDR_WIDTH          ),
        .INSTR_MEM_ADDR_WIDTH(INSTR_MEM_ADDR_WIDTH),
        .DATA_MEM_ADDR_WIDTH (DATA_MEM_ADDR_WIDTH ),
        .CONFIG_DATA_WIDTH   (CONFIG_DATA_WIDTH   )
    ) controller_inst (
        .clk                 (clk                 ),
        .rst_n               (rst_n               ),
        .wbs_debug           (wbs_debug           ),
        .wbs_fsm_start       (wbs_fsm_start       ),
        .wbs_fsm_done        (wbs_fsm_done        ),
        // Configuration data
        .params_fifo_dout    (input_fifo_dout     ),
        .params_fifo_deq     (params_fifo_deq     ),
        .params_fifo_empty_n (input_fifo_empty_n  ),
        // Aggregator signal
        .instr_full_n        (instr_full_n        ),
        .input_full_n        (input_full_n        ),
        .output_empty_n      (output_empty_n      ),
        // Address generator
        .instr_wadr          (instr_wadr          ),
        .input_wadr          (input_wadr          ),
        .output_wb_radr      (output_wb_radr      ),
        // Input control signal
        .instr_wen           (instr_wen           ),
        .input_wen           (input_wen           ),
        .output_wb_ren       (output_wb_ren       ),
        // MMIO
        .mem_addr            (mvp_mem_addr        ),
        .mem_read            (mvp_mem_re          ),
        .mem_write           (mvp_mem_we          ),
        // Matrix inversion
        .mat_inv_en          (mat_inv_en          ),
        .mat_inv_vld         (mat_inv_vld         ),
        .mat_inv_vld_out     (mat_inv_vld_out     ),
        .mvp_core_en         (mvp_core_en         )
    );

endmodule
