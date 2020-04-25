
module vga_sync_test(
    input wire clk_in,
    input wire reset,
    output wire r0,
    output wire r1,
    output wire b0,
    output wire b1,
    output wire g0,
    output wire g1,
    output wire h_sync,
    output wire v_sync,
    output wire led
  );

wire clk_sys;
wire display_en;
assign  led = display_en;

//Check if we can create RGB colors
always @(posedge sys_clk) begin
  if (display_en)
    begin
      r0 = 1'b1;
      r1 = 1'b1;
      g0 = 1'b1;
      g1 = 1'b1;
      b0 = 1'b1;
      b1 = 1'b1;
    end
  else
    begin
      r0 = 1'b0;
      r1 = 1'b0;
      g0 = 1'b0;
      g1 = 1'b0;
      b0 = 1'b0;
      b1 = 1'b0;
  end
end

vga_sync vga_s(
      .clk_in(clk_in),
      .reset(reset),
      .h_sync(h_sync),
      .v_sync(v_sync),
      .clk_sys(clk_sys),
      .display_en(display_en)
      );

endmodule
