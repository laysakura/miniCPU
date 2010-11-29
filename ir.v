module ir(
          clk, rst, phase,
          ir_in,
          op1, op2, op3,
          rg1, rg2, sim8, im16,
          tttn
          );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [31:0]       ir_in;
  output reg [7:0]       op1;
  output reg [1:0]       op2;
  output reg [2:0]       op3;
  output [2:0]       rg1;
  output [2:0]       rg2;
  output reg [7:0]       sim8;
  output reg [15:0]      im16;
  output reg [3:0]       tttn;       // used only in zBcc

  assign {rg1,rg2}
    = ir_out(ir_in);

  function [5:0] ir_out;
    input [31:0]     ir_in;

    begin
      ir_out
        = {ir_in[21:19], ir_in[18:16]};
      
      casex (ir_in[31:19]) 
        `zLD:
          // in these ops, rg1 and rg2 are swaped
          ir_out
          = {ir_in[18:16], ir_in[21:19]};
        `zST:
          // in these ops, rg1 and rg2 are swaped
          ir_out
          = {ir_in[18:16], ir_in[21:19]};
      endcase
    end

  endfunction

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      op1 <= 8'b00000000;
      op2 <= 2'b00;
      op3 <= 3'b000;
      sim8 <= 8'b00000000;
      im16 <= 16'b00000000_00000000;
      tttn <= 4'b0000;
    end

    else if (phase[`r] == 1) begin
      op1 <= ir_in[31:24];
      op2 <= ir_in[23:22];
      op3 <= ir_in[21:19];
      sim8 <= ir_in[15:8];
      im16 <= {ir_in[7:0],ir_in[15:8]};
      tttn <= ir_in[19:16];
    end
  end

endmodule