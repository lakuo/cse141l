include "Definitions.sv"
include "Ctrl.sv"

module Ctrl_tb();
  reg [8:0] Instruction;
  reg [7:0] AccInput;
  wire PC_Jmp_Flag, PC_Beq_Flag, LUT_Write_En, LUT_Read_En, LUT_Load_Hi, Reg_Write_En, Reg_From_ALU, Reg_From_Mem, Reg_From_Acc, Acc_Write_En, Acc_From_Reg, Acc_From_ALU, Acc_From_Imm, Acc_Load_Hi, Mem_Write_En, Ack;
  wire [4:0] ALU_Opcode, op_mnemonic;

  Ctrl ctrl (
    .Instruction(Instruction),
    .AccInput(AccInput),
    .PC_Jmp_Flag(PC_Jmp_Flag),
    .PC_Beq_Flag(PC_Beq_Flag),
    .LUT_Write_En(LUT_Write_En),
    .LUT_Read_En(LUT_Read_En),
    .LUT_Load_Hi(LUT_Load_Hi),
    .Reg_Write_En(Reg_Write_En),
    .Reg_From_ALU(Reg_From_ALU),
    .Reg_From_Mem(Reg_From_Mem),
    .Reg_From_Acc(Reg_From_Acc),
    .Acc_Write_En(Acc_Write_En),
    .Acc_From_Reg(Acc_From_Reg),
    .Acc_From_ALU(Acc_From_ALU),
    .Acc_From_Imm(Acc_From_Imm),
    .Acc_Load_Hi(Acc_Load_Hi),
    .Mem_Write_En(Mem_Write_En),
    .Ack(Ack),
    .ALU_Opcode(ALU_Opcode),
    .op_mnemonic(op_mnemonic)
  );

  integer i;
  reg [4:0] prev_bits;

  initial begin
    $dumpfile("Ctrl_tb.vcd");
    $dumpvars(0, Ctrl_tb);

    // Test all possible instructions
    for (i = 0; i < 32; i++) begin // Only iterate over the tested bits
      Instruction = {Instruction[8:5], i, Instruction[3:0]}; // Set the current test value
      AccInput = $random;
      #10;

      if (Instruction[8:4] !== prev_bits) begin // Check if the tested bits have changed
        $display("Tested bits changed: %b", Instruction[8:4]); // Display the changed bits
      end

      prev_bits = Instruction[8:4]; // Update the previous value
    end

    $finish;
  end
endmodule