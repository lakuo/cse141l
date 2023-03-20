/* Memory can only read or (but not and) write each cycle,
    so there is just a single address pointer for both
    Parameters:
    - A: Address Width: the number of entries
    - W: Data Width: the size of each entry
    This memory holds (2**A) * W bits of data.
*/
module DataMem #(parameter W=8, A=8) (
  input                 clk,
                        Reset,
                        WriteEn,
  input       [A-1:0]   DataAddress, // A-bit-wide pointer to 256-deep memory
  input       [W-1:0]   DataIn,      // W-bit-wide data path
  output logic[W-1:0]   DataOut
);

// 8x256 two-dimensional array - basic memory structure
logic [W-1:0] Core[0:2**A-1];

// no need for reads to be sequential
always_comb begin
  DataOut = Core[DataAddress];
end

// // Load the initial contents of memory
// initial begin
//   //$readmemh("../data_mem.hex", Core);
// end

// only function of memory is to output its address value and be writable,
//  so this is pretty simple actually
always_ff @ (posedge clk)
  if(WriteEn) begin
    Core[DataAddress] <= DataIn;
  end
endmodule
