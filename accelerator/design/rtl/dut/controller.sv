// States
`define STATE_WIDTH 2
`define IDLE 0
`define INITIAL_FILL 1
`define INNER_LOOP 2
`define RESET_INNER_LOOP 3

module controller #(
    parameter INPUT_FIFO_WIDTH     = 16,

    parameter ADDR_WIDTH           = 12,
    parameter INSTR_MEM_ADDR_WIDTH = 8,
    parameter DATA_MEM_ADDR_WIDTH  = 12,

    parameter NUM_CONFIGS          = 5,
    parameter CONFIG_DATA_WIDTH    = 16,
    parameter CONFIG_ADDR_WIDTH    = $clog2(NUM_CONFIGS)
) (
    input  logic                            clk,
    input  logic                            rst_n,
    
    input  logic                            wbs_debug,
    input  logic                            wbs_fsm_start,
    output logic                            wbs_fsm_done,

    input  logic     [INPUT_FIFO_WIDTH-1:0] params_fifo_dout,
    output logic                            params_fifo_deq,
    input  logic                            params_fifo_empty_n,

    input  logic                            instr_wen,
    input  logic                            input_wen,
    input  logic                            output_wb_ren,

    output logic                            instr_full_n,
    output logic                            input_full_n,
    output logic                            output_empty_n,

    output logic [INSTR_MEM_ADDR_WIDTH-1:0] instr_wadr,
    output logic  [DATA_MEM_ADDR_WIDTH-1:0] input_wadr,
    output logic  [DATA_MEM_ADDR_WIDTH-1:0] output_wb_radr,

    input  logic           [ADDR_WIDTH-1:0] mem_addr,
    input  logic                            mem_read,
    input  logic                            mem_write,

    output logic                            mat_inv_en,
    input  logic                            mat_inv_out_vld,
    output logic                            mvp_core_en
);

    localparam IO_ADDR     = 12'ha00;
    localparam INVMAT_ADDR = 12'ha02;

    //  typedef enum logic [1:0] {
    //     IDLE             = 2'd0,
    //     INITIAL_FILL     = 2'd1,
    //     INNER_LOOP       = 2'd2,
    //     RESET_INNER_LOOP = 2'd3,
    // } ctrl_state_t;

    // ---------------------------------------------------------------------------
    // Configuration registers
    // ---------------------------------------------------------------------------

    logic [CONFIG_DATA_WIDTH-1:0] config_r [NUM_CONFIGS-1:0];

    logic [ADDR_WIDTH-1:0] instr_max_wadr_c;
    logic [ADDR_WIDTH-1:0] input_max_wadr_c;
    logic [ADDR_WIDTH-1:0] input_wadr_offset;
    logic [ADDR_WIDTH-1:0] output_max_adr_c;
    logic [ADDR_WIDTH-1:0] output_radr_offset;

    // ---------------------------------------------------------------------------
    // Registers for keeping track of the state of the accelerator
    // ---------------------------------------------------------------------------

    reg [     `STATE_WIDTH-1:0] state_r;
    reg [CONFIG_ADDR_WIDTH-1:0] config_adr_r;
    reg [       ADDR_WIDTH-1:0] instr_wadr_r;
    reg [       ADDR_WIDTH-1:0] input_wadr_r;
    reg [       ADDR_WIDTH-1:0] output_wbadr_r;

    assign instr_wadr     = instr_wadr_r;
    assign input_wadr     = input_wadr_r[3+:DATA_MEM_ADDR_WIDTH];
    assign output_wb_radr = output_wbadr_r[3+:DATA_MEM_ADDR_WIDTH];

    assign params_fifo_deq = ~wbs_debug & (state_r == `IDLE) & params_fifo_empty_n;
    assign instr_full_n    = ~wbs_debug & (state_r == `INITIAL_FILL) & (instr_wadr_r <= instr_max_wadr_c);
    assign input_full_n    = ~wbs_debug & (state_r == `RESET_INNER_LOOP) & (input_wadr_r <= input_wadr_offset + input_max_wadr_c);
    assign output_empty_n  = ~wbs_debug & (state_r == `RESET_INNER_LOOP) & (output_wbadr_r <= output_radr_offset + output_max_adr_c);

    assign wbs_fsm_done = (state_r == `RESET_INNER_LOOP);

    always @(posedge clk) begin
        if (~rst_n) begin
            state_r        <= `IDLE;
            config_adr_r   <= 0;
            instr_wadr_r   <= 0;
            input_wadr_r   <= 0;
            output_wbadr_r <= 0;

            mat_inv_en     <= 0;
            mvp_core_en    <= 0;
        end
        else begin
            if (state_r == `IDLE) begin
                if (params_fifo_empty_n) begin
                    config_r[config_adr_r] <= params_fifo_dout;
                    config_adr_r <= config_adr_r + 1;

                    if (config_adr_r == NUM_CONFIGS - 1) begin
                        state_r <= `INITIAL_FILL; 
                    end
                end

                if (wbs_debug && wbs_fsm_start) begin
                    state_r <= `INNER_LOOP;
                    mvp_core_en <= 1;
                end
            end
            else if (state_r == `INITIAL_FILL) begin
                instr_wadr_r <= (instr_wen && instr_wadr_r <= instr_max_wadr_c) ? 
                    instr_wadr_r + 1 : instr_wadr_r;

                if (instr_wadr_r == instr_max_wadr_c + 1) begin
                    state_r <= `INNER_LOOP;
                    mvp_core_en <= 1;
                end
            end
            else if (state_r == `INNER_LOOP) begin
                if (mem_write && (mem_addr == IO_ADDR)) begin
                    state_r        <= `RESET_INNER_LOOP;
                    mvp_core_en    <= 0;
                    input_wadr_r   <= input_wadr_offset;
                    output_wbadr_r <= output_radr_offset;
                end
                else if (mem_write && (mem_addr == INVMAT_ADDR)) begin
                    mvp_core_en <= 0;
                    mat_inv_en  <= 1;
                end
                else if (mat_inv_en && mat_inv_out_vld) begin
                    mvp_core_en <= 1;
                    mat_inv_en  <= 0;
                end
            end
            else if (state_r == `RESET_INNER_LOOP) begin
                input_wadr_r   <= (input_wen && input_full_n) ? input_wadr_r + 8 : input_wadr_r;
                output_wbadr_r <= (output_wb_ren && output_empty_n) ? output_wbadr_r + 8 : output_wbadr_r;

                if ((input_wadr_r >= input_wadr_offset + input_max_wadr_c) && 
                    (output_wbadr_r >= output_radr_offset + output_max_adr_c)) begin
                    mvp_core_en <= 1;
                    state_r <= `INNER_LOOP;
                end

                if (wbs_debug && wbs_fsm_start) begin
                    state_r <= `INNER_LOOP;
                    mvp_core_en <= 1;
                end
            end
        end
    end

    // Assigns values to the configuration registers
    assign instr_max_wadr_c   = config_r[0];
    assign input_max_wadr_c   = config_r[1];
    assign input_wadr_offset  = config_r[2];
    assign output_max_adr_c   = config_r[3];
    assign output_radr_offset = config_r[4];

endmodule
