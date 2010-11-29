module sr(
          sr_in,
          sr_out
          );

`include "defines.vh"

  input [31:0]       sr_in;
  output [31:0]  sr_out;

  assign sr_out  = sr_in;

endmodule
