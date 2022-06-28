module wishbone_ctl #(
    parameter WISHBONE_BASE_ADDR = 32'h30000000
) (
    // wishbone input
    input  logic        wb_clk_i,
    input  logic        wb_rst_i,
    input  logic        wbs_stb_i,
    input  logic        wbs_cyc_i,
    input  logic        wbs_we_i,
    input  logic  [3:0] wbs_sel_i,
    input  logic [31:0] wbs_dat_i,
    input  logic [31:0] wbs_adr_i,
    // wishbone output
    output logic        wbs_ack_o,
    output logic [31:0] wbs_dat_o,
    // output
    output logic        wbs_debug,
    output logic        wbs_fsm_start,
    input  logic        wbs_fsm_done,

    output logic        wbs_mem_we,
    output logic        wbs_mem_ren,
    output logic [11:0] wbs_mem_addr,
    output logic [31:0] wbs_mem_wdata,
    input  logic [31:0] wbs_mem_rdata
);

// ==============================================================================
// Wishbone Memory Mapped Address
// ==============================================================================
    localparam WBS_DEBUG_ADDR     = 32'h30000000;
    localparam WBS_FSM_START_ADDR = 32'h30000004;
    localparam WBS_FSM_DONE_ADDR  = 32'h30000008;
    localparam WBS_MEM_MASK       = 32'hFFFF0000;
    localparam WBS_MEM_ADDR       = 32'h30010000;

// ==============================================================================
// Request, Acknowledgement
// ==============================================================================
    wire wbs_req = wbs_stb_i & wbs_cyc_i;
    wire ack_o;

    // ack
    // always@(posedge wb_clk_i) begin
    //     if (wb_rst_i) ack_o <= 1'b0;
    //     else          ack_o <= wbs_req; // assume we can always process request immediately;
    // end

    // shift reg for ack_o
    localparam SR_DEPTH = 4;
    integer i;
    reg [SR_DEPTH-1:0] ack_o_shift_reg;
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            ack_o_shift_reg <= {SR_DEPTH{1'b0}};
        end
        else begin
            ack_o_shift_reg[0] <= wbs_req;
            for (i = 0; i < SR_DEPTH-1; i = i+1) begin
                ack_o_shift_reg[i+1] <= ack_o_shift_reg[i];
            end
        end
    end

    assign ack_o = ack_o_shift_reg[0]; // assume we can always process request immediately;
    // assign ack_o = ack_o_shift_reg[3]; // delay N cycles for the ack, see how the wishbone behaves

// ==============================================================================
// Latching
// ==============================================================================
    wire wbs_req_write = (!ack_o) & wbs_req & (wbs_we_i );
    wire wbs_req_read  = (!ack_o) & wbs_req & (~wbs_we_i);

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_debug <= 0;
        end
        else if (wbs_req_write && wbs_adr_i == WBS_DEBUG_ADDR) begin
            wbs_debug <= wbs_dat_i[0];
        end
    end

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_fsm_start <= 0;
        end
        else if (wbs_req_write && wbs_adr_i == WBS_FSM_START_ADDR) begin
            wbs_fsm_start <= wbs_dat_i[0];
        end
        else begin
            wbs_fsm_start <= 0;
        end
    end

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_mem_we    <= 1'b0;
            wbs_mem_addr  <= 12'b0;
            wbs_mem_wdata <= 0;
        end
        else if (wbs_req_write && ((wbs_adr_i & WBS_MEM_MASK) == WBS_MEM_ADDR)) begin
            wbs_mem_we    <= 1'b1;
            wbs_mem_addr  <= wbs_adr_i[13:2];
            wbs_mem_wdata <= wbs_dat_i;
        end
        else begin
            wbs_mem_we <= 1'b0;
        end
    end

    logic [31:0] wbs_adr_i_q;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_adr_i_q <= 0;
        end
        else begin
            wbs_adr_i_q <= wbs_adr_i;
        end
    end

    always_comb
        if ((wbs_adr_i_q & WBS_MEM_MASK) == WBS_MEM_ADDR)
            wbs_dat_o = wbs_mem_rdata;
        else if (wbs_adr_i_q == WBS_FSM_DONE_ADDR)
            wbs_dat_o = wbs_fsm_done;
        else
            wbs_dat_o = 'X;

    // ==============================================================================
    // Outputs
    // ==============================================================================
    assign wbs_ack_o = ack_o;

endmodule
