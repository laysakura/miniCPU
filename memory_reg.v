module memory_reg(
                  clk, rst,
                  phase,
                  pc,
                  ma,
                  op1, op2, op3,
                  memory_reg_in,
                  memory_reg_out
                  );

`include "defines.vh"

  input clk, rst;
  input [`phase_h:0] phase;
  input [31:0]       pc;
  input [31:0]       ma;
  input [7:0] op1;
  input [1:0] op2;
  input [2:0] op3;
  input [31:0]       memory_reg_in;
  output reg [31:0]  memory_reg_out;

  reg [31:0]         memory_reg_reg [0:255];

  // load initial memory map
  initial $readmemb("test/mem04.bnr", memory_reg_reg);

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin

    end
    
    else if (phase[`f] == 1) begin
      memory_reg_out <= memory_reg_reg[pc];
    end

    else if (phase[`m] == 1) begin
      casex ({op1,op2,op3}) 
        `zLD:
          // read
          memory_reg_out <= memory_reg_reg[ma];
        `zST:
          // write
          memory_reg_reg[ma] <= memory_reg_in;
      endcase
      
    end
  end                           // always @(...)

endmodule
