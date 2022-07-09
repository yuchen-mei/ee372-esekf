module wishbone_ctl #(
    parameter DATAPATH = 256
) (
    // wishbone input
    input  logic                wb_clk_i,
    input  logic                wb_rst_i,
    input  logic                wbs_stb_i,
    input  logic                wbs_cyc_i,
    input  logic                wbs_we_i,
    input  logic          [3:0] wbs_sel_i,
    input  logic         [31:0] wbs_dat_i,
    input  logic         [31:0] wbs_adr_i,
    // wishbone output
    output logic                wbs_ack_o,
    output logic         [31:0] wbs_dat_o,
    // output
    output logic                wbs_debug,
    output logic                wbs_fsm_start,
    input  logic                wbs_fsm_done,

    output logic                wbs_mem_we,
    output logic                wbs_mem_re,
    output logic         [11:0] wbs_mem_addr,
    output logic [DATAPATH-1:0] wbs_mem_wdata,
    input  logic [DATAPATH-1:0] wbs_mem_rdata
);

// ==============================================================================
// Wishbone Memory Mapped Address
// ==============================================================================

    localparam WBS_DEBUG_ADDR     = 32'h30000000;
    localparam WBS_FSM_START_ADDR = 32'h30000004;
    localparam WBS_FSM_DONE_ADDR  = 32'h30000008;
    localparam WBS_MEM_MASK       = 32'hFFFF0000;
    localparam WBS_MEM_ADDR       = 32'h30010000;

    localparam DATA_MEM_MASK      = 12'h800;
    localparam DATA_MEM_ADDR      = 12'h000;
    localparam TEXT_MEM_MASK      = 12'he00;
    localparam TEXT_MEM_ADDR      = 12'h800;

// ==============================================================================
// FSM Handling Memory Read/Write
// ==============================================================================

    typedef enum logic [2:0] {
        STANDBY    = 3'd0,
        MEM_READ1  = 3'd1,
        MEM_READ2  = 3'd2,
        MEM_READ3  = 3'd3,
        MEM_READ4  = 3'd4,
        MEM_WRITE1 = 3'd5,
        MEM_WRITE2 = 3'd6
    } wb_ctrl_state_t;

    wb_ctrl_state_t state;
    wb_ctrl_state_t next_state;

    logic                wbs_req;
    logic                wbs_mem_write;
    logic                wbs_mem_read;
    logic                mem_rdata_shift;
    logic                mem_wdata_shift;
    logic                fsm_status_rd;
    logic         [31:0] wbs_adr_r1;
    logic         [31:0] wbs_adr_r2;
    logic [DATAPATH-1:0] mem_write_data;
    logic [DATAPATH-1:0] mem_write_data_shifted;
    logic [DATAPATH-1:0] mem_read_data;
    logic [DATAPATH-1:0] mem_read_data_shifted;

    assign wbs_req       = wbs_stb_i & wbs_cyc_i;
    assign wbs_mem_write = wbs_req & wbs_we_i;
    assign wbs_mem_read  = wbs_req & !wbs_we_i;
    assign fsm_status_rd = wbs_mem_read & (wbs_adr_i == WBS_FSM_DONE_ADDR);

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i) state <= STANDBY;
        else          state <= next_state;
    end

    always_comb begin
        next_state      = state;
        wbs_mem_we      = 0;
        wbs_mem_re      = 0;
        wbs_mem_addr    = 0;
        wbs_ack_o       = 0;
        mem_wdata_shift = 0;
        mem_rdata_shift = 0;

        case (state)
            STANDBY: begin
                if (wbs_mem_write & ((wbs_adr_i & WBS_MEM_MASK) == WBS_MEM_ADDR))
                    next_state = MEM_WRITE1;
                else if (wbs_mem_write)
                    wbs_ack_o = 1;

                if (wbs_mem_read & ((wbs_adr_i & WBS_MEM_MASK) == WBS_MEM_ADDR))
                    next_state = MEM_READ1;
                else if (wbs_mem_read)
                    wbs_ack_o = 1;
            end
            MEM_READ1: begin
                // send read signal to accelerator
                next_state   = MEM_READ2;
                wbs_mem_re   = 1;
                wbs_mem_addr = wbs_adr_r1[13:2];
            end
            MEM_READ2: begin
                // register memory read data
                next_state = MEM_READ3;
            end
            MEM_READ3: begin
                // shift read data if it comes from data memory
                next_state      = MEM_READ4;
                mem_rdata_shift = 1;
            end
            MEM_READ4: begin
                // output read data and ack
                next_state = STANDBY;
                wbs_ack_o  = 1'b1;
            end
            MEM_WRITE1: begin
                // shift input write data
                next_state      = MEM_WRITE2;
                mem_wdata_shift = 1;
            end
            MEM_WRITE2: begin
                // send write signal to accelerator
                next_state   = STANDBY;
                wbs_mem_we   = 1;
                wbs_mem_addr = wbs_adr_r2[13:2];
                wbs_ack_o    = 1'b1;
            end
        endcase
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            wbs_debug <= 0;
        else if (wbs_mem_write & (wbs_adr_i == WBS_DEBUG_ADDR))
            wbs_debug <= wbs_dat_i[0];
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            wbs_fsm_start <= 0;
        else if (wbs_mem_write & (wbs_adr_i == WBS_FSM_START_ADDR))
            wbs_fsm_start <= wbs_dat_i[0];
        else
            wbs_fsm_start <= 0;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            mem_write_data <= 32'b0;
        else if (wbs_mem_write && ((wbs_adr_i & WBS_MEM_MASK) == WBS_MEM_ADDR))
            mem_write_data <= wbs_dat_i;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            mem_write_data_shifted <= 32'b0;
        else if (mem_wdata_shift & ((wbs_adr_r1[13:2] & DATA_MEM_MASK) == DATA_MEM_ADDR))
            mem_write_data_shifted <= mem_write_data << {wbs_adr_r1[4:2], 5'b0};
        else if (mem_wdata_shift)
            mem_write_data_shifted <= mem_write_data;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            mem_read_data <= 32'b0;
        else if (state == MEM_READ2)
            mem_read_data <= wbs_mem_rdata;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i)
            mem_read_data_shifted <= 32'b0;
        else if (mem_rdata_shift & ((wbs_adr_r2[13:2] & DATA_MEM_MASK) == DATA_MEM_ADDR))
            mem_read_data_shifted <= mem_read_data >> {wbs_adr_r2[4:2], 5'b0};
        else if (mem_rdata_shift)
            mem_read_data_shifted <= mem_read_data;
    end

    always_ff @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_adr_r1 <= 0;
            wbs_adr_r2 <= 0;
        end else begin
            wbs_adr_r1 <= wbs_adr_i;
            wbs_adr_r2 <= wbs_adr_r1;
        end
    end

    assign wbs_mem_wdata = mem_write_data_shifted;
    assign wbs_dat_o     = fsm_status_rd ? wbs_fsm_done : mem_read_data_shifted;

endmodule
