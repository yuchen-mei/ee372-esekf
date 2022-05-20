module square_PE_Tri #(
    parameter DWIDTH = 32
) (
    input logic clk, rst_n, en,
    input logic [DWIDTH - 1 : 0] xin, sqr_x, zin,
    output logic [DWIDTH - 1 : 0] xout, zout
    );
    
    logic [DWIDTH - 1 : 0] zout_r, xout_r, mac_z0;

    always_ff @(posedge clk) begin
        if(~rst_n) begin
            zout_r <= 'h0;
            xout_r <= 'h0;
        end
        else if(en) begin
            zout_r <= zin;
            xout_r <= mac_z0;
        end
    end

    assign xout = xout_r;
    assign zout = zout_r;

    DW_fp_mac_DG_inst 
    mac_U0(
        .inst_a({~zin[DWIDTH - 1], zin[DWIDTH - 2 : 0]}), 
        .inst_b(sqr_x), 
        .inst_c(xin), 
        .inst_rnd(3'h0), 
        .inst_DG_ctrl(en),
        .z_inst(mac_z0), 
        .status_inst()
    );
            
endmodule

module DW_fp_mac_DG_inst( inst_a, inst_b, inst_c, inst_rnd, inst_DG_ctrl, 
		z_inst, status_inst );

parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;


input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [sig_width+exp_width : 0] inst_c;
input [2 : 0] inst_rnd;
input inst_DG_ctrl;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;

    // Instance of DW_fp_mac_DG
    DW_fp_mac_DG #(sig_width, exp_width, ieee_compliance)
	  U1 ( .a(inst_a), .b(inst_b), .c(inst_c), .rnd(inst_rnd), .DG_ctrl(inst_DG_ctrl), .z(z_inst), .status(status_inst) );

endmodule

