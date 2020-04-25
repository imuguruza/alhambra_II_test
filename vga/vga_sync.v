//
// 640x480 VGA singal generator //
// ============================ //

module vga_sync(
      input  wire clk_in,
      input  wire reset,
      output reg  h_sync,
      output reg  v_sync,
      output wire clk_sys,
      output reg display_en
      );

wire locked;
wire sys_clk;

// Pixel counters
reg [9:0] h_counter = 0;
reg [9:0] v_counter = 0;


localparam  h_pixel_total              = 800;
localparam  h_pixel_display            = 640;
localparam  h_pixel_front_porch_start  = 640;
localparam  h_pixel_front_porch_amount = 16;
localparam  h_pixel_sync_start         = 656;
localparam  h_pixel_sync_amount        = 96;
localparam  h_pixel_back_porch_start   = 752;
localparam  h_pixel_back_porch_amount  = 48;

localparam  v_pixel_total              = 525;
localparam  v_pixel_display            = 480;
localparam  v_pixel_front_porch_start  = 480;
localparam  v_pixel_front_porch_amount = 10;
localparam  v_pixel_sync_start         = 489;
localparam  v_pixel_sync_amount        = 2;
localparam  v_pixel_back_porch_start   = 492;
localparam  v_pixel_back_porch_amount  = 33;

/*
always @( posedge sys_clk) begin
  if (reset) begin
    //Reset counter values
    h_counter <= 0;
    v_counter <= 0;
    end
end
*/
always @(posedge sys_clk) begin

  if (reset) begin
    //Reset counter values
    h_counter <= 0;
    v_counter <= 0;
  end

  // Generate display enable signal
  if (h_counter < h_pixel_total && v_counter < v_pixel_total)
    display_en <= 1;
  else
    display_en <= 0;

    //Check if horizontal has arrived to the end
    if (h_counter >= h_pixel_total-1)
      begin
        h_counter <= 0;
        v_counter = v_counter + 1;
      end
   else
    begin
      //horizontal increment pixel value
      h_counter <= h_counter + 1;
      // check if vertical has arrived to the end
      if (v_counter >= v_pixel_total -1)
      v_counter <= v_counter + 1;
      else
        v_counter <= 0;
    end
end

always @(posedge sys_clk) begin
  // Check if sync_pulse needs to be created
  if (h_counter <= h_pixel_sync_start
      || h_counter >= h_pixel_sync_start + h_pixel_sync_amount )
    h_sync <= 1;
  else
    h_sync <= 0;
//end

//always @(posedge sys_clk) begin
  // Check if sync_pulse needs to be created
  if (v_counter <= v_pixel_sync_start
      || v_counter >= v_pixel_sync_start + v_pixel_sync_amount )
    h_sync <= 1;
  else
    h_sync <= 0;
end

assign clk_sys = sys_clk;

pll sys_clock(
	.clock_in(clk_in),
	.clock_out(sys_clk),
	.locked(locked)
	);

endmodule
