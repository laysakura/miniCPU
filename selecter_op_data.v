module selecter_op_data(
                        clk, rst, phase,
                        pc, dr,
                        selected
                        );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [4:0] pc, dr;
  output [4:0] selected;

  assign selected = select_out(phase, pc, dr);

  function [4:0] select_out;
    input [`phase_h:0] phase;
    input [4:0]        pc, dr;

    if (phase[`w] == 1
        || phase[`f] == 1
        || phase[`r] == 1) begin
      select_out = pc;
    end

    else if (phase[`x] == 1
             || phase[`m] == 1) begin
      select_out = dr;
    end

  endfunction

endmodule
