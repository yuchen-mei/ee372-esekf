module LU_systolic #(
    parameter DWIDTH = 32,
    parameter MATSIZE = 3
) (
    input logic clk, rst_n, vld, en,
    // input logic [DWIDTH - 1 : 0] vec_in[MATSIZE - 1 : 0],
    input logic [DWIDTH - 1 : 0] mat_in[MATSIZE - 1 : 0][MATSIZE - 1 : 0],
    output logic [DWIDTH - 1 : 0] l_out[MATSIZE - 1 : 0][MATSIZE - 1 : 0],
    output logic [DWIDTH - 1 : 0] u_out[MATSIZE - 1 : 0][MATSIZE - 1 : 0]
    );
    
    logic [DWIDTH - 1 : 0] vec_in_r [MATSIZE - 1 : 0];
    logic [DWIDTH - 1 : 0] ucircle_out[MATSIZE - 1 : 0];
    logic [DWIDTH - 1 : 0] asquare_out[MATSIZE * (MATSIZE - 1) / 2 - 1 : 0];
    logic [DWIDTH - 1 : 0] usquare_out[MATSIZE * (MATSIZE - 1) / 2 - 1 : 0];
    logic [3 : 0] glb_cnt;
    logic [2 : 0] state_r;

    genvar i, j;
    for(i = 0; i < MATSIZE; i = i + 1) begin
        assign l_out[i][i] = 32'h3F800000;
    end
    for(i = 0; i < MATSIZE - 1; i = i + 1) begin
        for(j = i + 1; j < MATSIZE; j = j + 1) begin
            assign l_out[i][j] = 32'h0;
        end
    end
    for(i = 1; i < MATSIZE; i = i + 1) begin
        for(j = 0; j < i; j = j + 1) begin
            assign u_out[i][j] = 32'h0;
        end
    end

    always_ff @(posedge clk) begin
        if(~rst_n || ~vld) glb_cnt <= 'h0;
        else if (en) glb_cnt <= glb_cnt + 1'b1;
    end

    always_ff @(posedge clk) begin
        case(glb_cnt)
            4'h4: begin
                u_out[0][0] <= usquare_out[1];
            end
            4'h5: begin
                u_out[0][1] <= usquare_out[1];
            end
            4'h6: begin
                u_out[0][2] <= usquare_out[1];
                u_out[1][1] <= usquare_out[2];
            end
            4'h7: begin
                u_out[1][2] <= usquare_out[2];
            end
            4'h8: begin
                u_out[2][2] <= ucircle_out[2];
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
                    vec_in_r[0] <= mat_in[0][0];
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h1;
                end
                4'h1: begin
                    vec_in_r[0] <= mat_in[0][1];
                    vec_in_r[1] <= mat_in[1][0];
                    vec_in_r[2] <= 32'h0;
                    state_r <= 4'h2;
                end
                4'h2: begin
                    vec_in_r[0] <= mat_in[0][2];
                    vec_in_r[1] <= mat_in[1][1];
                    vec_in_r[2] <= mat_in[2][0];
                    state_r <= 4'h3;
                end
                4'h3: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= mat_in[1][2];
                    vec_in_r[2] <= mat_in[2][1];
                    state_r <= 4'h4;
                end
                4'h4: begin
                    vec_in_r[0] <= 32'h0;
                    vec_in_r[1] <= 32'h0;
                    vec_in_r[2] <= mat_in[2][2];
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
    circle_PE_LU #(
        .DWIDTH(DWIDTH)
    )
    circle_PE_LU_U11 (
        .clk(clk), 
        .rst_n(rst_n),
        .vld(vld),
        .en(en),
        .ain(vec_in_r[0]),
        .uout(ucircle_out[0])
    );
    
    //    second row of PEs
    square_PE_LU #(
        .DWIDTH(DWIDTH)
    )
    square_PE_LU_U21 (
        .clk(clk), 
        .rst_n(rst_n),
        .vld(vld),
        .en(en),
        .i(3'h2),
        .j(3'h1),
        .ain(vec_in_r[1]),
        .uin(ucircle_out[0]),
        .aout(asquare_out[0]),
        .uout(usquare_out[0]),
        .l(l_out[1][0])
    );

    circle_PE_LU #(
        .DWIDTH(DWIDTH)
    )
    circle_PE_LU_U22 (
        .clk(clk), 
        .rst_n(rst_n),
        .vld(vld),
        .en(en),
        .ain(asquare_out[0]),
        .uout(ucircle_out[1])
    );
    
    //    third row of PEs
    square_PE_LU #(
        .DWIDTH(DWIDTH)
    )
    square_PE_LU_U31 (
        .clk(clk), 
        .rst_n(rst_n),
        .vld(vld),
        .en(en),
        .i(3'h3),
        .j(3'h1),
        .ain(vec_in_r[2]),
        .uin(usquare_out[0]),
        .aout(asquare_out[1]),
        .uout(usquare_out[1]),
        .l(l_out[2][0])
    );

    square_PE_LU #(
        .DWIDTH(DWIDTH)
    )
    square_PE_LU_U32 (
        .clk(clk), 
        .rst_n(rst_n),
        .vld(vld),
        .en(en),
        .i(3'h3),
        .j(3'h2),
        .ain(asquare_out[1]),
        .uin(ucircle_out[1]),
        .aout(asquare_out[2]),
        .uout(usquare_out[2]),
        .l(l_out[2][1])
    );

    circle_PE_LU #(
        .DWIDTH(DWIDTH)
    )
    circle_PE_LU_U33 (
        .clk(clk), 
        .rst_n(rst_n),
        .vld(vld),
        .en(en),
        .ain(asquare_out[2]),
        .uout(ucircle_out[2])
    );
       
    
endmodule
