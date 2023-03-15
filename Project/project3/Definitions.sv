// Package Name:   Definitions
// Project Name:   CSE141L
// Created:        2020.5.27
// Revised:        2022.1.13
//
// This file defines the parameters used in the ALU.
// `import` the package into each module that needs it.
// Packages are very useful for declaring global variables.

package Definitions;
    // There are many ways to define constants in [System]Verilog.
    // You may come across others in examples, and some forms are
    // simpler / more appropriate for different contexts.

    /*
    // Original Verilog synatx
    //   `define in Verilog works like #define in C/C++, it is
    //   a naive string replace
    //
    //   Note the lack of `;`
    //   `defines are not expressions, they are compiler directives
    `define ADD 3'b000
    `define LSH 3'b001
    `define RSH 3'b010
    `define XOR 3'b011
    `define AND 3'b100
    `define SUB 3'b101
    `define CLR 3'b110
    */

    // One SystemVerilog option: constant wires
    //
    // Recall `logic` also creates "physical wires", but unlike
    // the `wire` keyword, `logic` wires are not allowed to be
    // `x` or `z`.
    /*
    const logic [2:0]kADD  = 3'b000;
    const logic [2:0]kLSH  = 3'b001;
    const logic [2:0]kRSH  = 3'b010;
    const logic [2:0]kXOR  = 3'b011;
    const logic [2:0]kAND  = 3'b100;
    const logic [2:0]kSUB  = 3'b101;
    const logic [2:0]kCLR  = 3'b110;
    */

   // Modern SystemVerilog lets you define types. The advantage
   // of doing this is that tools can preserve type metadata,
   // e.g. enum names will appear in timing diagrams
   typedef enum logic [4:0] {
        AND,        // 5'b00000 (0)
        ORR,        // 5'b00001 (1)
        XOR_B,      // 5'b00010 (2)
        XOR_G,      // 5'b00011 (3)
        ADD,        // 5'b00100 (4)
        STR,        // 5'b00101 (5)
        LDR,        // 5'b00110 (6)
        CMP,        // 5'b00111 (7)
        STA,        // 5'b01000 (8)   
        LDA,        // 5'b01001 (9)   
        HOLDER_A,      // 5'b01010     Place holder
        CMP_LS,      // 5'b01011     Place holder
        SHL,        // 5'b01100 (12)
        SHR,        // 5'b01101 (13)
        SET_H,      // 5'b01110 (14)
        SET_L,      // 5'b01111 (15)
        BEQ,        // 5'b10000 (16)
        JMP,        // 5'b10001 (17)
        HLT,        // 5'b10010 (18)
        HOLDER,         // 5'b10011     Place holder
        LD_LUT_H,   // 5'b10100 (20)
        LD_LUT_L    // 5'b10101 (21)
   } op_mne;

endpackage // Definitions
