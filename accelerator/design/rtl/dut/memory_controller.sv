module memory_controller #(
    parameter ADDR_WIDTH           = 12,
    parameter DATA_WIDTH           = 32,
    parameter VECTOR_LANES         = 16,
    parameter DATAPATH             = 8,
    parameter INSTR_MEM_ADDR_WIDTH = 8,
    parameter DATA_MEM_ADDR_WIDTH  = 12
) (
    input  logic                               clk,
    // Physical memory address
    input  logic                               mem_we,
    input  logic                               mem_ren,
    input  logic [             ADDR_WIDTH-1:0] mem_addr,
    input  logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_wdata,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_rdata,
    input  logic [                        2:0] width,
    // Instruction Memory
    output logic [   INSTR_MEM_ADDR_WIDTH-1:0] instr_mem_addr,
    output logic                               instr_mem_csb,
    output logic                               instr_mem_web,
    output logic [                       31:0] instr_mem_wdata,
    input  logic [                       31:0] instr_mem_rdata,
    // Data Memory
    output logic [    DATA_MEM_ADDR_WIDTH-1:0] data_mem_addr,
    output logic                               data_mem_csb,
    output logic                               data_mem_web,
    output logic [            DATAPATH/32-1:0] data_mem_wmask,
    output logic [               DATAPATH-1:0] data_mem_wdata,
    input  logic [               DATAPATH-1:0] data_mem_rdata,
    // Matrix inversion
    input  logic [           9*DATA_WIDTH-1:0] mat_inv_out_l,
    input  logic [           9*DATA_WIDTH-1:0] mat_inv_out_u
);

    localparam MASK_BITS = DATAPATH/32;

    localparam DATA_MASK     = 12'h800;
    localparam DATA_ADDR     = 12'h000;
    localparam TEXT_MASK     = 12'he00;
    localparam TEXT_ADDR     = 12'h800; //800 - 9ff
    localparam IO_ADDR       = 12'ha00;
    localparam INVMAT_ADDR   = 12'ha02;
    localparam INVMAT_L_ADDR = 12'ha03;
    localparam INVMAT_U_ADDR = 12'ha04;

    logic [ADDR_WIDTH-1:0] mem_addr_r;

    always @(posedge clk) begin
        mem_addr_r <= mem_addr;
    end

    assign instr_mem_addr  = mem_addr[INSTR_MEM_ADDR_WIDTH-1:0];
    assign instr_mem_wdata = mem_wdata;

    assign data_mem_addr  = mem_addr[3+:DATA_MEM_ADDR_WIDTH];
    // assign data_mem_wdata = mem_wdata;
    // assign data_mem_wmask = '1;

    always_comb begin
        instr_mem_csb = 1'b0;
        instr_mem_web = 1'b0;
        data_mem_csb  = 1'b0;
        data_mem_web  = 1'b0;

        case (width)
            3'b010:  data_mem_wmask = {1{1'b1}}; // 32
            3'b011:  data_mem_wmask = {2{1'b1}}; // 64
            3'b100:  data_mem_wmask = {4{1'b1}}; // 128
            default: data_mem_wmask = {8{1'b1}}; // 256
        endcase

        data_mem_wmask <<= mem_addr[2:0];

        unique case (mem_addr[2:0])
            3'b000:  data_mem_wdata = mem_wdata;
            3'b001:  data_mem_wdata = mem_wdata << 32;
            3'b010:  data_mem_wdata = mem_wdata << 64;
            3'b011:  data_mem_wdata = mem_wdata << 96;
            3'b100:  data_mem_wdata = mem_wdata << 128;
            3'b101:  data_mem_wdata = mem_wdata << 160;
            3'b110:  data_mem_wdata = mem_wdata << 192;
            3'b111:  data_mem_wdata = mem_wdata << 224;
            default: data_mem_wdata = '0;
        endcase

        if ((mem_addr & DATA_MASK) == DATA_ADDR) begin
            data_mem_csb = mem_ren || mem_we;
            data_mem_web = mem_we;
        end
        else if ((mem_addr & TEXT_MASK) == TEXT_ADDR) begin
            instr_mem_csb = mem_ren || mem_we;
            instr_mem_web = mem_we;
        end

        if ((mem_addr_r & DATA_MASK) == DATA_ADDR) begin
            mem_rdata = data_mem_rdata;
        end
        else if ((mem_addr_r & TEXT_MASK) == TEXT_ADDR) begin
            mem_rdata = instr_mem_rdata;
        end
        else if (mem_addr_r == INVMAT_L_ADDR) begin
            mem_rdata = mat_inv_out_l;
        end
        else if (mem_addr_r == INVMAT_U_ADDR) begin
            mem_rdata = mat_inv_out_u;
        end
    end

endmodule
