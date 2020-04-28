
module vga_sync_test(
    input wire clk_in,
    input wire reset,
    output reg r0,
    output reg r1,
    output reg b0,
    output reg b1,
    output reg g0,
    output reg g1,
    output wire h_sync,
    output wire v_sync,
    output wire led,
    output wire locked_led
  );

wire clk_sys;
wire display_en;
//reg [9:0] h_count;
wire [9:0] h_count;
//reg [9:0] v_count;
wire [9:0] v_count;
assign  led = clk_sys;

localparam  h_pixel_max = 640;
localparam  v_pixel_max = 480;
localparam  h_pixel_half = 320;
localparam  v_pixel_half = 240;

//Check if we can create RGB colors
always @(posedge clk_sys) begin
  if (display_en) begin
    if (h_count < h_pixel_half
        && v_count < v_pixel_half) begin
      //Assign here your test color
      r0 <= 1'b0;
      r1 <= 1'b0;
      r2 <= 1'b0;
      g0 <= 1'b0;
      g1 <= 1'b0;
      g2 <= 1'b0;
      b0 <= 1'b1;
      b1 <= 1'b1;
      b2 <= 1'b1;
    end else if (h_count > h_pixel_half
            && v_count < v_pixel_half) begin
      //Assign here your test color
      r0 <= 1'b0;
      r1 <= 1'b0;
      r2 <= 1'b0;
      g0 <= 1'b1;
      g1 <= 1'b1;
      g2 <= 1'b1;
      b0 <= 1'b0;
      b1 <= 1'b0;
      b2 <= 1'b0;
     end else if (h_count < h_pixel_half
            && v_count > v_pixel_half) begin
      //Assign here your test color
      r0 <= 1'b1;
      r1 <= 1'b1;
      r2 <= 1'b1;
      g0 <= 1'b0;
      g1 <= 1'b0;
      g2 <= 1'b0;
      b0 <= 1'b0;
      b1 <= 1'b0;
      b2 <= 1'b0;
    end else begin
      //Assign here your test color
      r0 <= 1'b1;
      r1 <= 1'b1;
      r2 <= 1'b1;
      g0 <= 1'b1;
      g1 <= 1'b1;
      g2 <= 1'b1;
      b0 <= 1'b1;
      b1 <= 1'b1;
      b2 <= 1'b1;
      end
  end else begin
    r0 <= 1'b0;
    r1 <= 1'b0;
    r2 <= 1'b0;
    g0 <= 1'b0;
    g1 <= 1'b0;
    g2 <= 1'b0;
    b0 <= 1'b0;
    b1 <= 1'b0;
    b2 <= 1'b0;
  end
end

vga_sync vga_s(
      .clk_in(clk_in),         //12MHz clock input
      .reset(reset),           // RST assigned to SW1
      .h_sync(h_sync),
      .v_sync(v_sync),
      .clk_sys(clk_sys),       //25.125 MHz clock generated by PLL
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en), // '1' => pixel region
      .locked(locked_led)      // PLL signal, '1' => OK
      );

endmodule
