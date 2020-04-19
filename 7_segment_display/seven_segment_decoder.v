`default_nettype none
`include "clk_divider_const.vh"

module seven_segment_decoder #(
         parameter AW = 8,              //-- Adress width 0x0 - 0xFF numbers
         parameter DW = 7,              //-- Data witdh pins A B C D E F G
         parameter refresh_f = `F_100Hz //-- Display refresh rate
         )

       (
         input wire clk,                    //-- Input clock
         input wire [AW-1: 0] addr,   //-- Data address
         input wire reset,
         output reg [DW-1: 0] led_port,//-- LED matrix value (ON/OFF)
         output reg c);                //-- ON/OFF Control pin, '1' first
                                       //-- '0' second display
// Define list with LED code values
localparam ROMFILE = "display_code.list";
// Compute the amount of items the list has
localparam list_number =  2 ** AW;
// Create a register that stores the values
wire [DW-1:0] display_code;
//reg [DW-1: 0] rom [0: NPOS-1];
// clk_divider enable reset dependent
reg enable;
// Connect display  enabler to clk gen
// This will allow us to select which display to turn on
wire segment_selector;

localparam  ROM_size = 4; //in bits
reg [ 3 : 0 ] rom_addr;

// Instantiate clk_divider to obtain clk for refreshing segment
//-- Instantiate test component
clk_divider #(.F(refresh_f))
  display_en(
    .clk(clk),
    .en(enable),
    .clk_out(segment_selector)
  );

genrom #(
        .ROMFILE(ROMFILE),
        .AW(ROM_size),
        .DW(DW))
  ROM(  .clk(clk),
        .addr(rom_addr),
        .data(display_code)
      );

//Set enable depending reset value
always @(posedge clk)
  enable = ~reset;


// Use segment_en to handle segment common cathode pin
//assign c = segment_selector;
always @(posedge clk) begin
  c <= segment_selector;
  led_port <= display_code;
  end

// In rising edge, load left display
always @(posedge segment_selector)
  rom_addr <= addr [AW -1 : 4];

// In falling edge, load right display
always @(negedge segment_selector)
  rom_addr <= addr [3 : 0];



endmodule
