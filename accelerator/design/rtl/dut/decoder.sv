module decoder (
    input  logic [31:0] instr,

    output logic  [4:0] vd_addr,
    output logic  [4:0] vs1_addr,
    output logic  [4:0] vs2_addr,
    output logic  [4:0] vs3_addr,

    output logic  [4:0] func_sel,
    output logic  [2:0] funct3,
    output logic  [4:0] wb_sel,
    output logic        masking,
    output logic        reg_we,
    output logic        jump,
    output logic        branch,

    output logic        mem_we,
    output logic [11:0] mem_addr,

    input  logic  [4:0] vd_addr_ex1,
    input  logic  [4:0] vd_addr_ex2,
    input  logic  [4:0] vd_addr_ex3,
    input  logic        reg_we_ex1,
    input  logic        reg_we_ex2,
    input  logic        reg_we_ex3,
    input  logic  [4:0] wb_sel_ex1,
    input  logic  [4:0] wb_sel_ex2,
    input  logic  [4:0] wb_sel_ex3,
    output logic        stall
);

    logic [ 6:0] opcode;
    logic [ 4:0] dest;
    logic [ 4:0] src1;
    logic [ 4:0] src2;
    logic [ 5:0] funct6;
    logic [11:0] branch_offset;

    assign opcode  = instr[6:0];
    assign dest    = instr[11:7];
    assign funct3  = instr[14:12];
    assign src1    = instr[19:15];
    assign src2    = instr[24:20];
    assign masking = instr[25];
    assign funct6  = instr[31:26];
    assign branch_offset = {instr[31:25], instr[11:7]};

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
            {`OP_V, `VFADD}:      func_sel = `FADD;
            {`OP_V, `VFSUB}:      func_sel = `FSUB;
            {`OP_V, `VFMIN}:      func_sel = `FMIN;
            {`OP_V, `VFMAX}:      func_sel = `FMAX;
            {`OP_V, `VFSGNJ}:     func_sel = `FSGNJ;
            {`OP_V, `VFSGNJN}:    func_sel = `FSGNJN;
            {`OP_V, `VFSGNJX}:    func_sel = `FSGNJX;
            {`OP_V, `VFSGNJX}:    func_sel = `FSGNJX;
            {`OP_V, `VSLIDEUP}:   func_sel = `SLIDEUP;
            {`OP_V, `VSLIDEDOWN}: func_sel = `SLIDEDOWN;
            {`OP_V, `VMFEQ}:      func_sel = `FCMPEQ;
            {`OP_V, `VMFLE}:      func_sel = `FCMPLE;
            {`OP_V, `VMFLT}:      func_sel = `FCMPLT;
            {`OP_V, `VFMUL}:      func_sel = `FMUL;
            {`OP_V, `VFMADD}:     func_sel = `FMADD;
            {`OP_V, `VFNMADD}:    func_sel = `FNMADD;
            {`OP_V, `VFMSUB}:     func_sel = `FMSUB;
            {`OP_V, `VFNMSUB}:    func_sel = `FNMSUB;
            {`OP_V, `VFMACC}:     func_sel = `FMADD;
            {`OP_V, `VFNMACC}:    func_sel = `FNMADD;
            {`OP_V, `VFMSAC}:     func_sel = `FMSUB;
            {`OP_V, `VFNMSAC}:    func_sel = `FNMSUB;
            {`OP_V, `VSKEW}:      func_sel = `SKEW;
            {`OP_V, `VTRANSPOSE}: func_sel = `TRANSPOSE;
            {`OP_V, `VIDENTITY}:  func_sel = `IDENTITY;
            default:              func_sel = '0;
        endcase

        if (opcode == `BRANCH) begin
            case (funct3)
                3'b000: func_sel = `FCMPEQ;
                3'b100: func_sel = `FCMPLT;
            endcase
        end

        case (opcode)
            `LOAD_FP: wb_sel = 5'b00010;
            `OP_V:    wb_sel = ~|func_sel[4:3] ? 5'b00100 : 5'b00001;
            `OP_FP:   wb_sel = 5'b01000;
            `OP_M:    wb_sel = 5'b10000;
            default:  wb_sel = 5'b0;
        endcase
    end

    assign mem_addr = branch ? branch_offset : instr[31:20];
    assign mem_we   = (opcode == `STORE_FP);
    assign jump     = (opcode == `JALR);
    assign branch   = (opcode == `BRANCH);
    assign reg_we   = ~mem_we && ~jump && ~branch;

    logic stage1_dependency, stage2_dependency, stage3_dependency;

    assign stage1_dependency = (vs1_addr == vd_addr_ex1 || vs2_addr == vd_addr_ex1 || vs3_addr == vd_addr_ex1) && reg_we_ex1;
    assign stage2_dependency = (vs1_addr == vd_addr_ex2 || vs2_addr == vd_addr_ex2 || vs3_addr == vd_addr_ex2) && reg_we_ex2;
    assign stage3_dependency = (vs1_addr == vd_addr_ex3 || vs2_addr == vd_addr_ex3 || vs3_addr == vd_addr_ex3) && reg_we_ex3;
    assign stall = (stage1_dependency && |wb_sel_ex1[4:1]) ||
                   (stage2_dependency && |wb_sel_ex2[4:2]) ||
                   (stage3_dependency && wb_sel_ex3[4]);

endmodule

