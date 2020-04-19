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
         .clk(clk_in),       //-- Input clock
         .addr(addr),        //-- Data address
         .reset(reset),      //-- Reset
         .led_port(led_port),//-- LED port (ON/OFF)
         .c(c));             //-- Display selector pin (1 left, 0 right)

always
  # 1 clk_in <= ~clk_in;

initial begin
  //-- Store Results
  $dumpfile("seven_segment_decoder_tb.vcd");
  $dumpvars(0, seven_segment_decoder_tb);

  //Test all the possible characters out
  #5 addr <= 8'hF0;
  #15 addr <= 8'h01;
  #25 addr <= 8'h12;
  #35 addr <= 8'h23;
  #45 addr <= 8'h34;
  #55 addr <= 8'h45;
  #65 addr <= 8'h56;
  #75 addr <= 8'h67;
  #85 addr <= 8'h78;
  #95 addr <= 8'h89;
  #105 addr <= 8'h9A;
  #115 addr <= 8'hAB;
  #125 addr <= 8'hBC;
  #135 addr <= 8'hCD;
  #145 addr <= 8'hDE;
  #155 addr <= 8'h0F;


  # 165 $display("END of simulation");
  $finish;
end

endmodule
