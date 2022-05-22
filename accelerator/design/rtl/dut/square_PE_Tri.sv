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

    DW_fp_mac_DG mac_U0(
        .a({~zin[DWIDTH - 1], zin[DWIDTH - 2 : 0]}), 
        .b(sqr_x), 
        .c(xin), 
        .rnd(3'h0), 
        .DG_ctrl(en),
        .z(mac_z0), 
        .status()
    );
            
endmodule
