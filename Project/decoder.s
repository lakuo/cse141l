
SET_H 0000
SET_L 1101               
LD_LUT_L 0000                    
SET_L 0000
LD_LUT_H 0000                      // LUT[0] load the address of mem_block_for_loop: at line 13   
SET_H 0111
SET_L 0111             
LD_LUT_L 0001                      
SET_L 0001
LD_LUT_H 0001                     // LUT[1] load address of Done: at line 375
SET_H 0000
SET_L 0000
STA R0                              // i = 0 before loop
SET_H 0001                          // mem_block_for_loop:
SET_L 1110                          // set value to 30
CMP R0
BEQ 0001                            // if equal 30, branch to Done:
LDA R0
STA R15
SET_H 0001
SET_L 1110
ADD R15                             // R15 = R0 + 30
LDA R15
LDR R1                              // R1 = dataMem[R0 + 30];
SET_H 0000
SET_L 0001
ADD R15                             // R15 = R0 + 30 + 1
LDA R15
LDR R2                              // R2 = dataMem[R0 + 31]; 
LDA R2
STA R10                             // R10 = R2;
SET_H 0000
SET_L 0001
AND R10                             // R10 = R10 & 0b00000001;
LSL R10
LSL R10
LSL R10                             // R10 = R10 << 3;
LDA R1
STA R11                             // R11 = R1;
SET_H 0001
SET_L 0000
AND R11                             // R11 = R11 & 0b00010000;
LSR R11
LSR R11                             // R11 = R11 >> 2;
LDA R1
STA R12                             // R12 = R1;
SET_H 0000
SET_L 0100
AND R12                             // R12 = R12 & 0b00000100;
LSR R12                             // R12 = R12 >> 1;
LDA R1
STA R13                             // R13 = R1;
SET_H 0000
SET_L 0010
AND R13                             // R13 = R13 & 0b00000010;
LSR R13                             // R13 = R13 >> 1;
LDA R11
ORR R10                             // R10 = R10 | R11;
LDA R12 
ORR R10                             // R10 = R10 | R12;
LDA R13
ORR R10                             // R10 = R10 | R13;
LDA R10
STA R3
LDA R1
STA R4                              // R4 = R1;
SET_H 0000
SET_L 0001
AND R4                              // R4 = R4 & 00000001;
LDA R2
STA R15                             // R15 = R2;
SET_H 1111
SET_L 1110
AND R15                             // R15 = R15 & 0b11111110;
XOR_G R15                           
LDA R15
STA R10                             // R10 = ^(R15);
LDA R2
STA R15                             // R15 = R2;
SET_H 1111
SET_L 0000  
AND R15                             // R15 = R15 & 0b11110000;
XOR_G R15                           // R15 = ^(R15);
LDA R1
STA R14                             // R14 = R1;
SET_H 1110
SET_L 0000
AND R14                             // R14 = R14 & 0b11100000;
XOR_G R14                           // R14 = ^(R14);
LDA R14
XOR_B R15                            // R15 = R15 + R14;
XOR_G R15                           // R15 = ^(R15);
LDA R15
STA R11                             // R11 = R15;
LDA R2
STA R15                             // R15 = R2;
SET_H 1100
SET_L 1100                          
AND R15                             // R15 = R15 & 0b11001100;
XOR_G R15                           // R15 = ^(R15);
LDA R1
STA R14                             // R14 = R1;
SET_H 1100
SET_L 1000
AND R14                             // R14 = R14 & 0b11001000;
XOR_G R14                           // R14 = ^(R14)
LDA R14
XOR_B R15                            // R15 = R15 + R14;
XOR_G R15                           // R15 = ^(R15);
LDA R15
STA R12                             // R12 = R15;
LDA R2
STA R15                             // R15 = R2;
SET_H 1010
SET_L 1010  
AND R15                             // R15 = R15 & 0b10101010;
XOR_G R15                           // R15 = ^(R15)
LDA R1
STA R14                             // R14 = R1;
SET_H 1010
SET_L 1000
AND R14                             // R14 = R14 & 0b10101000;
XOR_G R14                           // R14 = ^(R14)
LDA R14                        
XOR_B R15                            // R15 = R15 + R14;
XOR_G R15                           // R15 = ^(R15);
LDA R15
STA R13                             // R13 = R15;
LSL R10
LSL R10
LSL R10                             // R10 << 3;
LSL R11
LSL R11                             // R11 << 2;
LSL R12                             // R12 << 1;
LDA R11
ORR R10                             // R10 = R10 | R11;
LDA R12
ORR R10                             // R10 = R10 | R12;
LDA R13
ORR R10                             // R10 = R10 | R13;
LDA R10
STA R5                              // R5 = R10;
LDA R1
STA R10                             // R10 = R1;
SET_H 1111
SET_L 1110
AND R10                             // R10 = R10 & 0b11111110
XOR_G R10                           // R10 = ^(R10);
LDA R2
STA R11                             // R11 = R2;
XOR_G R11                           // R11 = ^(R11);
LDA R11
XOR_B R10                             // R10 = R10 + R11;
XOR_G R10                           // R10 = ^(R10);
LDA R10
STA R6                              // R6 = R10;
LDA R3
STA R7                              // R7 = R3;
LDA R5 
XOR_B R7                            // R7 = R7 ^ R5;
LDA R4
STA R8                              // R8 = R4;
LDA R6
XOR_B R8                            // R8 = R8 ^ R6;
SET_H 1100
SET_L 0000
LD_LUT_L 0010                         
SET_L 0000
LD_LUT_H 0010                     // LUT[2] load the address of If_P0_equal: at line 192 
SET_H 1110
SET_L 0110
LD_LUT_L 0011
SET_L 0000
LD_LUT_H 0011                     // LUT[3] load the address of If_P0_not_equal: at line 230
SET_H 0010
SET_L 1111
LD_LUT_L 0100
SET_L 0001
LD_LUT_H 0100                     // LUT[4] load the address of If_P0_Done: at line 303
SET_H 0111
SET_L 0011
LD_LUT_L 0101
SET_L 0001
LD_LUT_H 0101                     // LUT[5] load the address of load_mem_Done: at line 371
SET_H 0000
SET_L 0000
STA R12
SET_H 0000
SET_L 0000                          // set value to 0
CMP R8                              // if(R8 == 0b00000000)
BEQ 0010                            // If euqal to 0, branch to If_P0_equal:
JMP 0011                            // else, branch to If_P0_not_equal:
SET_H 1101                          //If_P0_equal:
SET_L 0100
LD_LUT_L 0110                         
SET_L 0000
LD_LUT_H 0110                     // LUT[6] load the address of If_P8421_equal: at line 212  
SET_H 1101
SET_L 0101
LD_LUT_L 0111
SET_L 0000
LD_LUT_H 0111                     // LUT[7] load the address of If_P8421_not_equal: at line 213 
SET_H 1110
SET_L 0101
LD_LUT_L 1000
SET_L 0000
LD_LUT_H 1000                     // LUT[8] load the address of If_P8421_Done: at line 229
SET_H 0000
SET_L 0000                          // set value to 0
CMP R7                              // if(R7 == 0b00000000)
BEQ 0110                            // if equal, branch to If_P8421_equal:
JMP 0111                            // else, branch to If_P8421_not_equal:
JMP 1000                            // If_P8421_equal:   branch to If_P8421_Done: because nothing to do
SET_H 0000                          // If_P8421_not_equal:
SET_L 0000
STA R15
LDA R0
STR R15                             // dataMem[R0] = 00000000;
LDA R0
STA R14
SET_H 0000
SET_L 0001
ADD R14                             // R14 = R0 + 1
SET_H 1000
SET_L 0000
STA R15
LDA R14
STR R15                             // dataMem[R0+1] = 10000000;
JMP 0101                            // branch to load_mem_Done:
JMP 0100                            // If_P8421_Done:    branch to If_P0_Done: 
SET_H 0000                          // If_P0_not_equal:
SET_L 0001
STA R15                             // R15 = 00000001;
STA R12                             // R12 = 00000001;
SET_H 1111                         
SET_L 1110
LD_LUT_L 0110                         
SET_L 0000
LD_LUT_H 0110                     // LUT[6] load the address of If_R7_8_equal: at line 254
SET_H 0001
SET_L 0110
LD_LUT_L 0111
SET_L 0001
LD_LUT_H 0111                     // LUT[7] load the address of If_R7_8_not_equal: at line 278
SET_H 0010
SET_L 1110
LD_LUT_L 1000
SET_L 0001
LD_LUT_H 1000                     // LUT[8] load the address of If_R7_8_Done: at line 302
SET_H 0000
SET_L 1000                          // set value to 8
CMP_LS R7                           // if(R7 < 8)
BEQ 0110                            // if equal, branch to If_R7_8_equal:
JMP 0111                            // else, branch to If_R7_8_not_equal:
SET_H 0000                          // If_R7_8_equal:
SET_L 1011
LD_LUT_L 1001                       
SET_L 0001
LD_LUT_H 1001                     // LUT[9] load the address of 1_shifting_loop: at line 267  
SET_H 0001
SET_L 0011
LD_LUT_L 1010
SET_L 0001
LD_LUT_H 1010                     // LUT[10] load the address of 1_shifting_loop_Done: at line 275
SET_H 0000
SET_L 0000
STA R9                              // set j to 0 before looping
LDA R7                              // 1_shifting_loop:
CMP R9                              // for(j = 0; j < R7; j++)
BEQ 1010                            // if equal to R7, branch to 1_shifting_loop_Done:
LSL R15                             // R15 << 1;
SET_H 0000
SET_L 0001
ADD R9                              //  j = j + 1
JMP 1001                            // branch back to 1_shifting_loop: for looping
LDA R15                             // 1_shifting_loop_Done:
XOR_B R1                            // R1 = R1 ^ R15;
JMP 1000                            // finished, branch to If_R7_8_Done:
SET_H 0010                          // If_R7_8_not_equal:
SET_L 0011
LD_LUT_L 1001                       
SET_L 0001
LD_LUT_H 1001                     // LUT[9] load the address of 2_shifting_loop: at line 291   
SET_H 0010
SET_L 1011
LD_LUT_L 1010
SET_L 0001
LD_LUT_H 1010                     // LUT[10] load the address of 2_shifting_loop_Done: at line 299
SET_H 0000
SET_L 1000
STA R9                              // set j to 8 before looping
LDA R7                              // 2_shifting_loop:
CMP R9                              // for(j = 8; j < R7; j++)
BEQ 1010                            // if equal to R7, branch to 2_shifting_loop_Done:
LSL R15                             // R15 << 1;
SET_H 0000
SET_L 0001              
ADD R9                              // j = j + 1
JMP 1001                            // branch back to 2_shifting_loop: for looping
LDA R15                             // 2_shifting_loop_Done:
XOR_B R2                            // R2 = R2 ^ R15;
JMP 1000                            // finished, branch to If_R7_8_Done:
JMP 0100                            // If_R7_8_Done:   branch to If_P0_Done:
LDA R2                              // If_P0_Done:
STA R13                             // R13 = R2;
LSL R13
LSL R13
LSL R13                             // R13 << 3;
SET_H 1111
SET_L 0000
AND R13                             // R13 = R13 & 0b11110000;
LDA R1
STA R14                             // R14 = R1;
LSR R14
LSR R14
LSR R14
LSR R14                             // R14 = R14 >> 4;
SET_H 0000
SET_L 1110
AND R14                             // R14 = R14 & 0b00001110;
LDA R1
STA R15                             // R15 = R1;
LSR R15
LSR R15
LSR R15                             // R15 = R15 >> 3;
SET_H 0000
SET_L 0001                          // R15 = R15 & 0b00000001;
AND R15
LDA R13
STA R10                             // R10 = R13;
LDA R14
ORR R10                             // R10 = R10 | R14;
LDA R15
ORR R10                             // R10 = R10 | R15;
LDA R2
STA R11                             // R11 = R2;
LSR R11
LSR R11
LSR R11
LSR R11
LSR R11                             // R11 = R11 >> 5;
SET_H 0000
SET_L 0111
AND R11                             // R11 = R11 & 0b00000111;
SET_H 0110
SET_L 0111
LD_LUT_L 1011
SET_L 0001
LD_LUT_H 1011                     // LUT[11] load the address of If_Error_equal: at line 359
SET_H 0110
SET_L 1010
LD_LUT_L 1100
SET_L 0001
LD_LUT_H 1100                     // LUT[12] load the address of If_Error_equal_Done: at line 362
SET_H 0000
SET_L 0001
CMP R12                             // if(R12 == 0b00000001)
BEQ 1011                            // if equal to 1, branch to If_Error_equal:
JMP 1100                            // else, branch to If_Error_equal_Done:
SET_H 0100                          // If_Error_equal:
SET_L 0000
ORR R11                             // R11 = R11 | 0b01000000;
LDA R0                              // If_Error_equal_Done:
STR R10                             // dataMem[R0] = R10;
LDA R0
STA R15
SET_H 0000
SET_L 0001
ADD R15
LDA R15
STR R11                             // dataMem[R0+1] = R11;
SET_H 0000                          // load_mem_Done:     
SET_L 0010
ADD R0
JMP 0000
HLT 0000                            // Done: