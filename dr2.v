module dr2(
          clk, rst,
          phase,
          dr2_in,
          dr2_out
          );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [31:0]       dr2_in;
  output reg [31:0]  dr2_out;

  reg [31:0]         dr2_reg;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      dr2_reg = 32'h00000000;
    end
    
    else if (phase[`w] == 1) begin
      dr2_reg = dr2_in;
      dr2_out = dr2_reg;
    end
  end                           // always @(...)

endmodule
