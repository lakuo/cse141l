import Definitions::*;

module Ctrl (
  input  [8:0] Instruction,          // machine code input
  input  [7:0] AccInput,             // Accumulator for branch
  output logic  PC_Jmp_Flag,         // PC Control
                PC_Beq_Flag,
                LUT_Write_En,        // LUT control
                LUT_Read_En,
                LUT_Load_Hi,
                Reg_Write_En,        // RegFile control
                Reg_From_ALU,
                Reg_From_Mem,
                Reg_From_Acc,
                Acc_Write_En,        // Accumumulator control
                Acc_From_Reg,
                Acc_From_ALU,
                Acc_From_Imm,
                Acc_Load_Hi,
                Mem_Write_En,        // Mem control
                Ack,                 // DONE flag
  output logic [4:0] ALU_Opcode,
  output logic [4:0] op_mnemonic
);

task zero_init_flags;  // initialize all control flags to zero
  PC_Jmp_Flag = 0;  PC_Beq_Flag = 0;
  LUT_Write_En = 0; LUT_Read_En = 0; LUT_Load_Hi = 0;
  Reg_Write_En = 0; Reg_From_ALU = 0; Reg_From_Mem = 0; Reg_From_Acc = 0;
  Acc_Write_En = 0; Acc_From_Reg = 0; Acc_From_ALU = 0; Acc_From_Imm = 0; Acc_Load_Hi = 0;
  Mem_Write_En = 0; Ack = &Instruction; ALU_Opcode = 5'b0;
endtask

always_comb begin
  zero_init_flags;

  case(Instruction[8:4])
    AND:        begin ALU_Opcode = 5'b00000;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
    ORR:        begin ALU_Opcode = 5'b00001;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
    XOR_B:      begin ALU_Opcode = 5'b00010;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
    XOR_G:      begin ALU_Opcode = 5'b00011;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
    ADD:        begin ALU_Opcode = 5'b00100;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
	  STR:        begin                                 Mem_Write_En = 1;                     end
    LDR:        begin                                 Reg_Write_En = 1;  Reg_From_Mem = 1;  end
    CMP:        begin ALU_Opcode = 5'b00111;          Acc_Write_En = 1;  Acc_From_ALU = 1;  end
    STA:        begin                                 Reg_Write_En = 1;  Reg_From_Acc = 1;  end
    LDA:        begin                                 Acc_Write_En = 1;  Acc_From_Reg = 1;  end
	  CMP_LS:     begin ALU_Opcode = 5'b01011;          Acc_Write_En = 1;  Acc_From_ALU = 1;  end
    SHL:        begin ALU_Opcode = 5'b01100;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
    SHR:        begin ALU_Opcode = 5'b01101;          Reg_Write_En = 1;  Reg_From_ALU = 1;  end
    SET_H:      begin Acc_Load_Hi = 1;                Acc_Write_En = 1;  Acc_From_Imm = 1;  end
    SET_L:      begin Acc_Load_Hi = 0;                Acc_Write_En = 1;  Acc_From_Imm = 1;  end
    LD_LUT_H:   begin LUT_Load_Hi = 1;                LUT_Write_En = 1;                     end
    LD_LUT_L:   begin LUT_Load_Hi = 0;                LUT_Write_En = 1;                     end
    BEQ:        begin PC_Beq_Flag = AccInput == 8'b1; LUT_Read_En = 1;                      end 
    JMP:        begin PC_Jmp_Flag = 1;                LUT_Read_En = 1;                      end
    HLT:        begin Ack = 1;                                                              end
    default: zero_init_flags; 
  endcase
end

`ifndef __ICARUS__
always_comb
  op_mnemonic = op_mne'(ALU_Opcode);            // displays operation name in waveform viewer
`endif

endmodule
