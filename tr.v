module tr(
          tr_in,
          tr_out
          );

`include "defines.vh"

  input [31:0]       tr_in;
  output [31:0]  tr_out;

  assign tr_out = tr_in;

endmodule
