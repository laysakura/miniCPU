module regfile(
               clk, rst,
               phase,
               rg1, rg2,
               regfile_in,
               sr, tr
               );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [2:0]        rg1, rg2;
  input [31:0]       regfile_in;
  output reg [31:0]  sr, tr;

  reg [31:0]         regfile_reg [0:`regfile_h];

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      // doesn't use for statement to explicit
      // non-blocking assignment
      regfile_reg[`ax] <= 32'h00000000;
      regfile_reg[`cx] <= 32'h00000000;
      regfile_reg[`dx] <= 32'h00000000;
      regfile_reg[`bx] <= 32'h00000000;
      regfile_reg[`sp] <= 32'h00000000;
      regfile_reg[`bp] <= 32'h00000000;
      regfile_reg[`si] <= 32'h00000000;
      regfile_reg[`di] <= 32'h00000000;
    end
    
    else if (phase[`f] == 1) begin
      regfile_reg[rg2] <= regfile_in;
    end

    else if (phase[`r] == 1) begin
      sr <= regfile_reg[rg1];
      tr <= regfile_reg[rg2];
    end

  end                           // always @(...)

endmodule
