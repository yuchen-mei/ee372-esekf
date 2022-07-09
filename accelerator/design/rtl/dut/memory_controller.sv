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
    input  logic                               mem_re,
    input  logic              [ADDR_WIDTH-1:0] mem_addr,
    input  logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_wdata,
    output logic [VECTOR_LANES*DATA_WIDTH-1:0] mem_rdata,
    input  logic                         [2:0] width,
    // Instruction Memory
    output logic    [INSTR_MEM_ADDR_WIDTH-1:0] instr_mem_addr,
    output logic                               instr_mem_csb,
    output logic                               instr_mem_web,
    output logic                        [31:0] instr_mem_wdata,
    input  logic                        [31:0] instr_mem_rdata,
    // Data Memory
    output logic     [DATA_MEM_ADDR_WIDTH-1:0] data_mem_addr,
    output logic                               data_mem_csb,
    output logic                               data_mem_web,
    output logic             [DATAPATH/32-1:0] data_mem_wmask,
    output logic                [DATAPATH-1:0] data_mem_wdata,
    input  logic                [DATAPATH-1:0] data_mem_rdata,
    // Matrix inversion
    input  logic            [9*DATA_WIDTH-1:0] mat_inv_out_l,
    input  logic            [9*DATA_WIDTH-1:0] mat_inv_out_u
);

    localparam DATA_MASK     = 12'h800;
    localparam DATA_ADDR     = 12'h000;
    localparam TEXT_MASK     = 12'he00;
    localparam TEXT_ADDR     = 12'h800; //800 - 9ff
    localparam IO_ADDR       = 12'ha00;
    localparam INVMAT_ADDR   = 12'ha02;
    localparam INVMAT_L_ADDR = 12'ha03;
    localparam INVMAT_U_ADDR = 12'ha04;

    logic [ADDR_WIDTH-1:0] mem_addr_r;
    logic [ADDR_WIDTH-1:0] mem_write_mask;
    logic [ADDR_WIDTH-1:0] mem_read_data;

    always @(posedge clk) mem_addr_r <= mem_addr;

    assign instr_mem_addr  = mem_addr[INSTR_MEM_ADDR_WIDTH-1:0];
    assign instr_mem_wdata = mem_wdata;

    assign data_mem_addr   = mem_addr[3+:DATA_MEM_ADDR_WIDTH];
    assign data_mem_wmask  = mem_write_mask << mem_addr[2:0];
    assign data_mem_wdata  = mem_wdata;

    always_comb begin
        instr_mem_csb = 1'b0;
        instr_mem_web = 1'b0;
        data_mem_csb  = 1'b0;
        data_mem_web  = 1'b0;

        if ((mem_addr & DATA_MASK) == DATA_ADDR) begin
            data_mem_csb = mem_re || mem_we;
            data_mem_web = mem_we;
        end
        else if ((mem_addr & TEXT_MASK) == TEXT_ADDR) begin
            instr_mem_csb = mem_re || mem_we;
            instr_mem_web = mem_we;
        end
    end

    always_comb begin
        case (width)
            3'b010:  mem_write_mask = {1{1'b1}}; // 32
            3'b011:  mem_write_mask = {2{1'b1}}; // 64
            3'b100:  mem_write_mask = {4{1'b1}}; // 128
            default: mem_write_mask = {8{1'b1}}; // 256
        endcase
    end

    always_comb begin
        if ((mem_addr_r & DATA_MASK) == DATA_ADDR)
            mem_rdata = data_mem_rdata;
        else if ((mem_addr_r & TEXT_MASK) == TEXT_ADDR)
            mem_rdata = instr_mem_rdata;
        else if (mem_addr_r == INVMAT_L_ADDR)
            mem_rdata = mat_inv_out_l;
        else if (mem_addr_r == INVMAT_U_ADDR)
            mem_rdata = mat_inv_out_u;
        else
            mem_rdata = 'X;
    end

endmodule
