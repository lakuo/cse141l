
// Parameters:
//  A: Number of address bits in instruction memory
//  W: Width of instruction memory entry
module InstROM #(parameter A=10, W=9) (
  input        [A-1:0] InstAddress,
  output logic [W-1:0] InstOut
);

// Instruction memory is a 2D array, W bits wide, 2**A words deep
logic [W-1:0] inst_rom[2**A];

// Next instruction to be executed
always_comb InstOut = inst_rom[InstAddress];

// And this runs once during initalization to load instruction memory from
// external file using $readmemh or $readmemb.
initial begin
  // NOTE: This may not work depending on your simulator
  //       e.g. Questa needs the file in path of the application .exe,
  //       it doesn't care where you project code is
  // Include absolute path here
  $readmemb("C:/Users/s8subram/Downloads/cse141l-main/cse141l-main/Project/machinecode.txt",inst_rom);
  
  // So you are probably better off with an absolute path,
  // but you will have to change this example path when you
  // try this on your machine most likely:
  // $readmemb("//vmware-host/Shared Folders/Downloads/basic_proc2/machine_code.txt", inst_rom);
end

endmodule
