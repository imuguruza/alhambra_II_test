/*
   640x480 VGA singal generator
   ============================

  - Instantiates PLL for creating 25MHz clock
  - Creates h_sync,v_sync signals
  - Creates display enable signal and horizontal, vertical
    pixel position in display (h,v)
*/

`default_nettype none


module vga_sync(
      input  wire clk_in,
      input  wire reset,
      output reg  h_sync,
      output reg  v_sync,
      output wire clk_sys,
      output reg [9:0] h_count,
      output reg [9:0] v_count,
      output reg display_en,
      output wire locked
      );

wire locked;
wire sys_clk;

// Pixel counters
reg [9:0] h_counter = 0;
reg [9:0] v_counter = 0;


localparam  h_pixel_total              = 800;
localparam  h_pixel_display            = 640;
localparam  h_pixel_front_porch_amount = 16;
localparam  h_pixel_sync_amount        = 96;
localparam  h_pixel_back_porch_amount  = 48;

localparam  v_pixel_total              = 525;
localparam  v_pixel_display            = 480;
localparam  v_pixel_front_porch_amount = 10;
localparam  v_pixel_sync_amount        = 2;
localparam  v_pixel_back_porch_amount  = 33;


always @(posedge sys_clk) begin

  if (reset) begin
    //Reset counter values
    h_counter <= 0;
    v_counter <= 0;
    display_en <= 0;
  end
  else
    begin
    // Generate display enable signal
    if (h_counter < h_pixel_display && v_counter < v_pixel_display)
      display_en <= 1;
    else
      display_en <= 0;

    //Check if horizontal has arrived to the end
    if (h_counter >= h_pixel_total)
      begin
        h_counter <= 0;
        v_counter <= v_counter + 1;
        end
    else
        //horizontal increment pixel value
        h_counter <= h_counter + 1;
      // check if vertical has arrived to the end
      if (v_counter >= v_pixel_total)
        v_counter <= 0;
  end
end

always @(posedge sys_clk) begin
  // Check if sync_pulse needs to be created
  if (h_counter >= (h_pixel_display + h_pixel_front_porch_amount)
      && h_counter < (h_pixel_display + h_pixel_front_porch_amount + h_pixel_sync_amount) )
    h_sync <= 0;
  else
    h_sync <= 1;
  // Check if sync_pulse needs to be created
  if (v_counter >= (v_pixel_display + v_pixel_front_porch_amount)
      && v_counter < (v_pixel_display + v_pixel_front_porch_amount + v_pixel_sync_amount) )
    v_sync <= 0;
  else
    v_sync <= 1;
end

// Route h_/v_counter to out
always @ (posedge sys_clk) begin
  h_count <= h_counter;
  v_count <= v_counter;
end

assign clk_sys = sys_clk;

pll sys_clock(
	.clock_in(clk_in),
	.clock_out(sys_clk),
	.locked(locked)
	);

//ONLY IN simulation
//assign sys_clk = clk_in;

endmodule
