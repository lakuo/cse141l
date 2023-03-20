package Definitions;
     typedef enum logic [4:0] {
          ORR,        // 5'b00000 ( 0)
          XOR_B,      // 5'b00001 ( 1)
          XOR_G,      // 5'b00010 ( 2)
          AND,        // 5'b00011 ( 3)
          STR,        // 5'b00100 ( 4)
          LDR,        // 5'b00101 ( 5)
          STA,        // 5'b00110 ( 6)
          LDA,        // 5'b00111 ( 7)
          LD_LUT_L,   // 5'b01000 ( 8)
          LD_LUT_H,   // 5'b01001 ( 9)
          SET_L,      // 5'b01010 (10)
          SET_H,      // 5'b01011 (11)
          CMP,        // 5'b01100 (12)
          CMP_LS,     // 5'b01101 (13)
          LSL,        // 5'b01110 (14)
          LSR,        // 5'b01111 (15)
          ADD,        // 5'b10000 (16)
          BEQ,        // 5'b10001 (17)
          JMP,        // 5'b10010 (18)
          HLT,        // 5'b10011 (19)
   } op_mne;
endpackage // Definitions