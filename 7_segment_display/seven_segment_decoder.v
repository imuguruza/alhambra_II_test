`default_nettype none
`include "clk_divider_const.vh"

module seven_segment_decoder #(
         parameter AW = 8,              //-- Adress width 0x0 - 0xFF numbers
         parameter DW = 7,              //-- Data witdh pins A B C D E F G
         parameter refresh_f = `F_100Hz //-- Display refresh rate
         )

       (
         input wire clk,                    //-- Input clock
         input wire [AW-1 : 0] addr,   //-- Data address
         input wire reset,
         output reg [DW-1: 0] led_port,//-- LED matrix value (ON/OFF)
         output reg c);                //-- ON/OFF Control pin, '1' first
                                       //-- '0' second display
// Define list with LED code values
localparam ROMFILE = "display_code.list";
// Compute the amount of items the list has
localparam list_number =  2 ** AW;
// Create a register that stores the values
reg [DW-1: 0] display_mem [list_number-1 : 0];
//reg [DW-1: 0] rom [0: NPOS-1];
// clk_divider enable reset dependent
reg enable;
// Connect display  enabler to clk gen
// This will allow us to select which display to turn on
wire segment_selector;

//-- Read memory
always @(posedge segment_selector or negedge segment_selector) begin
  if (reset) begin
    // Do not turn on any LED
    led_port = 0;
    //c pin into high-impedance
    c = 1'bz;
    end
  else if (segment_selector) // '1' charge the left display, '0' charge the right display
      led_port <= display_mem[addr[AW-1:4]]; //Decode the MSB of address
  else
      led_port <= display_mem[addr[3:0]]; // DEcode the LSB of address
  //end
  //led_port <= (reset) ? 0 : display_mem[addr];
end

//-- Read list
initial begin
  $readmemh(ROMFILE, display_mem);
end

always @(posedge clk)
  enable = ~reset;

// Instantiate clk_divider to obtain clk for refreshing segment
//-- Instantiate test component
clk_divider #(.F(refresh_f))
  display_en(
    .clk(clk),
    .en(enable),
    .clk_out(segment_selector)
  );

// Use segment_en to handle segment common cathode pin
//assign c = segment_selector;
always @(posedge clk)
  c <= segment_selector;


endmodule
