module circle_PE_Tri #(
    parameter DWIDTH = 32
) (
    input logic clk, rst_n, en,
    input logic [DWIDTH - 1 : 0] xin,
    input logic [DWIDTH - 1 : 0] cir_x,
    output logic [DWIDTH - 1 : 0] zout
);
    
    logic [DWIDTH - 1 : 0] zout_r, div_z0;
    always_ff @(posedge clk) begin
        if(~rst_n) zout_r <= 'h0;
        else if (en) zout_r <= div_z0;
    end

    assign zout = zout_r;

    DW_fp_div_DG div_U0( 
        .a(xin), 
        .b(cir_x), 
        .rnd(3'h0), 
        .DG_ctrl(en),
        .z(div_z0), 
        .status() 
    );
            
endmodule
