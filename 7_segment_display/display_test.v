// =============================
//  7segment_decoder module test
// =============================

`default_nettype none

// Include clock divider constants
`include "clk_divider_const.vh"

module display_test();

parameter AW = 4;
parameter DW = 8;
// Disable reset
reg reset = 0;
reg [AW-1:0] addr;

7segment_decoder #(
         .AW(AW),
         .DW(DW)
         )
       (
         clk,                    //-- Input clock
         addr,   //-- Data address
         reset;
         led_port,//-- LED matrix value (ON/OFF)
         c);
