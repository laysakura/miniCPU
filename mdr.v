module mdr(
           clk, rst,
           phase,
           mdr_in,
           mdr_out
           );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [31:0]       mdr_in;
  output reg [31:0]  mdr_out;

  reg [31:0]         mdr_reg;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      mdr_reg = 32'h00000000;
    end
    
    else if (phase[`w] == 1) begin
      mdr_reg = mdr_in;
      mdr_out = mdr_reg;
    end
  end                           // always @(...)

endmodule
