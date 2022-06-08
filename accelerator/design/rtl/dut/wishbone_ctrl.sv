module wishbone_ctl #(
    parameter WISHBONE_BASE_ADDR = 32'h30000000
) (
    // wishbone input
      input        wb_clk_i
    , input        wb_rst_i
    , input        wbs_stb_i
    , input        wbs_cyc_i
    , input        wbs_we_i
    , input  [3:0] wbs_sel_i
    , input [31:0] wbs_dat_i
    , input [31:0] wbs_adr_i
    // wishbone output
    , output        wbs_ack_o
    , output [31:0] wbs_dat_o
    // input from CGRA
    , input  [31:0] CGRA_read_config_data
    // output
    , output [31:0] CGRA_config_config_addr
	, output [31:0] CGRA_config_config_data
	, output        CGRA_config_read
	, output        CGRA_config_write
    , output  [3:0] CGRA_stall
    , output  [1:0] message
);

// ==============================================================================
// Wishbone Memory Mapped Address
// ==============================================================================
    localparam WBSADDR_CFG_ADDR  = 32'h30000000;
    localparam WBSADDR_CFG_WDATA = 32'h30000004;
    localparam WBSADDR_CFG_RDATA = 32'h30000008;
    localparam WBSADDR_CFG_WRITE = 32'h3000000C;
    localparam WBSADDR_CFG_READ  = 32'h30000010;
    localparam WBSADDR_STALL     = 32'h30000014;
    localparam WBSADDR_MESSAGE   = 32'h30000018;


// ==============================================================================
// CSR
// ==============================================================================
    reg [31:0] reg_cfg_addr;
    reg [31:0] reg_cfg_wdata;
    reg [31:0] reg_cfg_rdata;
    reg        reg_cfg_write;
    reg        reg_cfg_read;
    reg  [3:0] reg_stall;
    reg  [1:0] reg_message;

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
    always@(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            ack_o_shift_reg <= {SR_DEPTH{1'b0}};
        end
        else begin
            ack_o_shift_reg[0] <= wbs_req;
            for (i=0; i<SR_DEPTH-1; i=i+1) begin
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
    // WBSADDR_CFG_ADDR
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_cfg_addr <= 32'd0;
        else if (wbs_req_write && wbs_adr_i==WBSADDR_CFG_ADDR)
            reg_cfg_addr <= wbs_dat_i;
    // WBSADDR_CFG_WDATA
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_cfg_wdata <= 32'd0;
        else if (wbs_req_write && wbs_adr_i==WBSADDR_CFG_WDATA)
            reg_cfg_wdata <= wbs_dat_i;
    // WBSADDR_CFG_RDATA
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_cfg_rdata <= 32'd0;
        else if (wbs_req_read && wbs_adr_i==WBSADDR_CFG_RDATA)
            reg_cfg_rdata <= CGRA_read_config_data;
    // WBSADDR_CFG_WRITE
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_cfg_write <= 1'b0;
        else if (wbs_req_write && wbs_adr_i==WBSADDR_CFG_WRITE)
            reg_cfg_write <= wbs_dat_i[0];
        else
            reg_cfg_write <= 1'b0; // 1-pulse
    // WBSADDR_CFG_READ
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_cfg_read <= 1'b0;
        else if (wbs_req_write && wbs_adr_i==WBSADDR_CFG_READ)
            reg_cfg_read <= wbs_dat_i[0];
        //else
        //    reg_cfg_read <= 1'b0; // multicycle path, cannot be a pulse, need to stay
    // WBSADDR_STALL
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_stall <= 4'b1111;
        else if (wbs_req_write && wbs_adr_i==WBSADDR_STALL)
            reg_stall <= wbs_dat_i[3:0];
    // WBSADDR_MESSAGE
    always@(posedge wb_clk_i)
        if (wb_rst_i)
            reg_message <= 2'b00;
        else if (wbs_req_write && wbs_adr_i==WBSADDR_MESSAGE)
            reg_message <= wbs_dat_i[1:0];

    // ==============================================================================
    // Outputs
    // ==============================================================================
    assign wbs_ack_o               = ack_o;
    assign wbs_dat_o               = reg_cfg_rdata;
    assign CGRA_config_config_addr = reg_cfg_addr;
    assign CGRA_config_config_data = reg_cfg_wdata;
    assign CGRA_config_write       = reg_cfg_write;
    assign CGRA_config_read        = reg_cfg_read;
    assign CGRA_stall              = reg_stall;
    assign message                 = reg_message;

endmodule