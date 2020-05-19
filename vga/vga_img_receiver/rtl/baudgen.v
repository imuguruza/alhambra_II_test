/*
    Baud Generator
    ==============
    Creates out of system clk ticks in specific bauds
*/

`default_nettype none

module baudgen(
                input wire clk,
                input wire reset,
                output reg baud_tick
              );

parameter clk_hz = 12000000; //Default 12MHz clock
parameter baud = 115200; //Baud speed

localparam  max_count = clk_hz/baud; //max amount to add by counter
localparam N = $clog2(max_count); //Calculate amount of bits for count register
localparam tick_create = (max_count >> 1); // Calculate value at counter it's in the half of its value

reg [N-1:0] counter = 0;

always @(posedge clk)
  if (reset)
    counter <= 0; //Reset counter
  else
    counter <= (counter == max_count - 1) ? 0 : counter + 1;//Count or if it's at max, restart counting

always @(posedge clk)
 baud_tick <= (counter == tick_create) ? 1 : 0; //Create a pulse in middle of count

endmodule
