// op codes
`define op_h 12
`define zLD 13'b1000_1011_01_xxx
`define zST 13'b1000_1001_01_xxx
`define zLIL 13'b0110_0110_10_111
`define zMOV 13'b1000_1001_11_xxx
`define zADD 13'b0000_0001_11_xxx
`define zSUB 13'b0010_1001_11_xxx
`define zCMP 13'b0011_1001_11_xxx
`define zAND 13'b0010_0001_11_xxx
`define zOR 13'b0000_1001_11_xxx
`define zXOR 13'b0011_0001_11_xxx
`define zNOT 13'b1111_0111_11_010
`define zSLL 13'b1100_0001_11_100
// zSLL and zSLA are totally the same.
`define zSRL 13'b1100_0001_11_101
`define zSRA 13'b1100_0001_11_111
`define zB 13'b1001_0000_11_101
`define zBcc 13'b1001_0000_01_11x
`define zHLT 13'b1111_0100_xx_xxx

// Flags
`define sf 0
`define zf 1
`define cf 2
`define of 3
`define flags_h 3

// cc (in zBcc)
`define o 4'b0000
`define no 4'b0001
`define b 4'b0010
`define nb 4'b0011
`define e 4'b0100
`define ne 4'b0101
`define be 4'b0110
`define nbe 4'b0111
`define s 4'b1000
`define ns 4'b1001
`define l 4'b1100
`define nl 4'b1101
`define le 4'b1110
`define nle 4'b1111

// Phases
`define f 0
`define r 1
`define x 2
`define m 3
`define w 4
`define phase_h 4
