module mat_inv #(
    parameter DATA_WIDTH = 32,
    parameter MATSIZE = 3,
    parameter VECTOR_LANES = MATSIZE * MATSIZE
) (
    input  logic                                    clk,
    input  logic                                    rst_n,
    input  logic                                    en,
    input  logic                                    vld,
    input  logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mat_in,
    output logic                                    rdy,
    output logic                                    vld_out,
    output logic [VECTOR_LANES-1:0][DATA_WIDTH-1:0] mat_inv_out
);

    // valid detection

    logic data_vld;
    logic vld_out_r1;
    logic [7 : 0] vld_cnt;
    logic [DATA_WIDTH - 1 : 0] mat_in_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] mat_row_major [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    
    for (genvar i = 0; i < 3; i = i + 1) begin
        for (genvar j = 0; j < 3; j = j + 1) begin
            assign mat_row_major[i][j] = mat_in[3*j+i];
        end
    end

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            data_vld <= 'h0;
            vld_out_r1 <= 'h0;
            mat_in_r <= '{default:'0};
        end
        else if (en) begin
            if (vld) begin
                data_vld <= 'h1;
                vld_out_r1 <= 'h0;
                mat_in_r <= mat_row_major;
            end
            else begin
                if (vld_cnt != 'h16) data_vld <= data_vld;
                else begin
                    data_vld <= 1'b0;
                    vld_out_r1 <= 1'b1;
                end
                mat_in_r <= mat_in_r;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(~rst_n) begin
            vld_cnt <= 'h0;
        end
        else if (en) begin
            if (data_vld && vld_cnt != 'h17) begin
                vld_cnt <= vld_cnt + 1'b1;
            end
            else begin
                vld_cnt <= 'h0;
            end
        end
    end

    assign vld_out = vld_out_r1;

    // LU Decomposition

    logic [3 : 0] LU_cnt;
    logic [DATA_WIDTH - 1 : 0] l_mat [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] u_mat [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] l_mat_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] u_mat_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
 
    always_ff @(posedge clk) begin
        if (~rst_n || ~data_vld) begin
            LU_cnt <= 4'b0;
            l_mat_r <= '{default:'0};
            u_mat_r <= '{default:'0};
        end
        else if (en) begin
            if(LU_cnt != 'ha) begin
                LU_cnt <= LU_cnt + 1'b1;
            end
        end
        if (LU_cnt == 'h9) begin
            l_mat_r <= l_mat;
            u_mat_r <= u_mat;
        end
    end

    LU_systolic #(
        .DWIDTH(DATA_WIDTH),
        .MATSIZE(MATSIZE)
    ) 
    LU_systolic_U0 (
        .clk(clk),
        .rst_n(rst_n),
        .vld(data_vld),
        .en(en),
        .mat_in(mat_in_r),
        .l_out(l_mat),
        .u_out(u_mat)
    );

    // L U Triangular Matrix Inversion

    logic [DATA_WIDTH - 1 : 0] l_mat_in_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] u_mat_in_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic Tri_vld;

    always_ff @(posedge clk) begin
        if (~rst_n || ~data_vld) begin
            l_mat_in_r <= '{default:'0};
            u_mat_in_r <= '{default:'0};
            Tri_vld <= 1'b0;
        end
        else if (en) begin
            if (LU_cnt == 'ha) begin
                l_mat_in_r <= l_mat_r;
                u_mat_in_r <= u_mat_r;
                Tri_vld <= 1'b1;
            end
        end
    end

    logic [DATA_WIDTH - 1 : 0] l_mat_in_r_t [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] l_mat_inv [MATSIZE - 1 : 0][MATSIZE - 1 : 0];

    logic [DATA_WIDTH - 1 : 0] l_mat_t_inv [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] u_mat_inv [MATSIZE - 1 : 0][MATSIZE - 1 : 0];

    logic [DATA_WIDTH - 1 : 0] l_mat_inv_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] u_mat_inv_r [MATSIZE - 1 : 0][MATSIZE - 1 : 0];

    logic [7 : 0] triinv_cnt;

    logic rdy_r1;
    
    for(genvar i = 0; i < MATSIZE; i = i + 1) begin
        for(genvar j = 0; j < MATSIZE; j = j + 1) begin
            assign l_mat_in_r_t[i][j] = l_mat_in_r[j][i];
            assign l_mat_inv[i][j] = l_mat_t_inv[j][i];
        end
    end

    always_ff @(posedge clk) begin
        if (~rst_n || ~data_vld) begin
            triinv_cnt <= 4'b0;
            l_mat_inv_r <= '{default:'0};
            u_mat_inv_r <= '{default:'0};
            if (~rst_n) begin
                rdy_r1 <= 1'b0;
            end
            if (~data_vld) rdy_r1 <= 1'b1;
        end
        else if (en) begin
            if (triinv_cnt != 'h19) begin 
                triinv_cnt <= triinv_cnt + 1'b1;
            end
            if (triinv_cnt == 'h14) begin
                l_mat_inv_r <= l_mat_inv;
                u_mat_inv_r <= u_mat_inv;
                // rdy_r1 <= 1'b1;
            end
            if (triinv_cnt == 'h16) begin
                rdy_r1 <= 1'b1;
            end
            if (data_vld) begin
                rdy_r1 <= 1'b0;
            end
        end
    end

    assign rdy = rdy_r1;

    TriMat_inv #(
        .DWIDTH(DATA_WIDTH),
        .MATSIZE(MATSIZE)
    ) 
    TriMat_inv_U (
        .clk(clk),
        .rst_n(rst_n),
        .vld(Tri_vld),
        .en(en),
        .mat_in(u_mat_in_r),
        .mat_out(u_mat_inv)
    ),
    TriMat_inv_LT (
        .clk(clk),
        .rst_n(rst_n),
        .vld(Tri_vld),
        .en(en),
        .mat_in(l_mat_in_r_t),
        .mat_out(l_mat_t_inv)
    );

    // Uinv mult Linv

    logic [DATA_WIDTH - 1 : 0] mat_inv_out_w[MATSIZE - 1 : 0][MATSIZE - 1 : 0];
    logic [DATA_WIDTH - 1 : 0] mat_inv_out_r[MATSIZE - 1 : 0][MATSIZE - 1 : 0];

    always@(posedge clk) begin
        if(~rst_n) begin
            mat_inv_out_r <= '{default:'0};
        end
        else if (en) begin
            if (~rdy_r1 && data_vld)
                mat_inv_out_r <= mat_inv_out_w;
            else
                mat_inv_out_r <= mat_inv_out_r;
        end
    end

    for (genvar i = 0; i < 3; i = i + 1) begin
        for (genvar j = 0; j < 3; j = j + 1) begin
            assign mat_inv_out[3*j+i] = mat_inv_out_r[i][j];
        end
    end

    matmul_3x3 #(
        .ARRAY_HEIGHT(MATSIZE),
        .ARRAY_WIDTH(MATSIZE)
    ) matmul_3x3_U(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .matrix_a(u_mat_inv_r),
        .matrix_b(l_mat_inv_r),
        .matrix_out(mat_inv_out_w)
    );

endmodule

