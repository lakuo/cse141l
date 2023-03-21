// This test bench initializes the ProgCtr module and generates a clock signal. 
//It resets the program counter, starts the program counter, and tests both BEQ and JMP jumps with specified target addresses. 
//The $monitor statement is used to monitor and print the program counter output for each operation.

`timescale 1ns/1ps

module ProgCtr_tb;
  localparam A = 10;

  reg Reset;
  reg Start;
  reg clk;
  reg beq_flag;
  reg jmp_flag;
  reg [A-1:0] Target;
  wire [A-1:0] ProgCtr;

  // Instantiate the ProgCtr module
  ProgCtr #(.A(A)) progctr_inst (
    .Reset(Reset),
    .Start(Start),
    .clk(clk),
    .beq_flag(beq_flag),
    .jmp_flag(jmp_flag),
    .Target(Target),
    .ProgCtr(ProgCtr)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test procedure
  initial begin
    // Initialization
    clk = 0;
    Reset = 0;
    Start = 0;
    beq_flag = 0;
    jmp_flag = 0;
    Target = 0;
    #10;

    // Reset
    Reset = 1;
    #10;
    Reset = 0;
    #10;

    // Start
    Start = 1;
    #10;
    Start = 0;
    #50; // Wait for a few clock cycles

    // Jump (BEQ)
    beq_flag = 1;
    Target = 10;
    #10;
    beq_flag = 0;
    #50; // Wait for a few clock cycles

    // Jump (JMP)
    jmp_flag = 1;
    Target = 20;
    #10;
    jmp_flag = 0;
    #50; // Wait for a few clock cycles

    // Finish the test
    $finish;
  end

  // Monitor the program counter output
  initial begin
    $monitor("At time %0dns: ProgCtr = %0h", $time, ProgCtr);
  end

endmodule
