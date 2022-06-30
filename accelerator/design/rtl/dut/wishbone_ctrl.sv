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
    output logic        wbs_mem_re,
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
// FSM Handling Memory Read/Write
// ==============================================================================

    typedef enum logic [2:0] {
        STANDBY   = 3'd0,
        MEM_READ1 = 3'd1,
        MEM_READ2 = 3'd2,
        MEM_READ3 = 3'd3,
        MEM_WRITE = 3'd4
    } wb_ctrl_state_t;

    wb_ctrl_state_t state;
    wb_ctrl_state_t next_state;

    logic [31:0] wbs_adr_r1;
    logic [31:0] wbs_adr_r2;
    logic [31:0] wbs_read_data;
    logic        wbs_req;

    assign wbs_req = wbs_stb_i & wbs_cyc_i;

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i) state <= STANDBY;
        else          state <= next_state;
    end

    always_comb begin
        next_state = state;
        wbs_mem_we = 0;
        wbs_mem_re = 0;
        wbs_ack_o  = 0;

        unique case (state)
            STANDBY: begin
                if (wbs_req & wbs_we_i)
                    next_state = MEM_WRITE;

                if (wbs_req & ~wbs_we_i) begin
                    if ((wbs_adr_i & WBS_MEM_MASK) == WBS_MEM_ADDR)
                        next_state = MEM_READ1;
                    else
                        next_state = MEM_READ2;
                end
            end
            MEM_READ1: begin
                next_state = MEM_READ2;
                wbs_mem_re = 1;
            end
            MEM_READ2: begin
                next_state = MEM_READ3;

                if (wbs_adr_r1 == WBS_FSM_DONE_ADDR)
                    wbs_read_data = wbs_fsm_done;
                else if ((wbs_adr_r2 & WBS_MEM_MASK) == WBS_MEM_ADDR)
                    wbs_read_data = wbs_mem_rdata;
            end
            MEM_READ3: begin
                next_state = STANDBY;
                wbs_ack_o  = 1'b1;
            end
            MEM_WRITE: begin
                next_state = STANDBY;
                wbs_mem_we = ((wbs_adr_r1 & WBS_MEM_MASK) == WBS_MEM_ADDR);
                wbs_ack_o  = 1'b1;
            end
        endcase
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            wbs_debug <= 0;
        else if (wbs_req & wbs_we_i & (wbs_adr_i == WBS_DEBUG_ADDR))
            wbs_debug <= wbs_dat_i[0];
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            wbs_fsm_start <= 0;
        else if (wbs_req & wbs_we_i & (wbs_adr_i == WBS_FSM_START_ADDR))
            wbs_fsm_start <= wbs_dat_i[0];
        else
            wbs_fsm_start <= 0;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            wbs_mem_wdata <= 32'b0;
        else if (wbs_req && ((wbs_adr_i & WBS_MEM_MASK) == WBS_MEM_ADDR))
            wbs_mem_wdata <= wbs_dat_i;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_adr_r1 <= 0;
            wbs_adr_r2 <= 0;
            wbs_dat_o  <= 32'b0;
        end else begin
            wbs_adr_r1 <= wbs_adr_i;
            wbs_adr_r2 <= wbs_adr_r1;
            wbs_dat_o  <= wbs_read_data;
        end
    end

    assign wbs_mem_addr = wbs_adr_r1[13:2];

endmodule
