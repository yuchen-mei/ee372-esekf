module register_file #(
  parameter LEN = 16,
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 5,
  parameter DEPTH = 32
) (
  input clk,
  input rst_n,
  input en,
  input [ADDR_WIDTH - 1 : 0] addr_w,
  input [DATA_WIDTH - 1 : 0] data_w[LEN - 1 : 0],
  input [ADDR_WIDTH - 1 : 0] addr_r1,
  output [DATA_WIDTH - 1 : 0] data_r1[LEN - 1 : 0],
  input [ADDR_WIDTH - 1 : 0] addr_r2,
  output [DATA_WIDTH - 1 : 0] data_r2[LEN - 1 : 0],
  input [ADDR_WIDTH - 1 : 0] addr_r3,
  output [DATA_WIDTH - 1 : 0] data_r3[LEN - 1 : 0]
);

  logic [DATA_WIDTH - 1 : 0] vec_r [DEPTH - 1 : 0][LEN - 1 : 0];

  assign data_r1 = (en & (addr_w == addr_r1)) ? data_w : vec_r[addr_r1];
  assign data_r2 = (en & (addr_w == addr_r2)) ? data_w : vec_r[addr_r2];
  assign data_r3 = (en & (addr_w == addr_r3)) ? data_w : vec_r[addr_r3];

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      vec_r[0] <= '{default:'0};
      vec_r[1][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000}; // p_est
      vec_r[2][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3b6d8000, 32'h38a36038, 32'hb8cbffed}; // v_est
      vec_r[3][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h350eca6a, 32'hb80e4003, 32'hb7ac04fe, 32'h3f800000}; // q_est

      vec_r[4][8:0] <= '{32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // p_cov_11
      vec_r[5][8:0] <= '{default: 32'b0}; // p_cov_12
      vec_r[6][8:0] <= '{default: 32'b0}; // p_cov_13
      vec_r[7][8:0] <= '{default: 32'b0}; // p_cov_21
      vec_r[8][8:0] <= '{32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // p_cov_22
      vec_r[9][8:0] <= '{default: 32'b0}; // p_cov_23
      vec_r[10][8:0] <= '{default: 32'b0}; // p_cov_31
      vec_r[11][8:0] <= '{default: 32'b0}; // p_cov_32
      vec_r[12][8:0] <= '{32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // p_cov_33

      vec_r[13][8:0] <= '{32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3f800000}; // identity matrix
      vec_r[14][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'hc11cf5c3, 32'h00000000, 32'h00000000}; // gravity
      // Constants: t, t^2, 0.5t^2, vif*t^2, viw*t^2
      vec_r[15][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h348637bd, 32'h348637bd, 32'h3751b717, 32'h37d1b717, 32'h3ba3d70a}; // constant

      vec_r[16][8:0] <= '{32'h3f800000, 32'h382c04f4, 32'hb88e4006, 32'hb82c0508, 32'h3f800000, 32'hb58e9a9f, 32'h388e4000, 32'h358efa35, 32'h3f800000}; // rotation matrix
      vec_r[17][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'hc11d21cc, 32'hbb151d87, 32'h3bbc24c0}; // imu_f
      vec_r[18][8:0] <= '{32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 32'h3809634f, 32'h382233c6, 32'hba1011be, 32'h3f7ffffd}; // imu_w in quaternion      

      vec_r[31 : 19] <= '{default:'0};
    end
    else if (en) begin
      vec_r[addr_w] <= data_w;
    end
  end

endmodule
