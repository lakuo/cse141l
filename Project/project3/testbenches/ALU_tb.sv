// Test Bench Name: ALU_tb
// Project Name: CSE141L
//
// Additional Comments:
//   Test bench for combinational (unclocked) ALU

`timescale 1ns/1ps

// includes package "Definitions"
import Definitions::*;

module ALU_tb;
  localparam W = 8;
  localparam Ops = 5;

  reg [W-1:0] InputA;
  reg [W-1:0] InputB;
  reg [Ops-1:0] OP;
  wire [W-1:0] Out;
  wire Zero;

  // Instantiate the ALU module
  ALU #(.W(W), .Ops(Ops)) alu_inst (
    .InputA(InputA),
    .InputB(InputB),
    .OP(OP),
    .Out(Out),
    .Zero(Zero)
  );

  // Clock and reset
  initial begin
    // Set initial values
    InputA = 0;
    InputB = 0;
    OP = 0;

    // Test various ALU operations
    for (int i = 0; i < Ops; i++) begin
      OP = i;
      InputA = $urandom;
      InputB = $urandom;
      #10;
    end

    // Test corner cases
    {InputA, InputB} = {32'hFFFF_FFFF, 32'h0000_0001};
    OP = ADD;
    #10;

    {InputA, InputB} = {32'h0000_0001, 32'h0000_0001};
    OP = CMP;
    #10;

    // Finish the test
    $finish;
  end

  // Monitor the ALU output
  initial begin
    $monitor("At time %0dns: OP = %0d, InputA = %0h, InputB = %0h, Out = %0h, Zero = %0b",
             $time, OP, InputA, InputB, Out, Zero);
  end

endmodule
