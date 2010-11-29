module selecter_regfile(
                        op1, op2, op3,
                        dr2, mdr,
                        selected
                        );

`include "defines.vh"

  input [7:0] op1;
  input [1:0] op2;
  input [2:0] op3;
  input [31:0] dr2, mdr;
  output [31:0] selected;

  assign selected
    = selecter_regfile_out(op1, op2, op3, dr2, mdr);

  function [31:0] selecter_regfile_out;
    input [7:0] op1;
    input [1:0] op2;
    input [2:0] op3;
    input [31:0] dr2, mdr;

    begin
      casex ({op1,op2,op3})
        `zLD:
          selecter_regfile_out = mdr;
        default:
          selecter_regfile_out = dr2;
      endcase
    end
  endfunction

endmodule
