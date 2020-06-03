// Copyright 2020 Iñigo Muguruza Goenaga
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


/*
   640x480 VGA singal generator
   ============================

  - Instantiates PLL for creating 25.125MHz clock
  - Creates h_sync,v_sync signals
  - Creates display enable signal and horizontal, vertical
    pixel position in display (h,v)
*/

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

//wire sys_clk;

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


`ifdef SIM
  assign clk_sys = clk_in;
`else
  //wire locked;
  pll sys_clock(
	   .clock_in(clk_in),
	   .clock_out(clk_sys),
	   .locked(locked)
	   );
`endif


always @(posedge clk_sys) begin

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

always @(posedge clk_sys) begin
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
always @ (posedge clk_sys) begin
  h_count <= h_counter;
  v_count <= v_counter;
end

/*
assign clk_sys = sys_clk;

// Dissable this in simulation
pll sys_clock(
	.clock_in(clk_in),
	.clock_out(sys_clk),
	.locked(locked)
	);*/

endmodule
