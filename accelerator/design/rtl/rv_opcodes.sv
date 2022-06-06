// Major Opcodes
`define LOAD_FP  7'b0000111
`define STORE_FP 7'b0100111
`define JALR     7'b1100111
`define OP_FP    7'b1010011
`define OP_V     7'b1010111
`define OP_M     7'b0001011
// `define custom-1 7'b0101011
// `define custom-2 7'b1011011
// `define custom-3 7'b1111011

// funct6
`define VFADD       6'b000000
`define VFSUB       6'b000010
`define VFMIN       6'b000100
`define VFMAX       6'b000110
`define VFSGNJ      6'b001000
`define VFSGNJN     6'b001001
`define VFSGNJX     6'b001010
`define VFSLIDEUP   6'b001110
`define VFSLIDEDOWN 6'b001111
`define VFUNARY0    6'b010010
`define VFUNARY1    6'b010011
`define VFMERGE     6'b010111
`define VMFEQ       6'b011000
`define VMFLE       6'b011001
`define VMFLT       6'b011011
`define VMFNE       6'b011100
`define VMFGT       6'b011101
`define VMFGE       6'b011111
`define VFDIV       6'b100000
`define VFMUL       6'b100100
`define VSMUL       6'b100111 // vmv<nr>r
`define VFMADD      6'b101000
`define VFNMADD     6'b101001
`define VFMSUB      6'b101010
`define VFNMSUB     6'b101011
`define VFMACC      6'b101100
`define VFNMACC     6'b101101
`define VFMSAC      6'b101110
`define VFNMSAC     6'b101111

// VFU Opcodes
`define VFU_ADD     5'b00000
`define VFU_SUB     5'b00001
`define VFU_MUL     5'b00010
`define VFU_DIV     5'b00011
`define VFU_FMA     5'b00100
`define VFU_FMS     5'b00101
`define VFU_FNMA    5'b00110
`define VFU_FNMS    5'b00111
`define VFU_MIN     5'b01000
`define VFU_MAX     5'b01001
`define VFU_SGNJ    5'b01010
`define VFU_SGNJN   5'b01011
`define VFU_SGNJX   5'b01100
`define VFU_EQ      5'b01101
`define VFU_LT      5'b01110
`define VFU_LE      5'b01111
`define VPERMUTE    5'b10000

`define DPU_MMA     3'b000
`define DPU_DOT     3'b001
`define DPU_QMUL    3'b010
`define DPU_ROT     3'b011

`define SFU_RECIP   3'b000
`define SFU_SQRT    3'b001
`define SFU_INVSQRT 3'b010
`define SFU_SIN     3'b011
`define SFU_COS     3'b100
`define SFU_LOG2    3'b101
`define SFU_EXP2    3'b110
