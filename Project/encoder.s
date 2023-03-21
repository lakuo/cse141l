// Store "target" line into LUT
// This marks the beginning of the execution of the program
    SET_H 0000
    SET_L 1001     # acc = 10
    LD_LUT_L 0000  # LUT[0] = acc

// Make R13 and R14 read and write pointers respectively
    SET_H 0000
    SET_L 0000
    STA R13        # R13 = 0
    SET_H 0001
    SET_L 1110
    STA R14        # R14 = 30

// Beginning of computation
// Load MEM[0] and MEM[1] into R0 and R1
    LDA R13        # acc = R13 = 0
    LDR R0         # R1 = MEM[acc] = MEM[0] = b8 b7 b6 b5 b4 b3 b2 b1
    SET_H 0000
    SET_L 0001     # acc = 1 (Used to index MEM[1])
    ADD R13        # R13 += acc => R13 += 1 => R13 = 1
    LDA R13        # acc = R13 = 1
    LDR R1         # R1 = MEM[acc] = MEM[1] = 0 0 0 0  0 b11 b10 b9

                   # R11 is reserved for writing to MEM[30]
                   # R12 is reserved for writing to MEM[31]
    SET_H 0000                                            
    SET_L 0001     # acc = 1 (Used to index MEM[1])
    ADD R13        # R13 += 1 = 2      Now R13 addr is ready to use in the next iter

// Compute P8 = ^(b11:b5)
    LDA R1         # acc = R1 = MEM[1]         ok
    STA R3         # R3 = acc = R1 = MEM[1] = 0 0 0 0  0 b11 b10 b9   = 0000_0111 ok
    LDA R0         # acc = R0 = MEM[0] 
    STA R2         # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1 = 0101_0101 ok
    
    XOR_G R3    # R3 = ^(R3[7:0]) = ^(b11, b10, b9) = 0000_0001    ok
    SET_H 1111      # acc = 1111_xxxx
    SET_L 0000      # acc = 1111_0000 (mask to extract b8:b5)      ok
    AND R2      # R2 = R2 & acc = b8 b7 b6 b5  0 0 0 0  = 0101_0000 ok
    
    XOR_G R2    # R2 = ^(R2[7:0]) = ^(b8, b7, b6, b5) = 0000_0000  ok
    LDA R2          # acc = R2 = ^(b8, b7, b6, b5)  ok
    XOR_B R3    # R3 = R3 ^ acc = ^(b11, b10, b9, b8, b7, b6, b5) = 0 0 0 0 | 0 0 0 [P8] = 0000_0001 ok
    LDA R3          # acc = R3 = 0 0 0 0 | 0 0 0 [P8]           ok
    ORR R12     # R12 = R12 | acc = 0 0 0 0 | 0 0 0 [P8]  

// 2.2 Compute P4 = ^(b11:b9, b8, b4, b3, b2)
    LDA R1          # acc = R1 = MEM[1]
    STA R3      # R3 = acc = R1 = MEM[1] = 0 0 0 0  0 b11 b10 b9
    LDA R0          # acc = R0 = MEM[0]
    STA R2      # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1

    XOR_G R3    # R3 = ^(R3[7:0]) = ^(b11, b10, b9)
    SET_H 1000      # acc = 1000_xxxx
    SET_L 1110      # acc = 1000_1110 (mask to extract b8, b4, b3, b2)
    AND R2      # R2 = R2 & acc = b8 0 0 0 | b4 b3 b2 0
    XOR_G R2    # R2 = ^(R2[7:0]) = ^(b8, b4, b3, b2)
    LDA R2          # acc = R2 = ^(b8, b4, b3, b2)
    XOR_B R3    # R3 = R3 ^ acc = ^(b11, b10, b9, b8, b4, b3, b2) = 0 0 0 0 | 0 0 0 [P4]
    LSL R3 
    LSL R3 
    LSL R3 
    LSL R3      # R3 = R3 << 4 = 0 0 0 [P4] | 0 0 0 0 
    LDA R3         # acc = R3 = 0 0 0 [P4] | 0 0 0 0 
    ORR R11     # R11 = R11 ^ acc = 0 0 0 [P4] | 0 0 0 0        Corretc up to now

// 2.3 Compute P2 = ^(b11, b10, b7, b6, b4, b3, b1) 
    LDA R1          # acc = R1 = MEM[1]
    STA R3      # R3 = acc = R1 = MEM[1] = 0 0 0 0  0 b11 b10 b9 = 0000_0101
    LDA R0          # acc = R0 = MEM[0]
    STA R2      # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1

    SET_H 0000     
    SET_L 0110     # acc = 0000_0110  (mask to extract (b11, b10))
    AND R3      # R3 = R3 & acc = 0 0 0 0 | 0 b11 b10 0  = 0000_0100

    XOR_G R3    # R3 = ^(R3[7:0]) = ^(b11^b10) = 0000_0001
    SET_H 0110    
    SET_L 1101     # acc = 0110_1101  (mask to extract ((b7,b6, b4,b3, b1)))    
    AND R2      # R2 = R2 & acc = 0 b7 b6 0 | b4 b3 0 b1 = 0100_0101
    XOR_G R2    # R2 = ^(R2[7:0]) = ^(b7, b6, b4, b3, b1) = 1

    LDA R2          # acc = R2 = ^(b7, b6, b4, b3, b1) 
    XOR_B R3    # R3 = R3 ^ acc = ^(b11, b10)^(b7, b6, b4, b3, b1) = 0 0 0 0 | 0 0 0 [P2]   = 0

    SET_H 0000
    SET_L 0001      # acc = 0000_0001 (mask to extract R3 last bit)
    AND R3          # extract last bit of R3
    LSL R3
    LSL R3      # R3 = R3 << 2 = 0 0 0 0 | 0 [P2] 0 0
    LDA R3         # acc = R3 = 0 0 0 0 | 0 [P2] 0 0
    ORR R11     # R11 = R11 ^ acc = 0 0 0 [P4] | 0 [P2] 0 0 
    
// 2.4 Compute P1 = ^(b11, b9 , b7, b5, b4, b2, b1)
    LDA R1          # acc = R1 = MEM[1]
    STA R3      # R3 = acc = R1 = MEM[1] = 0 0 0 0  0 b11 b10 b9
    LDA R0          # acc = R0 = MEM[0]
    STA R2      # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1

    SET_H 0000     
    SET_L 0101      # acc = 0000_0101 (mask to extract b11, b9)
    AND R3      # R3 = R3 & acc = 0 0 0 0 | 0 b11 0 b9
    XOR_G R3    # R3 = ^(b11,b9)
    SET_H 0101     
    SET_L 1011     # acc = 0101_1011 (mask to extract (b7, b5, b4, b2, b1))
    AND R2      # R2 = 0 b7 0 b5 | b4 0 b2 b1
    XOR_G R2    # R2 = ^(b7, b5, b4, b2, b1)
    
    LDA R2          # acc = R2 = ^(b7, b5, b4, b2, b1)
    XOR_B R3    # R3 = R3 ^ acc =  ^(b11,b9)^(b7, b5, b4, b2, b1) = 0 0 0 0 | 0 0 0 P[1]
    LSL R3      # R3 = R3 << 1 = 0 0 0 0 | 0 0 P[1] 0
    LDA R3          # acc = R3 = 0 0 0 0 | 0 0 P[1] 0
    ORR R11     # R11 = R11 ^ acc = 0 0 0 [P4] | 0 [P2] P[1] 0 
    
// 2.5 Compute P16
    LDA R1          # acc = R1 = MEM[1]
    STA R3      # R3 = acc = R1 = MEM[1] = 0 0 0 0  0 b11 b10 b9
    LDA R0          # acc = R0 = MEM[0]
    STA R2      # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1

    XOR_G R3    # R3 = ^(b11:b9)
    XOR_G R2    # R2 = ^(b8:b1)
    LDA R2          # acc = R2 = ^(b8:b1)
    XOR_B R3    # R3 = R3 ^ acc = ^(b11:b9)^(b8:b1)

    LDA R12         # acc = R12 = 0 0 0 0 | 0 0 0 [P8]
    XOR_B R3    # R3 = R3 ^ acc = P8^(b11:b9)^(b8:b1)
    LDA R11         # acc = R11 = 0 0 0 [P4] | 0 [P2] P[1] 0 
    STA R2      # R2 = acc = 0 0 0 [P4] | 0 [P2] P[1] 0 
    XOR_G R2    # R2 = ^(P4, P2, P1)
    LDA R2          # acc = R2 = ^(P4, P2, P1)
    XOR_B R3    # R3 = R3 ^ R2 = ^(P4, P2, P1)^P8^(b11:b9)^(b8:b1) = 0 0 0 0 | 0 0 0 [P16]
    LDA R3          # acc = R3 = 0 0 0 0 | 0 0 0 [P16]
    ORR R11     # R11 = R11 ^ acc = 0 0 0 [P4] | 0 [P2] [P1] [P16] 
    
// 2.6 Construct R11, R12       // R12 =  0 0 0 0  | 0 0 0 P8;  R11 =  0 0 0 P4 | 0 P2 P1 P16
    LSL R1
    LSL R1
    LSL R1
    LSL R1
    LSL R1      # R1 = R1 << 5 = b11 b10 b9 0   0 0 0 0
    LDA R1          # acc = R1 = b11 b10 b9 0   0 0 0 0
    ORR R12     # R12 = R12 | acc = b11 b10 b9 0 | 0 0 0 P8

    LDA R0          # acc = R0 = MEM[0]
    STA R2      # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1
    SET_H 1111     # acc = 1111_XXXX
    SET_L 0000     # acc = 1111_XXXX (mask to extract b8:b5)
    AND R2      # R2 = R2 ^ acc = b8 b7 b6 b5 | 0 0 0 0
    LSR R2
    LSR R2
    LSR R2      # R2 = R2 >> 3 = 0 0 0 b8 | b7 b6 b5 0
    LDA R2          # acc = R2 = 0 0 0 b8 | b7 b6 b5 0
    ORR R12     # R12 = R12 | acc = b11 b10 b9 b8 | b7 b6 b5 P8     

    LDA R0          # acc = R0 = MEM[0]
    STA R2      # R2 = acc = R0 = MEM[0] = b8 b7 b6 b5  b4 b3 b2 b1
    SET_H 0000     # acc = 0000_XXXX
    SET_L 1110     # acc = 0000_1110 (mask to extract b4:b2)
    AND R2      # R2 = R2 ^ acc = 0 0 0 0 | b4 b3 b2 0
    LSL R2
    LSL R2
    LSL R2
    LSL R2      # R2 = R2 << 4 = b4 b3 b2 0 | 0 0 0 0
    LDA R2          # acc = R2 = b4 b3 b2 0 | 0 0 0 0
    ORR R11     # R11 = b4 b3 b2 P4 | 0 P2 P1 P16
    
    SET_H 0000     # acc = 0000_XXXX
    SET_L 0001     # acc = 0000_0001 (mask to extrac b1)  
    AND R0      # R0 = R0 & acc = 0 0 0 0 | 0 0 0 b1
    LSL R0
    LSL R0
    LSL R0      # R0 = R0 << 3 = 0 0 0 0 | b1 0 0 0     
    LDA R0          # acc = R0 = 0 0 0 0 | b1 0 0 0  
    ORR R11     # R11 = b4 b3 b2 P4 | b1 P2 P1 P16

//3.1 Write Data Bits in R11, R12 to MEM[30], MEM[31]
    LDA R14         # acc = R14 = 30
    STR R11     # MEM[acc] = MEM[R14] = MEM[30] = R11 = b4 b3 b2 [P4] | b1 [P2] [P1] [P16]
    SET_H 0000
    SET_L 0001      # acc = 1
    ADD R14     # R14 += 1 = 31  
    LDA R14         # acc = R14 = 31
    STR R12     # MEM[acc] = MEM[R14] = MEM[31] = R12 = b11 b10 b9 b8 | b7 b6 b5 [P8]

    SET_H 0000
    SET_L 0001      # acc = 1
    ADD R14     # R14 += 1 = 32     Now R14 addr is ready to use in the next iter.

// 3.2 Clear R11, R12
    SET_H 0000
    SET_L 0000
    STA R11     // R11 = 0
    STA R12     // R12 = 0

//4. Branch condition: Branch to "Target" if R13 < 30
    SET_H 0001
    SET_L 1110      # acc = 30
    CMP_LS R13      # acc = R13 < 30 ? 1:0
    BEQ 0000    # if (acc=1): Branch to LUT[0]
    HLT         # DONE

//FIXME:
    // 1) Cannot correctly handle consequetive encoding
//  @ SET_H 0000      //op14
//  @ SET_L 0001      //op15
//  @ ADD R13         # op 4 R13 += 1 = 1
//  @ SET_H 0000
//  @ SET_L 0100      # acc = 4
//  @ CMP_LS R13      # acc = R13 < 30 ? 1:0      op 11
//  @ BEQ 0000        // op 16
//  @ HLT