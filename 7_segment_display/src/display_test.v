// ================================
//  **7segment_decoder module test**
//
// display a counter 00-FF and display
// it in the 2x 7 segment display
// ================================

`default_nettype none
`include "clk_divider_const.vh"

module display_test (
           input wire clk,               //-- Input clock
           output reg [DW-1: 0] led_port,//-- LED matrix value (ON/OFF)
           output reg c);                //-- ON/OFF Control pin, '1' first
                                         //-- '0' second display

parameter AW = 8;
parameter DW = 7;
parameter refresh_rate = `F_50Hz;

localparam COUNT_MAX = 255;

//Auxiliary wires to connect to decoder
wire [DW-1: 0] wire_led_port;
wire wire_c;

// Disable reset
reg reset = 0;
reg enable = 1;
//reg [AW-1:0] addr;
reg [AW-1:0] counter = 0;

wire Hz_clock;
//reg Hz_clock = 0;
//-- Numer of bits to store in seg generator
parameter M = `F_1Hz;
localparam N = $clog2(M);
//-- 1Hz counter register
reg [N-1:0] divcounter = 0;

// Counter
always @(posedge clk)
  if (enable)
    // Count
    divcounter <= (divcounter == M - 1) ? 0 : divcounter + 1;
  else
    //-- Hold value
    divcounter <= M - 1;

// Generate one pulse each time divcounter = 0,
// if it's enable, will output a '1'
assign Hz_clock = (divcounter == 0) ? enable : 0;
//always @(posedge clk)
//  HZ_clock <= (divcounter == 0) ? enable : 0;

// Use sync'd clk and HZ_clock to increment display value counter
always @(posedge clk)
  if (Hz_clock && enable)
    counter <= (counter == COUNT_MAX) ? 0 : counter + 1;

// Assign register ports its value
always @(posedge clk) begin
  led_port <= wire_led_port;
  c <= wire_c;
  end

// Instantiate decoder and connect it to the output pins
seven_segment_decoder #(
                        .AW(AW),
                        .DW(DW),
                        .refresh_f(refresh_rate)
                      )
                   decoder(
                      .clk(clk),       //-- Input clock
                      .addr(counter),     //-- Data address
                      .reset(reset),      //-- Reset
                      .led_port(wire_led_port),//-- LED port (ON/OFF)
                      .c(wire_c));             //-- Display selector pin (1 left, 0 right)

endmodule
