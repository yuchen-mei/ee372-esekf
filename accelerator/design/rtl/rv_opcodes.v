// Major Opcodes
`define BRANCH     7'b1100011
`define JALR       7'b1100111
`define LOAD_FP    7'b0000111
`define STORE_FP   7'b0100111
`define JALR       7'b1100111
`define OP_FP      7'b1010011
`define OP_V       7'b1010111
`define OP_M       7'b0001011
// `define custom-1   7'b0101011
// `define custom-2   7'b1011011
// `define custom-3   7'b1111011

// funct6
`define VFADD      6'b000000
`define VFSUB      6'b000010
`define VFMIN      6'b000100
`define VFMAX      6'b000110
`define VFSGNJ     6'b001000
`define VFSGNJN    6'b001001
`define VFSGNJX    6'b001010
`define VSLIDEUP   6'b001110
`define VSLIDEDOWN 6'b001111
`define VFUNARY0   6'b010010
`define VFUNARY1   6'b010011
`define VFMERGE    6'b010111
`define VMFEQ      6'b011000
`define VMFLE      6'b011001
`define VMFLT      6'b011011
`define VMFNE      6'b011100
`define VMFGT      6'b011101
`define VMFGE      6'b011111
`define VFDIV      6'b100000
`define VFMUL      6'b100100
`define VSMUL      6'b100111 // vmv<nr>r
`define VFMADD     6'b101000
`define VFNMADD    6'b101001
`define VFMSUB     6'b101010
`define VFNMSUB    6'b101011
`define VFMACC     6'b101100
`define VFNMACC    6'b101101
`define VFMSAC     6'b101110
`define VFNMSAC    6'b101111
`define VSKEW      6'b110000
`define VTRANSPOSE 6'b110001
`define VIDENTITY  6'b110010

`define ALU_ADD    4'b0000
`define ALU_SUB    4'b0001
`define ALU_SLT    4'b0010
`define ALU_SLTU   4'b0011
`define ALU_AND    4'b0100
`define ALU_OR     4'b0101
`define ALU_XOR    4'b0110
`define ALU_SLL    4'b0111
`define ALU_SRL    4'b1000
`define ALU_SRA    4'b1001
`define ALU_MUL    4'b1010

`define FADD       5'b00000
`define FSUB       5'b00001
`define FMUL       5'b00010
`define FDIV       5'b00011
`define FMADD      5'b00100
`define FMSUB      5'b00101
`define FNMADD     5'b00110
`define FNMSUB     5'b00111
`define FMIN       5'b01000
`define FMAX       5'b01001
`define FSGNJ      5'b01010
`define FSGNJN     5'b01011
`define FSGNJX     5'b01100
`define FCVTWS     5'b01101
`define FCVTSW     5'b01110
`define FCMPEQ     5'b01111
`define FCMPLT     5'b10000
`define FCMPLE     5'b10001
`define FCLASS     5'b10010
`define SLIDEUP    5'b10011
`define SLIDEDOWN  5'b10100
`define SKEW       5'b10101
`define TRANSPOSE  5'b10110
`define IDENTITY   5'b10111

`define FMMA       3'b000
`define FDOT       3'b001
`define FQMUL      3'b010
`define FROT       3'b011

`define FRECIP     3'b000
`define FSQRT      3'b001
`define FINVSQRT   3'b010
`define FSIN       3'b011
`define FCOS       3'b100
`define FLOG2      3'b101
`define FEXP2      3'b110
