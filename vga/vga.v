//
// 640x480 VGA singal generator //
// ============================ //

module vga#()(
    input clk_in,
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

always @ (posedge sys_clk) begin

  //Check if horizontal has arrived to the end
  if (h_counter == h_pixel_total-1) begin
    h_counter <= 0;
    v_counter = v_counter + 1;
  end
  else //horizontal increment pixel value
    h_counter += 1;
  // check if vertical has arrived to the end  
  if (v_counter == v_pixel_total -1)
    v_counter <= v_counter + 1;
  else
    v_counter <= 0;
end

pll sys_clock(
	.clock_in(clk_in),
	.clock_out(sys_clk),
	.locked(locked)
	);

endmodule
