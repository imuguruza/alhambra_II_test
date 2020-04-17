// ======================
//  7segment_decoder test bench
// ======================

`default_nettype none

// Include clock divider constants
`include "clk_divider_const.vh"

module seven_segment_decoder_tb();

parameter AW = 8;
parameter DW = 7;

//-- Input registers
reg clk_in = 0;
// Disable reset
reg reset = 0;
reg [AW-1:0] addr;

wire clk_out;
wire c;
wire [DW-1:0] led_port;

seven_segment_decoder #(
         .AW(AW),
         .DW(DW),
         .refresh_f(`F_1M2Hz)
         )
      dut(
         .clk(clk_in),                    //-- Input clock
         .addr(addr),   //-- Data address
         .reset(reset),
         .led_port(led_port),//-- LED matrix value (ON/OFF)
         .c(c));

always
  # 1 clk_in <= ~clk_in;
/*always
  # 1 addr <= 0x00;
always
  # 2 addr <= 0x11;
always
  # 3 addr <= 0x22;
always
  # 4 addr <= 0x33;
always
  # 5 addr <= 0x44;
always
  # 6 addr <= 0x55;
always
  # 7 addr <= 0x66;
always
  # 8 addr <= 0x77;
always
  # 9 addr <= 0x88;
always
  # 10 addr <= 0x99;
always
  # 11 addr <= 0xAA;
always
  # 12 addr <= 0xBB;
always
  # 13 addr <= 0xCC;
always
  # 14 addr <= 0xDD;
always
  # 15 addr <= 0xEE;
always
  # 16 addr <= 0xFF;*/

initial begin
  //-- Store Results
  $dumpfile("seven_segment_decoder_tb.vcd");
  $dumpvars(0, seven_segment_decoder_tb);

  #10 addr <= 8'h0F;


  # 200 $display("END of simulation");
  $finish;
end

endmodule
