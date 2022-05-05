module dff
#(
  parameter WIDTH = 64, // Signal bit widths
  parameter PIPE_DEPTH = 1, // Pipeline depth
  parameter OUT_REG = 0 // Pipeline Is Retimeable
)
(
  input logic [WIDTH - 1:0] in,
  input logic clk,
  input logic rst_n,
  input logic en,
  output logic [WIDTH - 1:0] out
);

  if (PIPE_DEPTH == 0) begin
    assign out = in & {WIDTH{rst_n}};
  end
  else if (OUT_REG) begin
    DW_pl_reg
    #(
      .width      (WIDTH          ),
      .in_reg     (0              ),
      .stages     (PIPE_DEPTH     ),
      .out_reg    (1              ),
      .rst_mode   (0              )
    )
    dff_pipe
    (
      .clk        (clk             ),
      .rst_n      (rst_n           ),
      .data_in    (in              ),
      .data_out   (out             ),
      .enable     ({PIPE_DEPTH{en}})
    );
  end
  else begin
    DW_pl_reg
    #(
      .width      (WIDTH          ),
      .in_reg     (0              ),
      .stages     (PIPE_DEPTH + 1 ),
      .out_reg    (0              ),
      .rst_mode   (0              )
    )
    dff_pipe
    (
      .clk        (clk             ),
      .rst_n      (rst_n           ),
      .data_in    (in              ),
      .data_out   (out             ),
      .enable     ({PIPE_DEPTH{en}})
    );
  end

endmodule
