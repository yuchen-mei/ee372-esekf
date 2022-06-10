module wishbone_ctl #(
    parameter WISHBONE_BASE_ADDR = 32'h30000000
) (
    // wishbone input
    input  logic        wb_clk_i,
    input  logic        wb_rst_i,
    input  logic        wbs_stb_i,
    input  logic        wbs_cyc_i,
    input  logic        wbs_we_i,
    input  logic [ 3:0] wbs_sel_i,
    input  logic [31:0] wbs_dat_i,
    input  logic [31:0] wbs_adr_i,
    // wishbone output
    output logic        wbs_ack_o,
    output logic [31:0] wbs_dat_o,
    // output
    output logic        wbs_debug,
    output logic        fsm_start,

    output logic        wbs_mem_csb,
    output logic        wbs_mem_web,
    output logic [11:0] wbs_mem_addr,
    output logic [31:0] wbs_mem_wdata,
    input  logic [31:0] wbs_mem_rdata
);

// ==============================================================================
// Wishbone Memory Mapped Address
// ==============================================================================
    localparam WBS_ADDR_MASK       = 32'hFFFF_0000;
    localparam WBS_MEM_ADDR        = 32'h3000_0000;
    localparam WBS_FSM_START_ADDR  = 32'h3001_0000;

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
    // if 1, occupies all memory's control
    // always @(posedge wb_clk_i) begin
    //     if (wb_rst_i)
    //         wbs_debug <= '0;
    //     else if (wbs_valid_q & wbs_we_i_q & (wbs_adr_i_q == WBS_DEBUG_ADDR)) begin
    //         wbs_debug <= wbs_dat_i_q[0];
    //     end
    // end

    wire wbs_req_write = (!ack_o) & wbs_req & (wbs_we_i );
    wire wbs_req_read  = (!ack_o) & wbs_req & (~wbs_we_i);
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_mem_csb   <= 0;
            wbs_mem_web   <= 0;
            wbs_mem_addr  <= 12'b0;
            wbs_mem_wdata <= 32'b0;
        end
        else if ((wbs_adr_i & WBS_ADDR_MASK) == WBS_MEM_ADDR) begin
            wbs_mem_addr  <= wbs_adr_i[11:0];
            wbs_mem_csb   <= wbs_req_write || wbs_req_read;
            wbs_mem_web   <= wbs_req_write;
	        wbs_mem_wdata <= wbs_dat_i;
        end
    end

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            fsm_start <= 0;
        end
        else if (wbs_adr_i == WBS_FSM_START_ADDR) begin
            fsm_start <= 1;
        end
    end

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            wbs_dat_o <= 32'd0;
        end
        else if (wbs_req_read && (wbs_adr_i & WBS_ADDR_MASK) == WBS_MEM_ADDR) begin
            wbs_dat_o <= wbs_mem_rdata;
        end
    end

    // ==============================================================================
    // Outputs
    // ==============================================================================
    assign wbs_ack_o = ack_o;

endmodule
