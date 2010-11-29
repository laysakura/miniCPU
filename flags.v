module flags(
             clk, rst,
             phase,
             op1, op2, op3,
             flags_in,
             flags_out
             );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [7:0]        op1;
  input [1:0]        op2;
  input [2:0]        op3;
  input [`flags_h:0] flags_in;
  output [`flags_h:0] flags_out;
  
  reg [3:0]           flags_reg;

  assign flags_out = flags_reg;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      flags_reg <= 4'b0000;
    end
    
    else if (phase[`m] == 1) begin
      casex ({op1,op2,op3}) 
        // the cases in which flags are renewed.
        `zADD:
          flags_reg <= flags_in;
        `zSUB:
          flags_reg <= flags_in;
        `zCMP:
          flags_reg <= flags_in;
        `zSLL:
          flags_reg <= flags_in;
      endcase
      
    end

  end                           // always @(...)

endmodule
