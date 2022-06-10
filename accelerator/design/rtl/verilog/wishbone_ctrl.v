module wishbone_ctl (
	wb_clk_i,
	wb_rst_i,
	wbs_stb_i,
	wbs_cyc_i,
	wbs_we_i,
	wbs_sel_i,
	wbs_dat_i,
	wbs_adr_i,
	wbs_ack_o,
	wbs_dat_o,
	CGRA_read_config_data,
	CGRA_config_config_addr,
	CGRA_config_config_data,
	CGRA_config_read,
	CGRA_config_write,
	CGRA_stall,
	message
);
	parameter WISHBONE_BASE_ADDR = 32'h30000000;
	input wb_clk_i;
	input wb_rst_i;
	input wbs_stb_i;
	input wbs_cyc_i;
	input wbs_we_i;
	input [3:0] wbs_sel_i;
	input [31:0] wbs_dat_i;
	input [31:0] wbs_adr_i;
	output wire wbs_ack_o;
	output wire [31:0] wbs_dat_o;
	input [31:0] CGRA_read_config_data;
	output wire [31:0] CGRA_config_config_addr;
	output wire [31:0] CGRA_config_config_data;
	output wire CGRA_config_read;
	output wire CGRA_config_write;
	output wire [3:0] CGRA_stall;
	output wire [1:0] message;
	localparam WBSADDR_CFG_ADDR = 32'h30000000;
	localparam WBSADDR_CFG_WDATA = 32'h30000004;
	localparam WBSADDR_CFG_RDATA = 32'h30000008;
	localparam WBSADDR_CFG_WRITE = 32'h3000000c;
	localparam WBSADDR_CFG_READ = 32'h30000010;
	localparam WBSADDR_STALL = 32'h30000014;
	localparam WBSADDR_MESSAGE = 32'h30000018;
	reg [31:0] reg_cfg_addr;
	reg [31:0] reg_cfg_wdata;
	reg [31:0] reg_cfg_rdata;
	reg reg_cfg_write;
	reg reg_cfg_read;
	reg [3:0] reg_stall;
	reg [1:0] reg_message;
	wire wbs_req = wbs_stb_i & wbs_cyc_i;
	wire ack_o;
	localparam SR_DEPTH = 4;
	integer i;
	reg [3:0] ack_o_shift_reg;
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			ack_o_shift_reg <= {SR_DEPTH {1'b0}};
		else begin
			ack_o_shift_reg[0] <= wbs_req;
			for (i = 0; i < 3; i = i + 1)
				ack_o_shift_reg[i + 1] <= ack_o_shift_reg[i];
		end
	assign ack_o = ack_o_shift_reg[0];
	wire wbs_req_write = (!ack_o & wbs_req) & wbs_we_i;
	wire wbs_req_read = (!ack_o & wbs_req) & ~wbs_we_i;
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_cfg_addr <= 32'd0;
		else if (wbs_req_write && (wbs_adr_i == WBSADDR_CFG_ADDR))
			reg_cfg_addr <= wbs_dat_i;
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_cfg_wdata <= 32'd0;
		else if (wbs_req_write && (wbs_adr_i == WBSADDR_CFG_WDATA))
			reg_cfg_wdata <= wbs_dat_i;
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_cfg_rdata <= 32'd0;
		else if (wbs_req_read && (wbs_adr_i == WBSADDR_CFG_RDATA))
			reg_cfg_rdata <= CGRA_read_config_data;
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_cfg_write <= 1'b0;
		else if (wbs_req_write && (wbs_adr_i == WBSADDR_CFG_WRITE))
			reg_cfg_write <= wbs_dat_i[0];
		else
			reg_cfg_write <= 1'b0;
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_cfg_read <= 1'b0;
		else if (wbs_req_write && (wbs_adr_i == WBSADDR_CFG_READ))
			reg_cfg_read <= wbs_dat_i[0];
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_stall <= 4'b1111;
		else if (wbs_req_write && (wbs_adr_i == WBSADDR_STALL))
			reg_stall <= wbs_dat_i[3:0];
	always @(posedge wb_clk_i)
		if (wb_rst_i)
			reg_message <= 2'b00;
		else if (wbs_req_write && (wbs_adr_i == WBSADDR_MESSAGE))
			reg_message <= wbs_dat_i[1:0];
	assign wbs_ack_o = ack_o;
	assign wbs_dat_o = reg_cfg_rdata;
	assign CGRA_config_config_addr = reg_cfg_addr;
	assign CGRA_config_config_data = reg_cfg_wdata;
	assign CGRA_config_write = reg_cfg_write;
	assign CGRA_config_read = reg_cfg_read;
	assign CGRA_stall = reg_stall;
	assign message = reg_message;
endmodule


