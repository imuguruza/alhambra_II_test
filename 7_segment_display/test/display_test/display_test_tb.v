// ======================
//  Display test test bench
// ======================

`default_nettype none

// Include clock divider constants
`include "clk_divider_const.vh"

module display_test_tb();

reg clk = 0;
wire [6:0] led_port;
wire c;

display_test #(
            .M(4), //Change count delay to 4 cycles instead of 1 Hz
            .refresh_rate(2)//Change segment refresh rate to half count time
            )
            dut(
           .clk(clk),                    //-- Input clock
           .led_port(led_port),//-- LED matrix value (ON/OFF)
           .c(c));                //-- ON/OFF Control pin, '1' first
                                         //-- '0' second display
always
# 1 clk <= ~clk;

initial begin
  //-- Store Results
  $dumpfile("display_test_tb.vcd");
  $dumpvars(0, display_test_tb);

  # 2100 $display("END of simulation");
  $finish;
end

endmodule
