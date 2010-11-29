module alu(
           pc,
           op1, op2, op3,
           sim8, im16,
           tttn,
           sr, tr,
           dr,
           flags_in, flags_out,
           memory_wren
           );

`include "defines.vh"

  input [31:0]       pc;
  input [7:0]        op1;
  input [1:0]        op2;
  input [2:0]        op3;
  input signed [7:0] sim8;
  input [15:0]       im16;
  input [3:0]        tttn;       // used only in zBcc
  input [31:0]       sr, tr;
  output [31:0]      dr;
  input [3:0]        flags_in;       // {of,cf,zf,sf}
  output [3:0]        flags_out;       // {of,cf,zf,sf}
  output              memory_wren;

  assign {memory_wren,flags_out,dr}
    = dr_out(pc, op1, op2, op3,
             sim8, im16, tttn,
             sr, tr,
             flags_in
             );
  
  // Function to be used in calc operations.
  // Returns {of,cf,zf,sf}
  function [`flags_h:0] bi_op_flags;
    input [31:0]     sr;
    input [31:0]     tr;
    input [32:0]     result;     // result = sr op tr
    reg [3:0]        flags;

    begin
      flags[`sf] = result[31]; // Not so confident...
      flags[`zf]
        = (result[32:0] == {33{1'b0}} ? 1 : 0);
      flags[`cf] = result[32];
      // of is 1 when:
      //   1. (neg num) + (neg num) == (pos num)
      //   2. (pos num) + (pos num) == (neg num)
      // so, when "C = A + B",
      //   of = MSB(A)&MSB(B)&(~MSB(C))
      //       |(~MSB(A))&(~MSB(B))&MSB(C)
      flags[`of] = (sr[31] & tr[31] & ~result[32])
      | (~sr[31] & ~tr[31] & result[32]);

      bi_op_flags = flags;
    end
  endfunction
  
  function [36:0] dr_out;       // 36: wren 35-32: flags_out 31-0: dr
    input [31:0]       pc;
    input [7:0]        op1;
    input [1:0]        op2;
    input [2:0]        op3;
    input signed [7:0] sim8;
    input [15:0]       im16;
    input [3:0]        tttn;       // used only in zBcc
    input [31:0]       sr, tr;
    input [3:0]        flags_in;
    reg [32:0]         result;      // has flags info
    reg [3:0]          flags;       // temporary var
    
    casex ({op1,op2,op3})
      `zLD: begin
        dr_out = {1'b0,4'b0000, sr + $signed(sim8)};
      end

      `zST: begin
        dr_out = {1'b1,4'b0000, sr + $signed(sim8)};
      end

      `zLIL: begin
        if (im16[15] == 0)      // pos num
          dr_out = {1'b0,4'b0000,
                    16'b00000000_00000000,im16};
        else      // neg num
          dr_out = {1'b0,4'b0000,
                    16'b11111111_11111111,im16};
      end

      `zMOV: begin
        dr_out = {1'b0,4'b0000, sr};
      end

      `zADD: begin
        result = tr + sr;
        flags = bi_op_flags(sr, tr, result);
        dr_out = {1'b0,flags, result[31:0]};
      end

      `zSUB: begin
        result = tr - sr;
        flags = bi_op_flags(sr, tr, result);
        dr_out = {1'b0,flags, result[31:0]};
      end

      `zCMP: begin
        flags[`zf] = (sr == tr ? 1 : 0);
        if (sr < tr) begin
          flags[`cf] = 1;
          flags[`sf] = 1;
          flags[`of] = 0;
        end
        else begin
          flags[`cf] = 0;
          flags[`sf] = 0;
          flags[`of] = 0;
        end
        dr_out = {1'b0,flags, 32'h00000000};

      end

      `zAND: begin
        dr_out = {1'b0,4'b0000, tr & sr};
      end

      `zOR: begin
        dr_out = {1'b0,4'b0000, tr | sr};
      end

      `zXOR: begin
        dr_out = {1'b0,4'b0000, tr ^ sr};
      end

      `zNOT: begin
        dr_out = {1'b0,4'b0000, ~sr};
      end

      `zSLL: begin
        flags[`of] = (tr[31] == 1 ? 1 : 0);
        flags[`zf] = 0;
        flags[`cf] = 0;
        flags[`sf] = 0;
        dr_out = {1'b0,flags, tr << $signed(sim8)};
      end

      `zSRL: begin
        dr_out = {1'b0,4'b0000, tr >> $signed(sim8)};
      end

      `zSRA: begin
        dr_out = {1'b0,4'b0000, $signed(tr) >>> $signed(sim8)};
      end

      `zB: begin
        dr_out = {1'b0,4'b0000,
                  $signed(pc)  + $signed(sim8)}; 
      end

      `zBcc: begin
        case (tttn)
          `o: begin
            if (flags_in[`of] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `no: begin
            if (flags_in[`of] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `b: begin
            if (flags_in[`cf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `nb: begin
            if (flags_in[`cf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `e: begin
            if (flags_in[`zf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `ne: begin
            if (flags_in[`zf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `be: begin
            if (flags_in[`zf] == 1 || flags_in[`cf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `nbe: begin
            if (flags_in[`zf] == 1 || flags_in[`cf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `s: begin
            if (flags_in[`sf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `ns: begin
            if (flags_in[`sf] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `l: begin
            if (flags_in[`sf] ^ flags_in[`of] == 1)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `nl: begin
            if (flags_in[`sf] ^ flags_in[`of] == 0)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
          `le: begin
            dr_out = {1'b0,4'b0000,
                      (((flags_in[`sf] ^ flags_in[`of]) | flags_in[`zf]) == 1
                       ? $signed(pc[7:0])  + $signed(sim8) : pc + 1)};
          end
          `nle: begin
            if (flags_in[`sf] ^ flags_in[`of] | flags_in[`zf] == 0)
              dr_out = {1'b0,4'b0000, $signed(pc)  + $signed(sim8)};
            else
              dr_out = {1'b0,4'b0000, pc + 1};
          end
        endcase
      end

      `zHLT: begin
      end
      
    endcase                     // case ({op1,op2,op3})
  endfunction

endmodule