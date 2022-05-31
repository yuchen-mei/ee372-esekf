module memory_controller #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32,
    parameter VECTOR_LANES = 16,
    parameter INSTR_MEM_ADDR_WIDTH = 8,
    parameter DATA_MEM_ADDR_WIDTH = 12
) (
    input  logic                                            clk,
    input  logic                                            rst_n,
    // Physical memory address
    input  logic [          ADDR_WIDTH-1:0]                 mem_addr,
    input  logic                                            mem_we,
    input  logic                                            mem_ren,
    input  logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_wdata,
    output logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] mem_rdata,
    input  logic [                     2:0]                 width,
    // Instruction Memory
    output logic [INSTR_MEM_ADDR_WIDTH-1:0]                 instr_mem_addr,
    output logic                                            instr_mem_csb,
    output logic                                            instr_mem_web,
    output logic [                    31:0]                 instr_mem_wdata,
    input  logic [                    31:0]                 instr_mem_rdata,
    // Data Memory
    output logic [ DATA_MEM_ADDR_WIDTH-1:0]                 data_mem_addr,
    output logic                                            data_mem_csb,
    output logic                                            data_mem_web,
    output logic [        VECTOR_LANES-1:0]                 data_mem_wmask,
    output logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] data_mem_wdata,
    input  logic [        VECTOR_LANES-1:0][DATA_WIDTH-1:0] data_mem_rdata,
    // Matrix inversion
    input  logic [                     8:0][DATA_WIDTH-1:0] mat_inv_in_l,
    input  logic [                     8:0][DATA_WIDTH-1:0] mat_inv_in_u
);

    localparam ADDR_MASK = 16'hF000;
    localparam DATA_ADDR = 16'h0000;
    localparam TEXT_ADDR = 16'h1000;
    localparam MAT_INV_ADDR_L = 16'h1200;
    localparam MAT_INV_ADDR_U = 16'h1201;

    logic [ADDR_WIDTH-1:0] mem_addr_r;

    always @(posedge clk) begin
        mem_addr_r <= mem_addr;
    end

    assign instr_mem_addr  = mem_addr[INSTR_MEM_ADDR_WIDTH-1:0];
    assign instr_mem_wdata = mem_wdata;

    assign data_mem_addr  = mem_addr[4+:DATA_MEM_ADDR_WIDTH];
    assign data_mem_wdata = mem_wdata;

    always_comb begin
        instr_mem_csb = 1'b0;
        instr_mem_web = 1'b0;
        data_mem_web  = 1'b0;
        data_mem_web  = 1'b0;
        data_mem_wmask = 'b1;

        if ((mem_addr & ADDR_MASK) == TEXT_ADDR) begin
            instr_mem_csb = mem_ren || mem_we;
            instr_mem_web = mem_we;
        end
        else if ((mem_addr & ADDR_MASK) == DATA_ADDR) begin
            data_mem_csb = mem_ren || mem_we;
            data_mem_web = mem_we;
        end

        if ((mem_addr_r & ADDR_MASK) == TEXT_ADDR) begin
            mem_rdata = instr_mem_rdata;
        end
        else if ((mem_addr_r & ADDR_MASK) == DATA_ADDR) begin
            case (width)
                3'b001:  mem_rdata = data_mem_rdata[mem_addr_r[3:0]];    // 32-bit
                3'b010:  mem_rdata = data_mem_rdata[mem_addr_r[3:0]+:2]; // 64-bit
                3'b011:  mem_rdata = data_mem_rdata[mem_addr_r[3:0]+:4]; // 128-bit
                3'b100:  mem_rdata = data_mem_rdata[mem_addr_r[3:0]+:8]; // 256-bit
                default: mem_rdata = data_mem_rdata;
            endcase
        end
        else if (mem_addr_r == MAT_INV_ADDR_L) begin
            mem_rdata = mat_inv_in_l;
        end
        else if (mem_addr_r == MAT_INV_ADDR_U) begin
            mem_rdata = mat_inv_in_u;
        end
    end
    
endmodule
