// This test bench initializes the LUT module and generates a clock signal. 
// It first resets the LUT, then writes random values to the LUT for each address, 
// and finally reads the LUT values back. The $monitor statement is used to monitor 
// and print the LUT output for each operation.

`timescale 1ns/1ps

module LUT_tb;
  localparam W = 10;
  localparam A = 4;

  reg clk;
  reg Reset;
  reg Write_En;
  reg Load_Hi;
  reg [A-1:0] Imm_in;
  reg [7:0] Acc_in;
  wire [W-1:0] Target;

  // Instantiate the LUT module
  LUT #(.W(W), .A(A)) lut_inst (
    .clk(clk),
    .Reset(Reset),
    .Write_En(Write_En),
    .Load_Hi(Load_Hi),
    .Imm_in(Imm_in),
    .Acc_in(Acc_in),
    .Target(Target)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test procedure
  initial begin
    // Initialization
    clk = 0;
    Reset = 1;
    Write_En = 0;
    Load_Hi = 0;
    Imm_in = 0;
    Acc_in = 0;
    #10;

    // Reset release
    Reset = 0;
    #10;

    // Write to LUT
    Write_En = 1;
    for (int i = 0; i < 2**A; i++) begin
      Imm_in = i;
      Acc_in = $urandom;
      Load_Hi = 1;
      #10;
      Acc_in = $urandom;
      Load_Hi = 0;
      #10;
    end

    // Read from LUT
    Write_En = 0;
    for (int i = 0; i < 2**A; i++) begin
      Imm_in = i;
      #10;
    end

    // Finish the test
    $finish;
  end

  // Monitor the LUT output
  initial begin
    $monitor("At time %0dns: Imm_in = %0h, Acc_in = %0h, Target = %0h",
             $time, Imm_in, Acc_in, Target);
  end

endmodule