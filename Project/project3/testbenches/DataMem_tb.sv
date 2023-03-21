// This test bench initializes the DataMem module and tests writing to and reading from 
// the memory by iterating through each address in the memory. The $monitor statement is used to 
// monitor and print the data output for each address.

`timescale 1ns/1ps

module DataMem_tb;

  localparam W = 8;
  localparam A = 8;

  reg clk;
  reg Reset;
  reg WriteEn;
  reg [A-1:0] DataAddress;
  reg [W-1:0] DataIn;
  wire [W-1:0] DataOut;

  // Instantiate the DataMem module
  DataMem #(.W(W), .A(A)) datamem_inst (
    .clk(clk),
    .Reset(Reset),
    .WriteEn(WriteEn),
    .DataAddress(DataAddress),
    .DataIn(DataIn),
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
    WriteEn = 0;
    DataAddress = 0;
    DataIn = 0;
    #10;

    // Release reset
    Reset = 0;
    #10;

    // Test write operations
    for (int i = 0; i < 2**A; i++) begin
      WriteEn = 1;
      DataAddress = i;
      DataIn = i ^ 8'hAA;
      #10;
    end

    // Test read operations
    WriteEn = 0;
    for (int i = 0; i < 2**A; i++) begin
      DataAddress = i;
      #10;
    end

    // Finish the test
    $finish;
  end

  // Monitor the data output
  initial begin
    $monitor("At time %0dns: DataAddress = %0h, DataIn = %0h, DataOut = %0h", $time, DataAddress, DataIn, DataOut);
  end

endmodule
