//initialize variables
SET_H 0010
SET_L 0000
STA R0                              // R0 = 32, points to pattern
SET_L 0001
STA R1                              // R1 = 33, points to numOccurrences
SET_L 0010
STA R2                              // R2 = 34, points to numByteOccurrences
SET_L 0011
STA R3                              // R3 = 35, points to numTotalOccurrences
SET_L 0000
SET_H 0000
STA R4                              // i, data mem pointer R4
STA R5                              // j, R5
STA R6                              // k, R6
STA R7                              // byte flag, R7
STA R8                              // shift offset, R8
LDA R0
LDR R9                              // R9 = MEM[32]
SET_H 1111
SET_L 1000
AND R9                              // R9 = pattern value
SET_H 1111
SET_L 1000                          // R10: empty
STA R11                             // R11: left chop value, R12: empty, R13: left part, R14: right part. R15: check target
SET_H 0000
SET_L 0000
STA R12
LDA R1
STR R12                             // numOccurrences = 0
LDA R2
STR R12                             // numByteOccurrences = 0
LDA R3
STR R12                             // numTotalOccurrences = 0

// Set up look-up table addresses for highest level
SET_H 1001
SET_L 0001
LD_LUT_L 0000
SET_L 0001
LD_LUT_H 0000                       // LUT[0] points to Done at line 401
SET_H 0010
SET_L 1110
LD_LUT_L 0001
SET_L 0000
LD_LUT_H 0001                       // LUT[1] points to mem_block_for_loop at line 46
SET_H 0000
SET_L 0000
STA R4                              // Set i=0 and loop through mem_block_for_loop
LDA R0

// mem_block_for_loop:
CMP R4                              // comparison for if we've done 32 iterations yet
BEQ 0000                            // if so, jump to Done
SET_H 0000
SET_L 0000
STA R7                              // set byte flag = 0
SET_H 0100
SET_L 1000
LD_LUT_L 0010
SET_L 0000
LD_LUT_H 0010                       // LUT[2] points to index_if_equal at line 72
SET_H 1100
SET_L 0101
LD_LUT_L 0011
SET_L 0000
LD_LUT_H 0011                       // LUT[3] points to index_if_not_equal at line 197
SET_H 1000
SET_L 1101
LD_LUT_L 0100
SET_L 0001
LD_LUT_H 0100                       // LUT[4] points to index_if_Done at line 397
SET_H 0001                          // Check if i has reached the last index, 31
SET_L 1111
CMP R4
BEQ 0010                            // if(i == lastIndex), branch to index_if_equal:
JMP 0011                            // else branch to index_if_not_equal:

// index_if_equal:
SET_H 0101
SET_L 0101
LD_LUT_L 0101
SET_L 0000
LD_LUT_H 0101                       // LUT[5] points to J_1_Loop at line 85
SET_H 1100
SET_L 0100
LD_LUT_L 0110
SET_L 0000
LD_LUT_H 0110                       // LUT[6] points to J_1_Loop_Done at line 196
SET_H 0000
SET_L 0000
STA R5                              // j = 0 before looping

// J_1_Loop:
SET_H 0000
SET_L 0100                          // set acc = 4
CMP R5
BEQ 0110                            // branch to J_1_Loop_Done if done
LDA R5
STA R8                              // shiftoffset = j
LDA R4
LDR R13                             // leftPart = dataMem[i];
SET_H 0110
SET_L 1010
LD_LUT_L 0111
SET_L 0000
LD_LUT_H 0111                       // LUT[7] points to K_1_Loop at line 106
SET_H 0111                           
SET_L 0010
LD_LUT_L 1000
SET_L 0000
LD_LUT_H 1000                       // LUT[8] points to K_1_Loop_Done at line 114
SET_H 0000
SET_L 0000
STA R6                              // k = 0 before looping

// K_1_Loop: (leftshifts the currently examined block of memory by shiftoffset)
LDA R8                              // set accum to shiftoffset
CMP R6
BEQ 1000                            // if equal branch to K_1_Loop_Done:
LSL R13                             // leftPart = leftPart << 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 0111                            // jump back to K_1_Loop for looping

// K_1_Loop_Done:
SET_H 1111
SET_L 1000
STA R15
LDA R13
AND R15                             // checkTarget = leftPart & chopValue;
SET_H 1000
SET_L 1010
LD_LUT_L 1001
SET_L 0000
LD_LUT_H 1001                       // LUT[9] points to 1_check_if_equal at line 138
SET_H 1100
SET_L 0000
LD_LUT_L 1010
SET_L 0000
LD_LUT_H 1010                       // LUT[10] points to 1_check_if_Done at line 192
LDA R15
STA R12
LDA R9
XOR_B R12                           // R12 = R15 ^ R9 = checkTarget ^ patternValue
SET_H 0000
SET_L 0000
CMP R12                             // if(checkTarget ^ patternValue) == 0b00000000
BEQ 1001                            // if equal branch to 1_check_if_equal
JMP 1010                            // direct branch to 1_check_if_not_equal

// 1_check_if_equal:
SET_H 1001
SET_L 1001
LD_LUT_L 1011
SET_L 0000
LD_LUT_H 1011                       // LUT[11] points to 1_1_if_equal at line 153
SET_H 1010
SET_L 0000
LD_LUT_L 1100
SET_L 0000
LD_LUT_H 1100                       // LUT[12] points to 1_1_if_Done at line 160
SET_H 0000
SET_L 0100                          // acc = 4
CMP_LS R8                           // if(shiftOffset < 4) verifies if this is within a byte boundary or across byte boundaries
BEQ 1011                            // if equal, branch to 1_1_if_equal
JMP 1100                            // if not equal, branch to 1_1_if_Done

// 1_1_if_equal: (increments numOccurrences by 1, then stores it back)
LDA R1
LDR R10 
SET_H 0000
SET_L 0001
ADD R10 
LDA R1
STR R10                             // numOccurrences += 1;

// 1_1_if_done: (verifies if we should increment numByteOccurrences)
SET_H 1010
SET_L 1111
LD_LUT_L 1011
SET_L 0000
LD_LUT_H 1011                       // LUT[11] points to 1_2_if_equal at line 175
SET_H 1011
SET_L 1001
LD_LUT_L 1100
SET_L 0000
LD_LUT_H 1100                       // LUT[12] points to 1_2_if_Done at line 185
SET_H 0000
SET_L 0000
CMP R7                              // if(byteFlag == 0)
BEQ 1011                            // branch to 1_2_if_equal if equal:
JMP 1100                            // else branch to 1_2_if_Done:

// 1_2_if_equal:
SET_H 0000
SET_L 0001
STA R7                              // byteFlag = 1 so we don't flag the same byte in occurrences again
LDA R2
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R2
STR R10                             // numByteOccurrences += 1;

// 1_2_if_Done: (regardless of the previous branches, we still increment total occurrences)
LDA R3
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R3
STR R10                             // numTotalOccurrences += 1;

// 1_check_if_Done:
SET_H 0000
SET_L 0001
ADD R5                              // J = J + 1
JMP 0101                            // branch back to J_1_Loop for looping

// J_1_Loop_Done:
JMP 0100                            // branch to index_if_Done

// index_if_not_equal:
SET_H 1101
SET_L 0010
LD_LUT_L 0101
SET_L 0000
LD_LUT_H 0101                       // LUT[5] points to J_2_Loop at line 210
SET_H 1000
SET_L 1100
LD_LUT_L 0110
SET_L 0001
LD_LUT_H 0110                       // LUT[6] points to J_2_Loop_Done at line 396
SET_H 0000
SET_L 0000
STA R5

// J_2_Loop:
SET_H 0000
SET_L 1000
CMP R5                              // for(j = 0; j < 8; j++)
BEQ 0110                            // if finished, branch to J_2_Loop_Done
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
LD_LUT_L 0111
SET_L 0000
LD_LUT_H 0111                       // LUT[7] points to K_2_left_Loop at line 241
SET_H 1111
SET_L 1001
LD_LUT_L 1000
SET_L 0000
LD_LUT_H 1000                       // LUT[8] points to K_2_Left_Loop_Done at line 249
SET_H 0000
SET_L 0000
STA R6                              // K = 0

// K_2_left_loop: (leftshifts leftpart by shiftoffset)
LDA R8
CMP R6
BEQ 1000                            // if equal branch to K_2_Left_Loop_Done:
LSL R13                             // leftPart = leftPart << 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 0111                            // branch back to K_2_left_Loop: for looping

// K_2_Left_Loop_Done:
SET_H 0000
SET_L 0101
LD_LUT_L 0111
SET_L 0001
LD_LUT_H 0111                       // LUT[7] points to K_2_Right_Loop at line 261
SET_H 0000
SET_L 1110
LD_LUT_L 1000
SET_L 0001
LD_LUT_H 1000                       // LUT[8] points to K_2_Right_Loop_Done at line 270
LDA R8
STA R6                              // k = shiftOffset

// K_2_Right_Loop:
SET_H 0000
SET_L 1000
CMP R6
BEQ 1000
LSR R14                             // rightPart = rightPart >> 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 0111                            // branch back to K_2_Right_Loop: for looping

// K_2_Right_Loop_Done:
SET_H 0001
SET_L 1111
LD_LUT_L 0111
SET_L 0001
LD_LUT_H 0111                       // LUT[7] points to 2_LeftChop_If_Equal at line 287
SET_H 0011
SET_L 0101
LD_LUT_L 1000
SET_L 0001
LD_LUT_H 1000                       // LUT[8] points to 2_LeftChop_If_Done at line 309
SET_H 0000
SET_L 0011
STA R12
LDA R8
CMP_LS R12
BEQ 0111
JMP 1000

// 2_LeftChop_If_Equal:
SET_H 0010
SET_L 1100
LD_LUT_L 1001
SET_L 0001
LD_LUT_H 1001                       // LUT[9] points to K_2_LeftChop_Loop at line 300
SET_H 0011
SET_L 0100
LD_LUT_L 1010
SET_L 0001
LD_LUT_H 1010                       // LUT[10] points to K_2_LeftChop_Loop_Done at line 308
SET_H 0000
SET_L 0011
STA R6                              // k = 3

// K_2_LeftChop_Loop:
LDA R8
CMP R6
BEQ 1010                            // if equal, branch to K_2_LeftChop_Loop_Done
LSL R11                             // leftChopValue = leftChopValue << 1;
SET_H 0000
SET_L 0001
ADD R6                              // k = k + 1
JMP 1001                            // branch back to K_2_LeftChop_Loop for looping

// K_2_LeftChop_Loop_Done:
JMP 1000                            // branch to 2_LeftChop_If_Done

// 2_LeftChop_If_Done:
SET_H 1111
SET_L 1000
AND R14                             // rightPart = rightPart & chopValue;
LDA R11
AND R13                             // leftPart = leftPart & leftChopValue;
LDA R13
STA R15
LDA R14
ORR R15                             // checkTarget = leftPart | rightPart;
SET_H 0101
SET_L 0001
LD_LUT_L 0111
SET_L 0001
LD_LUT_H 0111                       // LUT[7] points to 2_Check_If_Equal at line 337
SET_H 1000
SET_L 1000
LD_LUT_L 1000
SET_L 0001
LD_LUT_H 1000                       // LUT[8] points to 2_Check_If_Done at line 392
LDA R9
STA R12
LDA R15
XOR_B R12                           // checkTarget ^ patternValue
SET_H 0000
SET_L 0000
CMP R12                             // if((checkTarget ^ patternValue) == 0b00000000)
BEQ 0111                            // If equal, branch to 2_Check_If_Equal
JMP 1000                            // else branch to 2_Check_If_Done

// 2_Check_If_Equal:
SET_H 0110
SET_L 0000
LD_LUT_L 1001
SET_L 0001
LD_LUT_H 1001                       // LUT[9] load the address of 2_1_If_Equal: at line 352
SET_H 1000
SET_L 0001
LD_LUT_L 1010
SET_L 0001
LD_LUT_H 1010                       // LUT[10] load the address of 2_1_If_Done: at line 385
SET_H 0000
SET_L 0100
CMP_LS R8
BEQ 1001                            // if equal, branch to 2_1_If_Equal
JMP 1010                            // else branch to 2_1_If_Done

// 2_1_If_Equal:
LDA R1
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R1
STR R10                             // numOccurrences += 1;
SET_H 0111
SET_L 0110
LD_LUT_L 1011
SET_L 0001
LD_LUT_H 1011                       // LUT[11] points to 2_2_If_Equal at line 374
SET_H 1000
SET_L 0000
LD_LUT_L 1100
SET_L 0001
LD_LUT_H 1100                       // LUT[12] points to 2_2_If_Done at line 384
SET_H 0000
SET_L 0000
CMP R7
BEQ 1011                            // If equal, branch to 2_2_If_Equal
JMP 1100                            // else branch to 2_2_If_Done

// 2_2_If_Equal:
SET_H 0000
SET_L 0001
STA R7                              // byte flag = 1
LDA R2
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R2
STR R10                             // numByteOccurrences += 1;

// 2_2_If_Done:
JMP 1010                            // branch to 2_1_If_Done because nothing else to do

// 2_1_If_Done:
LDA R3
LDR R10
SET_H 0000
SET_L 0001
ADD R10
LDA R3
STR R10                             // numTotalOccurrences += 1;

// 2_check_If_Done:
SET_H 0000
SET_L 0001
ADD R5                              // J = J + 1
JMP 0101                            // branch back to J_2_Loop for looping

// J_2_Loop_Done:
JMP 0100                            // branch to index_if_Done

// index_If_Done:
SET_H 0000
SET_L 0001
ADD R4                              // i = i + 1
JMP 0001                            // branch back to mem_block_for_loop: for looping
HLT 0000                            // Done