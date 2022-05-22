// Major Opcodes
`define LOAD_FP  7'b0000111
`define STORE_FP 7'b0100111
`define OP_V     7'b1010111
`define OP_FP    7'b1010011
`define VFMA     7'b0001011
`define MMA      7'b0101011
// `define custom-2 7'b1011011
// `define custom-3 7'b1111011

// funct6
`define VFADD    6'b000000
`define VFSUB    6'b000010
`define VFMV     6'b010111
`define VFMUL    6'b100100
`define VSMUL    6'b100111 // vmv<nr>r
`define VFMADD   6'b101000
`define VFNMADD  6'b101001
`define VFMSUB   6'b101010
`define VFNMSUB  6'b101011
`define VFMACC   6'b101100
`define VFNMACC  6'b101101
`define VFMSAC   6'b101110
`define VFNMSAC  6'b101111

// FPU Opcodes
`define FPU_ADD  5'b00000
`define FPU_SUB  5'b00001
`define FPU_MUL  5'b00010
`define FPU_FMA  5'b00100
`define FPU_FMS  5'b00101
`define FPU_NFMA 5'b00110
`define FPU_NFMS 5'b00111

`define FPU_MMA  5'b01000
`define FPU_MMS  5'b01001
`define FPU_NMMA 5'b01010
`define FPU_NMMS 5'b01011
`define FPU_DOT  5'b01100
`define FPU_QMUL 5'b01101
`define FPU_ROT  5'b01110

`define FPU_INV  5'b10000
`define FPU_SQRT 5'b10001
`define FPU_INVSQRT 5'b10010
`define FPU_SIN  5'b10011
`define FPU_COS  5'b10100

`define SKEW_SYM 5'b11000
`define TRANSPOSE  5'b11001
