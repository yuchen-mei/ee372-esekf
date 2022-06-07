module decoder (
    input  logic [31:0] instr,

    output logic  [4:0] vfu_opcode,
    output logic  [4:0] vd_addr,
    output logic  [4:0] vs1_addr,
    output logic  [4:0] vs2_addr,
    output logic  [4:0] vs3_addr,

    output logic  [3:0] op_sel,
    output logic  [2:0] funct3,
    output logic        masking,
    output logic        reg_we,

    output logic        mem_we,
    output logic [11:0] mem_addr,

    input  logic  [4:0] vd_addr_ex1,
    input  logic  [4:0] vd_addr_ex2,
    input  logic  [4:0] vd_addr_ex3,
    input  logic        reg_we_ex1,
    input  logic        reg_we_ex2,
    input  logic        reg_we_ex3,
    input  logic  [3:0] op_sel_ex1,
    input  logic  [3:0] op_sel_ex2,
    input  logic  [3:0] op_sel_ex3,
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
            {`OP_V, `VFADD}:    vfu_opcode = `VFU_ADD;
            {`OP_V, `VFSUB}:    vfu_opcode = `VFU_SUB;
            {`OP_V, `VFMIN}:    vfu_opcode = `VFU_MIN;
            {`OP_V, `VFMAX}:    vfu_opcode = `VFU_MAX;
            {`OP_V, `VFSGNJ}:   vfu_opcode = `VFU_SGNJ;
            {`OP_V, `VFSGNJN}:  vfu_opcode = `VFU_SGNJN;
            {`OP_V, `VFSGNJX}:  vfu_opcode = `VFU_SGNJX;
            {`OP_V, `VMFEQ}:    vfu_opcode = `VFU_EQ;
            {`OP_V, `VMFLE}:    vfu_opcode = `VFU_LE;
            {`OP_V, `VMFLT}:    vfu_opcode = `VFU_LT;
            {`OP_V, `VFMUL}:    vfu_opcode = `VFU_MUL;
            {`OP_V, `VFMADD}:   vfu_opcode = `VFU_FMA;
            {`OP_V, `VFNMADD}:  vfu_opcode = `VFU_FNMA;
            {`OP_V, `VFMSUB}:   vfu_opcode = `VFU_FMS;
            {`OP_V, `VFNMSUB}:  vfu_opcode = `VFU_FNMS;
            {`OP_V, `VFMACC}:   vfu_opcode = `VFU_FMA;
            {`OP_V, `VFNMACC}:  vfu_opcode = `VFU_FNMA;
            {`OP_V, `VFMSAC}:   vfu_opcode = `VFU_FMS;
            {`OP_V, `VFNMSAC}:  vfu_opcode = `VFU_FNMS;
            {`OP_V, `VFUNARY0}: vfu_opcode = `VPERMUTE;
            default:            vfu_opcode = `VFU_ADD;
        endcase

        case (opcode)
            `OP_FP:   op_sel = 4'b0001;
            `OP_V:    op_sel = 4'b0010;
            `OP_M:    op_sel = 4'b0100;
            `LOAD_FP: op_sel = 4'b1000;
            default:  op_sel = 4'b0000;
        endcase

        if (|vfu_opcode[4:3]) begin
            op_sel = 4'b0;
        end
    end

    // Load and Store
    assign mem_addr = instr[31:20];
    assign mem_we   = (opcode == `STORE_FP);
    assign reg_we   = ~mem_we;

    logic stage1_dependency, stage2_dependency, stage3_dependency;

    assign stage1_dependency = (vs1_addr == vd_addr_ex1 || vs2_addr == vd_addr_ex1 || vs3_addr == vd_addr_ex1) && reg_we_ex1;
    assign stage2_dependency = (vs1_addr == vd_addr_ex2 || vs2_addr == vd_addr_ex2 || vs3_addr == vd_addr_ex2) && reg_we_ex2;
    assign stage3_dependency = (vs1_addr == vd_addr_ex3 || vs2_addr == vd_addr_ex3 || vs3_addr == vd_addr_ex3) && reg_we_ex3;
    assign stall = (stage1_dependency && |op_sel_ex1)      ||
                   (stage2_dependency && |op_sel_ex2[2:0]) ||
                   (stage3_dependency && op_sel_ex3[2]);

endmodule

