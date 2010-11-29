`timescale 1ns / 1ps

module test_cpu;
  reg clk, rst;  
  initial
    begin
      clk = 0;
      rst = 1;
      forever #10 clk = ~clk;
    end
  
  initial 
    begin
      #5 rst = 0;
      #15 rst = 1;
    end
  
  cpu cpu_bench(clk, rst);

endmodule
