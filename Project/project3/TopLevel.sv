module TopLevel(
  input        Reset,      // init/reset, active high
               Clk,        // clock -- posedge used inside design
  output logic Ack         // done flag from DUT
);

//	declaring connections

// Control Block Outputs
logic   Ctrl1_PC_Jmp_Flag,	      // To PC
        Ctrl1_PC_Beq_Flag,    
        Ctrl1_LUT_Write_En,       // To LUT
//        Ctrl1_LUT_Read_En,    
        Ctrl1_LUT_Load_Hi,        
        Ctrl1_Reg_Write_En,       // To Reg file
        Ctrl1_Reg_From_ALU,   
        Ctrl1_Reg_From_Mem,   
        Ctrl1_Reg_From_Acc,   
        Ctrl1_Acc_Write_En,	      // To Accumulator
        Ctrl1_Acc_From_Reg,   
        Ctrl1_Acc_From_ALU,   
        Ctrl1_Acc_From_Imm,   
        Ctrl1_Acc_Load_Hi,   
        Ctrl1_Mem_Write_En;       // To Data Memory
//        Ctrl1_Ack;                // Done Flag
logic  [4:0]  Ctrl1_ALU_Opcode;   // To ALU   		

// ProgCtr output
wire [ 9:0] PC1_ProgCtr_out;  // the program counter

// InstROM output
wire  [8:0] IR1_InstOut_out;  // the 9-bit opcode

// RegFile output
logic [7:0] RF1_DataOut_out; 


// LUT outputs
logic [9:0] LUT1_Target_out;  // Target of branch/jump

// Accumulator output
logic [7:0] Acc1_DataOut_out; // Content stored in the accumulator

// ALU outputs
logic [7:0] ALU1_Out_out;
logic       ALU1_Zero_out;        // Not in use right now

// Data Memory outputs
logic [7:0] DM1_DataOut_out;  // data out from data_memory


wire [4:0] op_mnemonic;


/* ---- modeules unit instanciation ---- */
ProgCtr PC1 ( // The PC Module
  .Reset      (Reset),
  .clk        (Clk),
  .jmp_flag   (Ctrl1_PC_Jmp_Flag),
  .beq_flag   (Ctrl1_PC_Beq_Flag),
  .Target     (LUT1_Target_out),
  .ProgCtr    (PC1_ProgCtr_out)
);


InstROM IR1 (
	.InstAddress(PC1_ProgCtr_out),
	.InstOut(IR1_InstOut_out)

);



LUT LUT1( // The LUT Module (to enable branching, i.e. jumping)
  .clk      (Clk), 
  .Reset    (Reset), 
  .Write_En (Ctrl1_LUT_Write_En), 
  .Load_Hi  (Ctrl1_LUT_Load_Hi),
  .Imm_in   (IR1_InstOut_out[3:0]),   // Immediate input directly from the 9-bit insn Opcode 
  .Acc_in   (Acc1_DataOut_out),       // Accumulator input  [7:0]
  .Target   (LUT1_Target_out)
);

Accumulator Accumulator1(
  .clk      (Clk), 
  .Reset    (Reset), 
  .Write_En (Ctrl1_Acc_Write_En), 
  .From_Reg (Ctrl1_Acc_From_Reg),
  .From_Imm (Ctrl1_Acc_From_Imm),
  .From_ALU (Ctrl1_Acc_From_ALU),
  .Load_Hi  (Ctrl1_Acc_Load_Hi),
  .RegInput (RF1_DataOut_out),   
  .ALUInput (ALU1_Out_out),
  .Imm_in   (IR1_InstOut_out[3:0]),
  .DataOut	(Acc1_DataOut_out)	
);

RegFile RF1 (
  .clk          (Clk),
  .Reset        (Reset),
  .Write_En     (Ctrl1_Reg_Write_En),
  .from_ALU     (Ctrl1_Reg_From_ALU),      // See example below on how 3 opcode bits
  .from_Acc     (Ctrl1_Reg_From_Acc),      // could address 16 registers...
  .from_Mem     (Ctrl1_Reg_From_Mem),      // mux above
  .address      (IR1_InstOut_out[3:0]),
  .Mem_Input    (DM1_DataOut_out),
  .Acc_Input    (Acc1_DataOut_out),
  .ALU_Input    (ALU1_Out_out),
  .DataOut      (RF1_DataOut_out)
);

ALU ALU1 (
	.InputA(RF1_DataOut_out),
	.InputB(Acc1_DataOut_out),
	.OP(Ctrl1_ALU_Opcode),
	.Out(ALU1_Out_out),
	.Zero(ALU1_Zero_out)
);

DataMem DM1(
  .clk          (Clk),
  .Reset        (Reset),
  .WriteEn      (Ctrl1_Mem_Write_En),
  .DataAddress  (Acc1_DataOut_out),
  .DataIn       (RF1_DataOut_out),
  .DataOut      (DM1_DataOut_out)
);

Ctrl Ctrl1 ( // Control decoder
  .Instruction    (IR1_InstOut_out),
  .AccInput			(Acc1_DataOut_out),
  .PC_Jmp_Flag    (Ctrl1_PC_Jmp_Flag),	   
  .PC_Beq_Flag    (Ctrl1_PC_Beq_Flag),
  .LUT_Write_En   (Ctrl1_LUT_Write_En),  	 
  .LUT_Read_En    (Ctrl1_LUT_Read_En),
  .LUT_Load_Hi   (Ctrl1_LUT_Load_Hi),  
  .Reg_Write_En   (Ctrl1_Reg_Write_En),   
  .Reg_From_ALU   (Ctrl1_Reg_From_ALU),  
  .Reg_From_Mem   (Ctrl1_Reg_From_Mem),  
  .Reg_From_Acc   (Ctrl1_Reg_From_Acc),  
  .Acc_Write_En   (Ctrl1_Acc_Write_En),     
  .Acc_From_Reg   (Ctrl1_Acc_From_Reg),  
  .Acc_From_ALU   (Ctrl1_Acc_From_ALU),  
  .Acc_From_Imm   (Ctrl1_Acc_From_Imm),  
  .Acc_Load_Hi    (Ctrl1_Acc_Load_Hi),  
  .Mem_Write_En   (Ctrl1_Mem_Write_En),    
  .Ack            (Ack),		    
  .ALU_Opcode     (Ctrl1_ALU_Opcode),
  .op_mnemonic    (op_mnemonic)
);





//Ctrl Ctrl1 ( // Control decoder
//  IR1_InstOut_out,
//  Acc1_DataOut_out,
//  Ctrl1_PC_Jmp_Flag,	   
//  Ctrl1_PC_Beq_Flag,
//  Ctrl1_LUT_Write_En,  	 
//  Ctrl1_LUT_Read_En,
//  Ctrl1_LUT_Load_Hi,  
//  Ctrl1_Reg_Write_En,   
//  Ctrl1_Reg_From_ALU,  
//  Ctrl1_Reg_From_Mem,  
//  Ctrl1_Reg_From_Acc,  
//  Ctrl1_Acc_Write_En,     
//  Ctrl1_Acc_From_Reg,  
//  Ctrl1_Acc_From_ALU,  
//  Ctrl1_Acc_From_Imm,  
//  Ctrl1_Acc_Load_Hi,  
//  Ctrl1_Mem_Write_En,    
//  Ack,		    
//  Ctrl1_ALU_Opcode,
//  op_mnemonic
//);
endmodule

