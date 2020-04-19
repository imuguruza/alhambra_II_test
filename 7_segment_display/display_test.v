// ================================
//  **7segment_decoder module test**
//
// display a counter 00-FF and display
// it in the 2x 7 segment display
// ================================

`default_nettype none

// Include clock divider constants
`include "clk_divider_const.vh"

module display_test(
           input wire clk,                    //-- Input clock
           output reg [DW-1: 0] led_port,//-- LED matrix value (ON/OFF)
           output reg c);                //-- ON/OFF Control pin, '1' first
                                         //-- '0' second display

parameter AW = 8;
parameter DW = 7;
localparam COUNT_MAX = 255;

// Disable reset
reg reset = 0;
reg enable = 1;
//reg [AW-1:0] addr;
reg [AW-1:0] counter = 0;

wire Hz_clock;

// 1Hz counter
// !! This is wrong !!
always @(posedge clk and posedge Hz_clock)
    counter <= (counter == COUNT_MAX) ? 0 : counter + 1;


// Instantiate clk_divider to obtain counter edges
clk_divider #(.F(`F_1Hz))
  Hz_clk(
    .clk(clk_in),
    .en(enable),
    .clk_out(Hz_clock)
  );

// Instantiate decoder and connect it to the output pins
seven_segment_decoder #(
                        .AW(AW),
                        .DW(DW),
                        .refresh_f(`F_50Hz)
                      )
                   decoder(
                      .clk(clk_in),       //-- Input clock
                      .addr(counter),     //-- Data address
                      .reset(reset),      //-- Reset
                      .led_port(led_port),//-- LED port (ON/OFF)
                      .c(c));             //-- Display selector pin (1 left, 0 right)
