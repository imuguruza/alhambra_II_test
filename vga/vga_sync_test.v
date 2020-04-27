
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
    output wire led
  );

wire clk_sys;
wire display_en;
//reg [9:0] h_count;
wire [9:0] h_count;
//reg [9:0] v_count;
wire [9:0] v_count;
assign  led = reset;

//Check if we can create RGB colors
always @(posedge sys_clk) begin
  if (display_en)
    begin
      r0 <= 1'b0;
      r1 <= 1'b1;
      g0 <= 1'b0;
      g1 <= 1'b1;
      b0 <= 1'b0;
      b1 <= 1'b1;
    end
  else
    begin
      r0 <= 1'b0;
      r1 <= 1'b0;
      g0 <= 1'b0;
      g1 <= 1'b0;
      b0 <= 1'b0;
      b1 <= 1'b0;
  end
end

vga_sync vga_s(
      .clk_in(clk_in),
      .reset(reset),
      .h_sync(h_sync),
      .v_sync(v_sync),
      .clk_sys(clk_sys),
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en)
      );

endmodule
