//
//    Baud Generator
//    ==============
//    Creates out of system clk ticks in specific bauds
//
module baudgen(
                input wire clk,
                input wire en,
                output reg baud_tick
              );

parameter clk_freq = 12000000; //Default 12MHz clock
parameter baud = 115200; //Baud speed

localparam  max_count = clk_freq/baud; //max amount to add by counter
localparam N = $clog2(max_count); //Calculate amount of bits for count register
localparam tick_create = (max_count >> 1) - 1; // Calculate value at counter it's in the half of its value

reg [N-1:0] counter = 0;

always @(posedge clk)
  if (en)
    counter <= (counter < max_count - 1) ? counter + 1 : 0;//Count or if it's at max, restart counting
  else
    counter <= counter; //Hold value

always @(posedge clk)
 baud_tick <= (counter == tick_create) ? 1 : 0; //Create a pulse in middle of count

endmodule
