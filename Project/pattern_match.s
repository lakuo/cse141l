
SET_H 0010
SET_L 0000
STA R0                        //patternIndex R0 ＝ 32
SET_L 0001
STA R1                        //numOccurIndex R1 = 33
SET_L 0010
STA R2                        //numByteIndex R2 = 34
SET_L 0011
STA R3                        //numTotalIndex R3 = 35
SET_L 0000
SET_H 0000
STA R4                        // i, data mem pointer R4
STA R5                        // j, R5
STA R6                        // k, R6
STA R7                        // byte flag, R7
STA R8                        // shift offset, R8
LDA R0
LDR R9
SET_H 1111
SET_L 1000
AND R9                        // pattern Value, R9
SET_H 1111
SET_L 1000                    // R10, empty
STA R11                       // R11, left chop value // R12, empty   // R13 left part   // R14 right part // R15 check target   
SET_H 0000
SET_L 0000
STA R12
LDA R1
STR R12
LDA R2
STR R12
LDA R3
STR R12
SET_H 1001
SET_L 0001                   
LUT_LOAD_L 0000                    
SET_L 0001
LUT_LOAD_H 0000                      // LUT[0] load the address of Done: at line 401
SET_H 0010
SET_L 1110   
LUT_LOAD_L 0001                      
SET_L 0000
LUT_LOAD_H 0001                     // LUT[1] load address of mem_block_for_loop: at line 46
SET_H 0000
SET_L 0000
STA R4                              // i = 0
LDA R0                              // mem_block_for_loop: for(i = 0; i < patternIndex; i++)
CMP R4                              // load pattern value and cmp i
BEQ 0000                            // if equal branch to Done:
SET_H 0000
SET_L 0000
STA R7                              // set byte flag = 0
SET_H 0100
SET_L 1000
LUT_LOAD_L 0010             
SET_L 0000
LUT_LOAD_H 0010                     // LUT[2] load the address of index_if_equal: at line 72
SET_H 1100
SET_L 0101
LUT_LOAD_L 0011
SET_L 0000
LUT_LOAD_H 0011                     // LUT[3] load the address of index_if_not_equal: at line 197
SET_H 1000
SET_L 1101
LUT_LOAD_L 0100
SET_L 0001
LUT_LOAD_H 0100                     // LUT[4] load the address of index_if_Done: at line 397
SET_H 0001
SET_L 1111                          // set acc to last index 31
CMP R4                              
BEQ 0010                            // if(i == lastIndex), brnach to index_if_equal:
JMP 0011                            // else brnach to the index_if_not_equal:
SET_H 0101                         // index_if_equal:
SET_L 0101
LUT_LOAD_L 0101
SET_L 0000
LUT_LOAD_H 0101                     // LUT[5] load the address of J_1_Loop: at line 85
SET_H 1100          
SET_L 0100
LUT_LOAD_L 0110
SET_L 0000
LUT_LOAD_H 0110                     // LUT[6] load the address of J_1_Loop_Done: at line 196
SET_H 0000
SET_L 0000                          
STA R5                              // j = 0 before looping
SET_H 0000                          // J_1_Loop:
SET_L 0100                          // set accum = 4
CMP R5                    
BEQ 0110                            // branch to J_1_Loop_Done if done
LDA R5                    
STA R8                              // shiftoffset = j
LDA R4                
LDR R13                             // leftPart = dataMem[i];
SET_H 0110                        
SET_L 1010
LUT_LOAD_L 0111
SET_L 0000
LUT_LOAD_H 0111                     // LUT[7] load the address of K_1_Loop: at line 106
SET_H 0111                           
SET_L 0010
LUT_LOAD_L 1000
SET_L 0000
LUT_LOAD_H 1000                     // LUT[8] load the address of K_1_Loop_Done: at line 114
SET_H 0000
SET_L 0000
STA R6                              // k = 0 before looping
LDA R8                              // K_1_Loop:   set accum to shiftoffset
CMP R6                              // 
BEQ 1000                            // if equal branch to K_1_Loop_Done:
LSL R13                             // leftPart = leftPart << 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 0111                            // jump back to K_1_Loop: for looping
SET_H 1111                          // K_1_Loop_Done:
SET_L 1000
STA R15
LDA R13
AND R15                             // checkTarget = leftPart & chopValue;
SET_H 1000                               
SET_L 1010
LUT_LOAD_L 1001
SET_L 0000
LUT_LOAD_H 1001                     // LUT[9] load the address of 1_check_if_equal: at line 138
SET_H 1100                              
SET_L 0000
LUT_LOAD_L 1010
SET_L 0000
LUT_LOAD_H 1010                     // LUT[10] load the address of 1_check_if_Done: at line 192
LDA R15
STA R12
LDA R9
XOR_B R12                           // R12 = ((checkTarget) ^ (patternValue))
SET_H 0000
SET_L 0000
CMP R12                             // if(((checkTarget) ^ (patternValue)) == 0b00000000)
BEQ 1001                            // if equal branch to 1_check_if_equal
JMP 1010                            // direct branch to 1_check_if_not_equal
SET_H 1001                          // 1_check_if_equal:
SET_L 1001
LUT_LOAD_L 1011
SET_L 0000
LUT_LOAD_H 1011                     // LUT[11] load the address of 1_1_if_equal: at line 153
SET_H 1010                             
SET_L 0000
LUT_LOAD_L 1100
SET_L 0000
LUT_LOAD_H 1100                     // LUT[12] load the address of 1_1_if_Done: at line 160
SET_H 0000
SET_L 0100                          // 4
CMP_LS R8                           // if(shiftOffset < 4)
BEQ 1011                            // branch to 1_1_if_equal: if euqal
JMP 1100                            // branch to 1_1_if_Done: if not equal 
LDA R1                              // 1_1_if_equal: 
LDR R10 
SET_H 0000
SET_L 0001
ADD R10 
LDA R1
STR R10                             // dataMem[numOccurIndex] = dataMem[numOccurIndex] + 0b00000001;
SET_H 1010                          // 1_1_if_Done:
SET_L 1111
LUT_LOAD_L 1011
SET_L 0000
LUT_LOAD_H 1011                     // LUT[11] load the address of 1_2_if_equal: at line 175
SET_H 1011                              
SET_L 1001
LUT_LOAD_L 1100
SET_L 0000
LUT_LOAD_H 1100                     // LUT[12] load the address of 1_2_if_Done: at line 185
SET_H 0000
SET_L 0000
CMP R7                              // if(byteFlag == 0)
BEQ 1011                            // branch to 1_2_if_equal if euqal:
JMP 1100                            // else branch to 1_2_if_Done: 
SET_H 0000                          // 1_2_if_equal:
SET_L 0001                          // 
STA R7                              // byteFlag = 1;
LDA R2
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R2
STR R10                             // dataMem[numByteIndex] = dataMem[numByteIndex] + 0b00000001;
LDA R3                              // 1_2_if_Done:
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R3
STR R10                             // dataMem[numTotalIndex] = dataMem[numTotalIndex] + 0b00000001;
SET_H 0000                          // 1_check_if_Done:
SET_L 0001          
ADD R5                              //J = J + 1
JMP 0101                            // branch back to J_1_Loop: for looping
JMP 0100                            // J_1_Loop_Done: branch to index_if_Done:
SET_H 1101                         // index_if_not_equal:
SET_L 0010
LUT_LOAD_L 0101
SET_L 0000
LUT_LOAD_H 0101                     // LUT[5] load the address of J_2_Loop: at line 210
SET_H 1000                              
SET_L 1100
LUT_LOAD_L 0110
SET_L 0001
LUT_LOAD_H 0110                     // LUT[6] load the address of J_2_Loop_Done: at line 396
SET_H 0000
SET_L 0000
STA R5
SET_H 0000                          // J_2_Loop:
SET_L 1000
CMP R5                              // for(j = 0; j < 8; j++)
BEQ 0110                            // branch to J_2_Loop_Done: if finsih
LDA R5
STA R8                              // shiftOffset = j;
LDA R4
LDR R13                             // leftPart = dataMem[i];
LDA R4
STA R12
SET_H 0000
SET_L 0001
ADD R12
LDA R12
LDR R14                             // rightPart = dataMem[i+1];
SET_H 1111
SET_L 1000
STA R11                             // leftChopValue = chopValue;
SET_H 1111                             
SET_L 0001
LUT_LOAD_L 0111
SET_L 0000
LUT_LOAD_H 0111                     // LUT[7] load the address of K_2_left_Loop: at line 241
SET_H 1111                               
SET_L 1001
LUT_LOAD_L 1000
SET_L 0000
LUT_LOAD_H 1000                     // LUT[8] load the address of K_2_Left_Loop_Done: at line 249
SET_H 0000
SET_L 0000
STA R6                              // K = 0
LDA R8                              // K_2_left_Loop:
CMP R6
BEQ 1000                            // if equal branch to K_2_Left_Loop_Done:
LSL R13                             // leftPart = leftPart << 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 0111                            // branch back to K_2_left_Loop: for looping
SET_H 0000                          // K_2_Left_Loop_Done:
SET_L 0101
LUT_LOAD_L 0111
SET_L 0001
LUT_LOAD_H 0111                     // LUT[7] load the address of K_2_Right_Loop: at line 261
SET_H 0000                              
SET_L 1110
LUT_LOAD_L 1000
SET_L 0001
LUT_LOAD_H 1000                     // LUT[8] load the address of K_2_Right_Loop_Done: at line 270
LDA R8
STA R6                              // k = shiftOffset
SET_H 0000                          // K_2_Right_Loop:
SET_L 1000
CMP R6
BEQ 1000
LSR R14                             // rightPart = rightPart >> 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 0111                            // branch back to K_2_Right_Loop: for looping
SET_H 0001                          // K_2_Right_Loop_Done:
SET_L 1111
LUT_LOAD_L 0111
SET_L 0001
LUT_LOAD_H 0111                     // LUT[7] load the address of 2_LeftChop_If_Equal: at line 287
SET_H 0011                              
SET_L 0101
LUT_LOAD_L 1000
SET_L 0001
LUT_LOAD_H 1000                     // LUT[8] load the address of 2_LeftChop_If_Done: at line 309
SET_H 0000                          
SET_L 0011
STA R12
LDA R8
CMP_LS R12
BEQ 0111
JMP 1000
SET_H 0010                          // 2_LeftChop_If_Equal: 
SET_L 1100
LUT_LOAD_L 1001
SET_L 0001
LUT_LOAD_H 1001                     // LUT[9] load the address of K_2_LeftChop_Loop: at line 300
SET_H 0011                             
SET_L 0100
LUT_LOAD_L 1010
SET_L 0001
LUT_LOAD_H 1010                     // LUT[10] load the address of K_2_LeftChop_Loop_Done: at line 308
SET_H 0000
SET_L 0011
STA R6                              // k = 3
LDA R8                              // K_2_LeftChop_Loop:
CMP R6
BEQ 1010                            // brnach to K_2_LeftChop_Loop_Done: if equal
LSL R11                             // leftChopValue = leftChopValue << 1;
SET_H 0000
SET_L 0001 
ADD R6                              // k = k + 1
JMP 1001                            // branch back to K_2_LeftChop_Loop: for looping
JMP 1000                            // K_2_LeftChop_Loop_Done: branch to 2_LeftChop_If_Done
SET_H 1111                          // 2_LeftChop_If_Done:
SET_L 1000
AND R14                             // rightPart = rightPart & chopValue;
LDA R11
AND R13                             // leftPart = leftPart & leftChopValue;
LDA R13
STA R15
LDA R14
ORR R15                           // checkTarget = leftPart | rightPart;
SET_H 0101                            
SET_L 0001
LUT_LOAD_L 0111
SET_L 0001
LUT_LOAD_H 0111                     // LUT[7] load the address of 2_Check_If_Equal: at line 337
SET_H 1000                             
SET_L 1000
LUT_LOAD_L 1000
SET_L 0001
LUT_LOAD_H 1000                     // LUT[8] load the address of 2_Check_If_Done: at line 392
LDA R9
STA R12
LDA R15
XOR_B R12                           // ((checkTarget) ^ (patternValue))
SET_H 0000
SET_L 0000
CMP R12                             // if(((checkTarget) ^ (patternValue)) == 0b00000000)
BEQ 0111                            // If equal, branch to 2_Check_If_Equal:
JMP 1000                            // else branch to 2_Check_If_Done:
SET_H 0110                          // 2_Check_If_Equal:              
SET_L 0000
LUT_LOAD_L 1001
SET_L 0001
LUT_LOAD_H 1001                     // LUT[9] load the address of 2_1_If_Equal: at line 352
SET_H 1000                           
SET_L 0001
LUT_LOAD_L 1010
SET_L 0001
LUT_LOAD_H 1010                     // LUT[10] load the address of 2_1_If_Done: at line 385
SET_H 0000
SET_L 0100
CMP_LS R8
BEQ 1001                            // branch to 2_1_If_Equal: if equal
JMP 1010                            // else branch to 2_1_If_Done:
LDA R1                              // 2_1_If_Equal:
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R1
STR R10                             // dataMem[numOccurIndex] = dataMem[numOccurIndex] + 0b00000001;
SET_H 0111                                     
SET_L 0110
LUT_LOAD_L 1011
SET_L 0001
LUT_LOAD_H 1011                     // LUT[11] load the address of 2_2_If_Equal: at line 374
SET_H 1000                              
SET_L 0000
LUT_LOAD_L 1100
SET_L 0001
LUT_LOAD_H 1100                     // LUT[12] load the address of 2_2_If_Done: at line 384
SET_H 0000
SET_L 0000
CMP R7
BEQ 1011                            // If equal, branch to 2_2_If_Equal:
JMP 1100                            // else branch to 2_2_If_Done:
SET_H 0000                          // 2_2_If_Equal:
SET_L 0001
STA R7                              // byte flag = 1
LDA R2                              
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R2
STR R10                             // dataMem[numByteIndex] = dataMem[numByteIndex] + 0b00000001;
JMP 1010                            // 2_2_If_Done:    branch to 2_1_If_Done because nothing else to do
LDA R3                              // 2_1_If_Done:
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R3
STR R10                             // dataMem[numTotalIndex] = dataMem[numTotalIndex] + 0b00000001;
SET_H 0000                          // 2_check_if_Done:
SET_L 0001          
ADD R5                              // J = J + 1
JMP 0101                            // branch back to J_2_Loop: for looping
JMP 0100                            // J_2_Loop_Done: branch to index_if_Done:
SET_H 0000                         //index_if_Done:
SET_L 0001
ADD R4                             // i = i + 1
JMP 0001                           // branch back to mem_block_for_loop: for looping
HLT 0000                           // Done: