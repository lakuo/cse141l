module TopLevel(
  input        Reset, Clk,
  output logic Ack
);

logic Ctrl1_PC_Jmp_Flag, Ctrl1_PC_Beq_Flag, Ctrl1_LUT_Write_En,
      Ctrl1_LUT_Load_Hi, Ctrl1_Reg_Write_En, Ctrl1_Reg_From_ALU,   
      Ctrl1_Reg_From_Mem, Ctrl1_Reg_From_Acc, Ctrl1_Acc_Write_En,     
      Ctrl1_Acc_From_Reg, Ctrl1_Acc_From_ALU, Ctrl1_Acc_From_Imm,   
      Ctrl1_Acc_Load_Hi, Ctrl1_Mem_Write_En;

logic [4:0]  Ctrl1_ALU_Opcode;
wire [9:0] PC1_ProgCtr_out;
wire [8:0] IR1_InstOut_out;
logic [7:0] RF1_DataOut_out;
logic [9:0] LUT1_Target_out;
logic [7:0] Acc1_DataOut_out;
logic [7:0] ALU1_Out_out;
logic ALU1_Zero_out;
logic [7:0] DM1_DataOut_out;
wire [4:0] op_mnemonic;

ProgCtr PC1 (.Reset(Reset), .clk(Clk), .jmp_flag(Ctrl1_PC_Jmp_Flag),
  .beq_flag(Ctrl1_PC_Beq_Flag), .Target(LUT1_Target_out), .ProgCtr(PC1_ProgCtr_out));

InstROM IR1 (.InstAddress(PC1_ProgCtr_out), .InstOut(IR1_InstOut_out));

LUT LUT1(.clk(Clk), .Reset(Reset), .Write_En(Ctrl1_LUT_Write_En), .Load_Hi(Ctrl1_LUT_Load_Hi),
  .Imm_in(IR1_InstOut_out[3:0]), .Acc_in(Acc1_DataOut_out), .Target(LUT1_Target_out));

Accumulator Accumulator1(.clk(Clk), .Reset(Reset), .Write_En(Ctrl1_Acc_Write_En),
  .From_Reg(Ctrl1_Acc_From_Reg), .From_Imm(Ctrl1_Acc_From_Imm), .From_ALU(Ctrl1_Acc_From_ALU),
  .Load_Hi(Ctrl1_Acc_Load_Hi), .RegInput(RF1_DataOut_out), .ALUInput(ALU1_Out_out),
  .Imm_in(IR1_InstOut_out[3:0]), .DataOut(Acc1_DataOut_out));

RegFile RF1 (.clk(Clk), .Reset(Reset), .Write_En(Ctrl1_Reg_Write_En),
  .from_ALU(Ctrl1_Reg_From_ALU), .from_Acc(Ctrl1_Reg_From_Acc), .from_Mem(Ctrl1_Reg_From_Mem),
  .address(IR1_InstOut_out[3:0]), .Mem_Input(DM1_DataOut_out), .Acc_Input(Acc1_DataOut_out),
  .ALU_Input(ALU1_Out_out), .DataOut(RF1_DataOut_out));

ALU ALU1 (.InputA(RF1_DataOut_out), .InputB(Acc1_DataOut_out), .OP(Ctrl1_ALU_Opcode),
  .Out(ALU1_Out_out), .Zero(ALU1_Zero_out));

DataMem DM1(.clk(Clk), .Reset(Reset), .WriteEn(Ctrl1_Mem_Write_En), .DataAddress(Acc1_DataOut_out),
  .DataIn(RF1_DataOut_out), .DataOut(DM1_DataOut_out));

Ctrl Ctrl1 (.Instruction(IR1_InstOut_out), .AccInput(Acc1_DataOut_out),
  .PC_Jmp_Flag(Ctrl1_PC_Jmp_Flag), .PC_Beq_Flag(Ctrl1_PC_Beq_Flag),
  .LUT_Write_En(Ctrl1_LUT_Write_En), .LUT_Read_En(Ctrl1_LUT_Read_En),
  .LUT_Load_Hi(Ctrl1_LUT_Load_Hi), .Reg_Write_En(Ctrl1_Reg_Write_En),
  .Reg_From_ALU(Ctrl1_Reg_From_ALU), .Reg_From_Mem(Ctrl1_Reg_From_Mem),
  .Reg_From_Acc(Ctrl1_Reg_From_Acc), .Acc_Write_En(Ctrl1_Acc_Write_En),
  .Acc_From_Reg(Ctrl1_Acc_From_Reg), .Acc_From_ALU(Ctrl1_Acc_From_ALU),
  .Acc_From_Imm(Ctrl1_Acc_From_Imm), .Acc_Load_Hi(Ctrl1_Acc_Load_Hi),
  .Mem_Write_En(Ctrl1_Mem_Write_En), .Ack(Ack),
  .ALU_Opcode(Ctrl1_ALU_Opcode), .op_mnemonic(op_mnemonic)
);

endmodule





