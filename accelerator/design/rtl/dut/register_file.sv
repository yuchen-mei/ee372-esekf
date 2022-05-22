module register_file #(
    parameter DATA_WIDTH = 512,
    parameter ADDR_WIDTH = 5,
    parameter DEPTH      = 32
) (
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic                  wen,
    input  logic [ADDR_WIDTH-1:0] addr_w,
    input  logic [DATA_WIDTH-1:0] data_w,

    input  logic [ADDR_WIDTH-1:0] addr_r1,
    output logic [DATA_WIDTH-1:0] data_r1,
    input  logic [ADDR_WIDTH-1:0] addr_r2,
    output logic [DATA_WIDTH-1:0] data_r2,
    input  logic [ADDR_WIDTH-1:0] addr_r3,
    output logic [DATA_WIDTH-1:0] data_r3
);

    reg [DATA_WIDTH-1:0] vectors [DEPTH-1:0];

    assign data_r1 = (wen & (addr_w == addr_r1)) ? data_w : vectors[addr_r1];
    assign data_r2 = (wen & (addr_w == addr_r2)) ? data_w : vectors[addr_r2];
    assign data_r3 = (wen & (addr_w == addr_r3)) ? data_w : vectors[addr_r3];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            vectors[0] <= '0;
            vectors[1] <= '0; // p_est
            vectors[2] <= {32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3b6d8000, 32'h38a36038, 32'hb8cbffed}; // v_est
            vectors[3] <= {32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h350eca6a, 32'hb80e4003, 32'hb7ac04fe, 32'h3f800000}; // q_est

            vectors[4] <= {32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // p_cov_11
            vectors[5] <= '0; // p_cov_12
            vectors[6] <= '0; // p_cov_13
            vectors[7] <= '0; // p_cov_21
            vectors[8] <= {32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // p_cov_22
            vectors[9] <= '0; // p_cov_23
            vectors[10] <= '0; // p_cov_31
            vectors[11] <= '0; // p_cov_32
            vectors[12] <= {32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // p_cov_33

            vectors[13] <= {32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // identity matrix
            vectors[14] <= {32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'hc11cf5c3, 32'h00000000, 32'h00000000}; // gravity
            vectors[15] <= '0;

            vectors[16] <= {32'h3f800000, 32'h382c04f4, 32'hb88e4006, 32'hb82c0508, 32'h3f800000, 32'hb58e9a9f, 32'h388e4000, 32'h358efa35, 32'h3f800000}; // rotation matrix
            vectors[17] <= {32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'hc11d21cc, 32'hbb151d87, 32'h3bbc24c0}; // imu_f
            vectors[18] <= {32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3809634f, 32'h382233c6, 32'hba1011be, 32'h3f7ffffd}; // imu_w in quaternion 

            vectors[19] <= 32'h3ba3d70a; // t
            vectors[20] <= 32'h37d1b717; // t^2
            vectors[21] <= 32'h3751b717; // 0.5t^2
            vectors[22] <= 32'h348637bd; // vif*t^2
            vectors[23] <= 32'h348637bd; // viw*t^2

            vectors[31:24] <= '{default:0};
        end
        else if (wen) begin
            vectors[addr_w] <= data_w;
        end
    end

endmodule
