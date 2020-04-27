// ======================
//  vga sync bench
// ======================

`default_nettype none
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps


module vga_sync_tb();

//-- Input registers
reg clk_in = 0;
// Disable reset
reg reset = 0;
wire clk_out;
wire h_sync;
wire v_sync;
wire clk_sys;
//reg [9:0] h_count;
wire [9:0] h_count;
//reg [9:0] v_count;
wire [9:0] v_count;
wire display_en;

vga_sync vga_dut(
      .clk_in(clk_in),
      .reset(reset),
      .h_sync(h_sync),
      .v_sync(v_sync),
      .clk_sys(clk_sys),
      .h_count(h_count),
      .v_count(v_count),
      .display_en(display_en)
      );

always
  # 1 clk_in <= ~clk_in;

initial begin
  //-- Store Results
  $dumpfile("vga_sync_tb.vcd");
  $dumpvars(0, vga_sync_tb);

  # 843200 $display("END of simulation");
  $finish;
end

endmodule
