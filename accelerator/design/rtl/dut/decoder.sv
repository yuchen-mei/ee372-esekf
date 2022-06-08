module decoder (
    input  logic [31:0] instr,

    output logic  [4:0] vd_addr,
    output logic  [4:0] vs1_addr,
    output logic  [4:0] vs2_addr,
    output logic  [4:0] vs3_addr,

    output logic  [4:0] func_sel,
    output logic  [2:0] funct3,
    output logic  [3:0] wb_sel,
    output logic        masking,
    output logic        reg_we,
    output logic        jump,

    output logic        mem_we,
    output logic [11:0] mem_addr,

    input  logic  [4:0] vd_addr_ex1,
    input  logic  [4:0] vd_addr_ex2,
    input  logic  [4:0] vd_addr_ex3,
    input  logic        reg_we_ex1,
    input  logic        reg_we_ex2,
    input  logic        reg_we_ex3,
    input  logic  [3:0] wb_sel_ex1,
    input  logic  [3:0] wb_sel_ex2,
    input  logic  [3:0] wb_sel_ex3,
    output logic        stall
);

    logic [6:0] opcode;
    logic [4:0] dest;
    logic [4:0] src1;
    logic [4:0] src2;
    logic [5:0] funct6;

    assign opcode  = instr[6:0];
    assign dest    = instr[11:7];
    assign funct3  = instr[14:12];
    assign src1    = instr[19:15];
    assign src2    = instr[24:20];
    assign masking = instr[25];
    assign funct6  = instr[31:26];

    assign overwrite_multiplicand = ((opcode == `VFMACC)  ||
                                     (opcode == `VFNMACC) || 
                                     (opcode == `VFMSAC)  || 
                                     (opcode == `VFNMSAC));
    assign vs1_addr = src1;
    assign vs2_addr = overwrite_multiplicand ? dest : src2;
    assign vs3_addr = (opcode == `OP_M)      ? instr[31:27] :
                      overwrite_multiplicand ? src2         : dest;
    assign vd_addr  = dest;

    always_comb begin
        case ({opcode, funct6})
            {`OP_V, `VFADD}:    func_sel = `VFU_ADD;
            {`OP_V, `VFSUB}:    func_sel = `VFU_SUB;
            {`OP_V, `VFMIN}:    func_sel = `VFU_MIN;
            {`OP_V, `VFMAX}:    func_sel = `VFU_MAX;
            {`OP_V, `VFSGNJ}:   func_sel = `VFU_SGNJ;
            {`OP_V, `VFSGNJN}:  func_sel = `VFU_SGNJN;
            {`OP_V, `VFSGNJX}:  func_sel = `VFU_SGNJX;
            {`OP_V, `VMFEQ}:    func_sel = `VFU_EQ;
            {`OP_V, `VMFLE}:    func_sel = `VFU_LE;
            {`OP_V, `VMFLT}:    func_sel = `VFU_LT;
            {`OP_V, `VFMUL}:    func_sel = `VFU_MUL;
            {`OP_V, `VFMADD}:   func_sel = `VFU_FMA;
            {`OP_V, `VFNMADD}:  func_sel = `VFU_FNMA;
            {`OP_V, `VFMSUB}:   func_sel = `VFU_FMS;
            {`OP_V, `VFNMSUB}:  func_sel = `VFU_FNMS;
            {`OP_V, `VFMACC}:   func_sel = `VFU_FMA;
            {`OP_V, `VFNMACC}:  func_sel = `VFU_FNMA;
            {`OP_V, `VFMSAC}:   func_sel = `VFU_FMS;
            {`OP_V, `VFNMSAC}:  func_sel = `VFU_FNMS;
            {`OP_V, `VFUNARY0}: func_sel = `VPERMUTE;
            default:            func_sel = `VFU_ADD;
        endcase

        case (opcode)
            `OP_FP:   wb_sel = 4'b0001;
            `OP_V:    wb_sel = 4'b0010;
            `OP_M:    wb_sel = 4'b0100;
            `LOAD_FP: wb_sel = 4'b1000;
            default:  wb_sel = 4'b0000;
        endcase

        if (|func_sel[4:3]) begin
            wb_sel = 4'b0;
        end
    end

    assign mem_addr = instr[31:20];
    assign mem_we   = (opcode == `STORE_FP);
    assign jump     = (opcode == `JALR);
    assign reg_we   = ~mem_we && ~jump;

    logic stage1_dependency, stage2_dependency, stage3_dependency;

    assign stage1_dependency = (vs1_addr == vd_addr_ex1 || vs2_addr == vd_addr_ex1 || vs3_addr == vd_addr_ex1) && reg_we_ex1;
    assign stage2_dependency = (vs1_addr == vd_addr_ex2 || vs2_addr == vd_addr_ex2 || vs3_addr == vd_addr_ex2) && reg_we_ex2;
    assign stage3_dependency = (vs1_addr == vd_addr_ex3 || vs2_addr == vd_addr_ex3 || vs3_addr == vd_addr_ex3) && reg_we_ex3;
    assign stall = (stage1_dependency && |wb_sel_ex1)      ||
                   (stage2_dependency && |wb_sel_ex2[2:0]) ||
                   (stage3_dependency && wb_sel_ex3[2]);

endmodule

