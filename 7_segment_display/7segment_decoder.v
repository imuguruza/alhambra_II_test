`default_nettype none

module 7segment_decoder #(
         parameter AW = 8,   //-- Adress width 0x0 - 0xFF numbers
         parameter DW = 8,   //-- Data witdh
         parameter refresh_f = 10 //-- Display refresh rate
         )

       (
         input clk,                   //-- Input clock
         input wire [AW-1 : 0] addr,   //-- Data address
         input wire reset;
         output reg [DW-1: 0] led_port,   //-- LED matrix value (ON/OFF)
         output reg c);               //-- ON/OFF Control pin, '1' first
                                      //-- '0' second display
// Define list with LED code values
local parameter ROMFILE = "display_code.list";
// Compute the amount of items the list has
local parameter list_number =  2 ** AW;
//-- Create a register that stores the values
reg [DW-1: 0] display_mem [0: list_number-1];

//-- Read memory
always @(posedge clk) begin
  if (reset)
  {
    // Do not turn on any LED
    led_port <= 0;
    //c pin into high-impedance
    c <= 1'bz;
  }
  led_port <= (reset) ? 0 : display_mem[addr];
end

//-- Read list
initial begin
$readmemh(ROMFILE, display_mem);
end

// Instantiate clk_divider to obtain clk for refreshing segment
module clk_divider

endmodule
