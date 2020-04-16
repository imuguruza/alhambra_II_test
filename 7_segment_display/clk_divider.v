`include "clk_divider_const.vh"


/*
  Generates new clock with the period set in T parameter
*/

module clk_divider
    #(
    parameter F = `50_HZ
    )
    (input wire clk,
     input wire en,
     output reg clk_out);

// Calculate the amount of bits required for counting
localparam N = $clog2(T);
// Create a register to count
reg [N-1:0] counter = 0;

always @(posedge clk)

  if (en)
    counter <= (counter == F - 1) ? 0 : counter + 1;
  else
    //-- counter freezed at its maximum value
    counter <= F - 1;

// Assing half of the period '1', set ot '0' the rest of time
assign clk_out <= (counter <= (F-1[N-1:1])) en : 0;

endmodule
