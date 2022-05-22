module circle_PE_LU #(
    parameter DWIDTH = 32
) (
    input logic clk, rst_n, vld, en, 
    input logic [DWIDTH - 1 : 0] ain,
    output logic [DWIDTH - 1 : 0] uout
    );
    
    logic [DWIDTH - 1 : 0] ain_r;
    always_ff @(posedge clk) begin
        if(~rst_n || ~vld) ain_r <= 'h0;
        else if (en) ain_r <= ain;
    end

    assign uout = ain_r;
            
endmodule
