// The test bench reads the instruction memory from the specified file and 
// verifies the InstROM module's output against the true memory values.

`timescale 1ns/1ps

module InstROM_tb;

  localparam A = 10;
  localparam W = 9;

  logic [A-1:0] InstAddress;
  logic [W-1:0] InstOut;
  logic [W-1:0] true_mem [2**A];
  logic addr;

  // Instantiate the InstROM module
  InstROM instrom_inst (
    .InstAddress(InstAddress),
    .InstOut(InstOut)
  );

  initial begin
    $display("Starting InstROM_tb ...");
    #10ns

    // Read the instruction memory from a file
    $readmemb("../machinecode.txt", true_mem);
    addr = 0;

    // Read and verify instructions from the ROM
    InstAddress = 0;
    verify;
    verify;
    verify;
    verify;
    verify;

    #10ns
    $stop;
  end

  task verify;
    #1ns
    if (true_mem[InstAddress] == InstOut) $display("Success! Expect: %b, ROM Output: %b", true_mem[InstAddress], InstOut);
    else $display("Fail! Expect: %b, ROM Output: %b", true_mem[InstAddress], InstOut);
    InstAddress++;
  endtask

endmodule
