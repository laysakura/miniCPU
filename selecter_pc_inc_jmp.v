module selecter_pc_inc_jmp(
                           op1, op2, op3,
                           pc, dr2,
                           selected
                           );

`include "defines.vh"

  input [7:0] op1;
  input [1:0] op2;
  input [2:0] op3;
  input [31:0] pc, dr;
  output [31:0] selected;

  assign selected
    = selecter_pc_inc_jmp_out(op1, op2, op3, pc, dr);

  function [31:0] selecter_pc_inc_jmp_out;
    input [7:0] op1;
    input [1:0] op2;
    input [2:0] op3;
    input [31:0] pc, dr;

    begin
      casex ({op1,op2,op3}) 
        `zB:
          selecter_pc_inc_jmp_out = dr;
        `zBcc:
          selecter_pc_inc_jmp_out = dr;
        `zHLT:
          selecter_pc_inc_jmp_out = pc;
        default:
          selecter_pc_inc_jmp_out = pc + 1;      // Main memory is
                                // dword(32bit) addressing.
      endcase
    end
  endfunction

endmodule
