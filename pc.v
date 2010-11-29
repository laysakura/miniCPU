module pc(
          clk, rst,
          phase,
          pc_in,
          pc_reg
          );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [31:0] pc_in;

  output reg [31:0] pc_reg;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      pc_reg <= 32'h00000000;
    end

    if (phase[`w] == 1) begin
      pc_reg <= pc_in;
    end

  end                           // always @(...)

endmodule
