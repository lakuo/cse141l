// Test Bench Name: Accumulator_tb
// Project Name: CSE141L

`timescale 1ns/1ps

module Accumulator_tb;

  localparam W = 8;

  reg clk;
  reg Reset;
  reg Write_En;
  reg From_Reg;
  reg From_Imm;
  reg From_ALU;
  reg Load_Hi;
  reg [W-1:0] RegInput;
  reg [W-1:0] ALUInput;
  reg [3:0] Imm_in;
  wire [W-1:0] DataOut;

  // Instantiate the Accumulator module
  Accumulator #(.W(W)) accumulator_inst (
    .clk(clk),
    .Reset(Reset),
    .Write_En(Write_En),
    .From_Reg(From_Reg),
    .From_Imm(From_Imm),
    .From_ALU(From_ALU),
    .Load_Hi(Load_Hi),
    .RegInput(RegInput),
    .ALUInput(ALUInput),
    .Imm_in(Imm_in),
    .DataOut(DataOut)
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
    From_Reg = 0;
    From_Imm = 0;
    From_ALU = 0;
    Load_Hi = 0;
    RegInput = 0;
    ALUInput = 0;
    Imm_in = 0;
    #10;

    // Release reset
    Reset = 0;
    #10;

    // Test writing from register
    Write_En = 1;
    From_Reg = 1;
    RegInput = 8'h5A;
    #10;

    // Test writing from ALU
    From_Reg = 0;
    From_ALU = 1;
    ALUInput = 8'hA5;
    #10;

    // Test writing from immediate (low 4 bits)
    From_ALU = 0;
    From_Imm = 1;
    Load_Hi = 0;
    Imm_in = 4'hF;
    #10;

    // Test writing from immediate (high 4 bits)
    Load_Hi = 1;
    Imm_in = 4'hC;
    #10;

    // Finish the test
    $finish;
  end

  // Monitor the data output
  initial begin
    $monitor("At time %0dns: DataOut = %0h", $time, DataOut);
  end

endmodule
