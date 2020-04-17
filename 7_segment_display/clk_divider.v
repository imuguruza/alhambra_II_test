// ======================================================
// clk_divider module
// Generates new clock with the period set in T parameter
// ======================================================

`default_nettype none
`include "clk_divider_const.vh"

module clk_divider
    #(
      parameter F = `F_50Hz
    )
    (input wire clk,
     input wire en,
     output reg clk_out
    );

// Calculate the amount of bits required for counting
localparam N = $clog2(F);
// Create a register to count
reg [N-1:0] counter = 0;

always @(posedge clk)

  if (en)
    counter <= (counter == F - 1) ? 0 : counter + 1;
  else
    //-- counter freezed at its maximum value
    counter <= F - 1;

// Assing half of the period '1', set ot '0' the rest of time
always @(posedge clk)
  if (counter < (F >> 1))
    clk_out <= en;
  else
    clk_out <= 0;
// Is it possible to write the same in one line?
//assign clk_out <= (counter <= (F >> 1)) ? en : 0

endmodule
