module square_PE_LU #(
    parameter DWIDTH = 32
) (
    input logic clk, rst_n, vld, en,
    input logic [2 : 0] i, j,
    input logic [DWIDTH - 1 : 0] ain, uin,
    output logic [DWIDTH - 1 : 0] aout, uout,
    output logic [DWIDTH - 1 : 0] l
    );
    
    logic [DWIDTH - 1 : 0] l_r, u_r, a_r;
    logic [DWIDTH - 1 : 0] mac_z0, div_z0;
    logic [3 : 0] cnt;

    always_ff @(posedge clk) begin
        if(~rst_n || ~vld) cnt <= 'h0;
        else if (en) cnt <= cnt + 1'b1;
    end

    always_ff @(posedge clk) begin
        if(~rst_n || ~vld) begin
            a_r <= 'h0;
            u_r <= 'h0;
            l_r <= 'h0;
        end
        else if (en) begin
            u_r <= uin;
            if (cnt == i + 2*(j - 1)) begin
                l_r <= div_z0;
            end
            else begin
                a_r <= mac_z0;
            end
        end
    end

    assign aout = a_r;
    assign uout = u_r;
    assign l = l_r;

    DW_fp_mac_DG_inst 
    mac_U0(
        .inst_a({~l_r[DWIDTH - 1], l_r[DWIDTH - 2 : 0]}), 
        .inst_b(uin), 
        .inst_c(ain), 
        .inst_rnd(3'h0), 
        .inst_DG_ctrl(en),
        .z_inst(mac_z0), 
        .status_inst()
    );

    DW_fp_div_DG_inst 
    div_U0( 
        .inst_a(ain), 
        .inst_b(uin), 
        .inst_rnd(3'h0), 
        .inst_DG_ctrl(en),
        .z_inst(div_z0), 
        .status_inst() 
    );
            
endmodule

