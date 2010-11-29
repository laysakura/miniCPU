module cpu(
           clk, rst
           );

`include "defines.vh"

  input clk, rst;
  reg [`phase_h:0] phase;

  // wire naming rule:
  // defines only output wires.
  // must determine which port to input the output wires.
  wire [31:0]      pc_out;

  wire [31:0]      memory_out;
  wire             alu_memory_wren;
  
  wire [7:0]      ir_op1_out;
  wire [1:0]      ir_op2_out;
  wire [2:0]      ir_op3_out;
  wire [2:0]      ir_rg1_out;
  wire [2:0]      ir_rg2_out;
  wire [7:0]      ir_sim8_out;
  wire [15:0]     ir_im16_out;
  wire [3:0]      ir_tttn_out;

  wire [31:0]     regfile_sr_out;
  wire [31:0]     regfile_tr_out;
  
  wire [31:0]     sr_out;
  
  wire [31:0]     tr_out;
  
  wire [31:0]     alu_dr_out;
  wire [`flags_h:0] alu_flags_out;

  wire [`flags_h:0]       flags_out;
  
  wire [31:0]       dr_out;
  
  wire [31:0]       dr2_out;
  
  wire [31:0]       mdr_out;
  
  wire [31:0]       selecter_regfile;            
  wire [31:0]       selecter_pc;      
  wire [4:0]        selecter_op_data;
  
  selecter_regfile selecter_regfile_cpu
    (
     ir_op1_out, ir_op2_out, ir_op3_out,
     dr2_out, mdr_out,
     selecter_regfile);

  selecter_pc_inc_jmp selecter_pc_cpu
    (
     ir_op1_out, ir_op2_out, ir_op3_out,
     pc_out, dr_out,
     selecter_pc);

  selecter_op_data selecter_op_data_cpu
    (
     clk, rst, phase,
     pc_out[4:0], dr_out[4:0],
     selecter_op_data);

  pc pc_cpu(clk, rst, phase,
            selecter_pc, pc_out);

  ir ir_cpu(clk, rst, phase,
            memory_out,
            ir_op1_out, ir_op2_out, ir_op3_out,
            ir_rg1_out, ir_rg2_out,
            ir_sim8_out, ir_im16_out, ir_tttn_out);

  regfile regfile_cpu(clk, rst, phase,
                      ir_rg1_out, ir_rg2_out,
                      selecter_regfile,
                      regfile_sr_out, regfile_tr_out);

  sr sr_cpu(clk, rst, phase, regfile_sr_out, sr_out);

  tr tr_cpu(clk, rst, phase, regfile_tr_out, tr_out);

  alu alu_cpu(pc_out,
              ir_op1_out, ir_op2_out, ir_op3_out,
              ir_sim8_out, ir_im16_out, ir_tttn_out,
              sr_out, tr_out,
              alu_dr_out,
              flags_out, alu_flags_out,
              alu_memory_wren);

  flags flags_cpu(clk, rst, phase,
                  ir_op1_out, ir_op2_out, ir_op3_out,
                  alu_flags_out, flags_out);

  dr dr_cpu(clk, rst, phase, alu_dr_out, dr_out);

  dr2 dr2_cpu(clk, rst, phase, dr_out, dr2_out);

  mdr mdr_cpu(clk, rst, phase, memory_out, mdr_out);

  memory memory_cpu
    (clk, tr_out, selecter_op_data, dr_out[4:0], alu_memory_wren, memory_out);

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      phase <= 5'b00001;        // turn to F phase
    end
    else if(phase[`f] == 1) begin
      phase <= 5'b00010;
    end
    else if(phase[`r] == 1) begin
      phase <= 5'b00100;
    end
    else if(phase[`x] == 1) begin
      if ({ir_op1_out,ir_op2_out,ir_op3_out} == `zHLT)
        phase <= 5'b00100; // HLT!
      else phase <= 5'b01000;
    end
    else if(phase[`m] == 1) begin
      phase <= 5'b10000;
    end
    else if(phase[`w] == 1) begin
      phase <= 5'b00001;
    end
  end                           // always @(...)
  
endmodule
