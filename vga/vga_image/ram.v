
// 256x256 RAM for storing image

module ram #(
         parameter AddressWidth = 16,
         parameter DataWidth   = 256,
         parameter ROMFILE = "image.list"
        )
       (
         input        clk,
         input  wire  rw, //Read '1', write '0'
         input  wire  [AddressWidth-1:0] addr,
         input  wire  [DataWidth-1:0]  data_in,
         output reg   [DataWidth-1:0]  data_out
       );


localparam  AddressPos = 2**AddressWidth;
reg [DataWidth-1: 0] ram [0: AddressPos-1];

always @(posedge clk) begin
  if (rw == 1)
    data_out <= ram[addr];
end

always @(posedge clk) begin
  if (rw == 0)
   ram[addr] <= data_in;
end

initial begin
  $readmemh(ROMFILE, ram);
end

endmodule
