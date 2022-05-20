// FPU Opcodes
`define FPU_ADDV  5'b00000
`define FPU_ADDF  5'b00001
`define FPU_SUBV  5'b00010
`define FPU_SUBF  5'b00011
`define FPU_MULV  5'b00100
`define FPU_MULF  5'b00101

`define FPU_FMAV  5'b01000
`define FPU_FMAF  5'b01001
`define FPU_FMSV  5'b01010
`define FPU_FMSF  5'b01011
`define FPU_NFMAV 5'b01100
`define FPU_NFMAF 5'b01101
`define FPU_NFMSV 5'b01110
`define FPU_NFMSF 5'b01111

`define FPU_MMA   5'b10000
`define FPU_MMS   5'b10001
`define FPU_NMMA  5'b10010
`define FPU_NMMS  5'b10011
`define FPU_DOT   5'b10100
`define FPU_QMUL  5'b10101
`define FPU_ROT   5'b10110
`define FPU_MATIV 5'b10111

`define FPU_INV   5'b11000
`define FPU_SQRT  5'b11001
`define FPU_INVSQRT 5'b11010
`define FPU_SIN   5'b11011
`define FPU_COS   5'b11100