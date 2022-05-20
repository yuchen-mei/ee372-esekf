// Upper TriMat Inversion
module TriMat_inv #(
    parameter DWIDTH = 32,
    parameter MATSIZE = 3
) (
    input logic clk, rst_n,
    input logic vld, en,
    // row order for upper triangular matrix or column order for lower triangular matrix
    input logic [DWIDTH - 1 : 0] mat_in[MATSIZE - 1 : 0][MATSIZE - 1 : 0],
    // input logic [DWIDTH - 1 : 0] mat_in[(MATSIZE * (MATSIZE + 1) / 2) - 1 : 0],
    output logic [DWIDTH - 1 : 0] mat_out[MATSIZE - 1 : 0][MATSIZE - 1 : 0]
    // output logic [DWIDTH - 1 : 0] mat_out[(MATSIZE * (MATSIZE + 1) / 2) - 1 : 0]
    );
    
    logic [DWIDTH - 1 : 0] zcircle_out[MATSIZE - 1 : 0];
    logic [DWIDTH - 1 : 0] zsquare_out[MATSIZE * (MATSIZE - 1) / 2 - 1 : 0];
    logic [DWIDTH - 1 : 0] xsquare_out[MATSIZE * (MATSIZE - 1) / 2 - 1 : 0];
    logic [DWIDTH - 1 : 0] vec_in_r[MATSIZE - 1 : 0];

    for(genvar i = 1; i < MATSIZE; i = i + 1) begin
        for(genvar j = 0; j < i; j = j + 1) begin
            assign mat_out[i][j] = 32'h0;
        end
    end

    logic [3 : 0] state_r;
    logic [3 : 0] glb_cnt;
    
    always_ff @(posedge clk) begin
        if(~rst_n || ~vld) glb_cnt <= 'h0;
        else if (en) glb_cnt <= glb_cnt + 1'b1;
    end

    always_ff @(posedge clk) begin
        case(glb_cnt)
            4'h4: begin
                mat_out[0][0] <= zsquare_out[1];
            end
            4'h5: begin
                mat_out[0][1] <= zsquare_out[2];
            end
            4'h6: begin
                mat_out[0][2] <= zcircle_out[2];
                mat_out[1][1] <= zsquare_out[2];
            end
            4'h7: begin
                mat_out[1][2] <= zcircle_out[2];
            end
            4'h8: begin
                mat_out[2][2] <= zcircle_out[2];
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if(~rst_n || ~vld) begin
            state_r <= 'h0;
            vec_in_r[0] <= 'h0;
            vec_in_r[1] <= 'h0;
            vec_in_r[2] <= 'h0;
        end
        else if (en) begin
            case(state_r)
                4'h0: begin
                    vec_in_r[0] <= 32'h3F800000;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h1;
                end
                4'h1: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h2;
                end
                4'h2: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h3F800000;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h3;
                end
                4'h3: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h4;
                end
                4'h4: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h3F800000;
                    state_r <= 4'h5;
                end
                4'h5: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h5;
                end
                default: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h0;
                end
            endcase
        end
    end

    //    first row of PEs
    circle_PE_Tri #(
        .DWIDTH(DWIDTH)
    )
    circle_PE_Tri_U11 (
        .clk(clk), 
        .rst_n(rst_n),
        .en(en),
        .xin(vec_in_r[0]),
        .cir_x(mat_in[0][0]),
        .zout(zcircle_out[0])
    );
    
    square_PE_Tri #(
        .DWIDTH(DWIDTH)
    )
    square_PE_Tri_U12 (
        .clk(clk), 
        .rst_n(rst_n),
        .en(en),
        .xin(vec_in_r[1]), 
        .sqr_x(mat_in[0][1]), 
        .zin(zcircle_out[0]),
        .xout(xsquare_out[0]),
        .zout(zsquare_out[0])
    );

    square_PE_Tri #(
        .DWIDTH(DWIDTH)
    )
    square_PE_Tri_U13 (
        .clk(clk), 
        .rst_n(rst_n),
        .en(en),
        .xin(vec_in_r[2]), 
        .sqr_x(mat_in[0][2]), 
        .zin(zsquare_out[0]),
        .xout(xsquare_out[1]),
        .zout(zsquare_out[1])
    );
    //    second row of PEs
    circle_PE_Tri #(
        .DWIDTH(DWIDTH)
    )
    circle_PE_Tri_U22 (
        .clk(clk), 
        .rst_n(rst_n),
        .en(en),
        .xin(xsquare_out[0]),
        .cir_x(mat_in[1][1]),
        .zout(zcircle_out[1])
    );

    square_PE_Tri #(
        .DWIDTH(DWIDTH)
    )
    square_PE_Tri_U23 (
        .clk(clk), 
        .rst_n(rst_n),
        .en(en),
        .xin(xsquare_out[1]), 
        .sqr_x(mat_in[1][2]), 
        .zin(zcircle_out[1]),
        .xout(xsquare_out[2]),
        .zout(zsquare_out[2])
    );
    
    //    third row of PEs
    
    circle_PE_Tri #(
        .DWIDTH(DWIDTH)
    )
    circle_PE_Tri_U33 (
        .clk(clk), 
        .rst_n(rst_n),
        .en(en),
        .xin(xsquare_out[2]),
        .cir_x(mat_in[2][2]),
        .zout(zcircle_out[2])
    );
    
endmodule

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

    DW_fp_div_DG_inst 
    div_U0( 
        .inst_a(xin), 
        .inst_b(cir_x), 
        .inst_rnd(3'h0), 
        .inst_DG_ctrl(en),
        .z_inst(div_z0), 
        .status_inst() 
    );
            
endmodule

module DW_fp_div_DG_inst( inst_a, inst_b, inst_rnd, inst_DG_ctrl, z_inst,
		status_inst );

parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
parameter faithful_round = 0;
parameter en_ubr_flag = 0;


input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
input inst_DG_ctrl;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;

    // Instance of DW_fp_div_DG
    DW_fp_div_DG #(sig_width, exp_width, ieee_compliance, faithful_round, en_ubr_flag)
	  U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .DG_ctrl(inst_DG_ctrl), .z(z_inst), .status(status_inst) );

endmodule

module DW_fp_div_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );

    parameter inst_sig_width = 23; 
    parameter inst_exp_width = 8; 
    parameter inst_ieee_compliance = 0; 
    parameter inst_faithful_round = 0;

    input [inst_sig_width+inst_exp_width : 0] inst_a; 
    input [inst_sig_width+inst_exp_width : 0] inst_b; 
    input [2 : 0] inst_rnd; 
    output [inst_sig_width+inst_exp_width : 0] z_inst; 
    output [7 : 0] status_inst;

    DW_fp_div #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_faithful_round) U1 (

    .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );

endmodule





