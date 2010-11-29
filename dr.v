module dr(
          clk, rst,
          phase,
          dr_in,
          dr_out
          );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [31:0]       dr_in;
  output reg [31:0]  dr_out;

  reg [31:0]         dr_reg;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      dr_reg = 32'h00000000;
    end

    else if (phase[`m] == 1) begin
      dr_reg = dr_in;
      dr_out = dr_reg;
    end
  end                           // always @(...)

endmodule
