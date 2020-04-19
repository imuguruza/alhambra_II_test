// ======================
//  display_test test bench
// ======================

//`default_nettype none


module display_tb();

reg clk;
reg [6:0] led_port;
reg c;

display_test #()
            dut(
           .clk(clk),                    //-- Input clock
           .led_port(led_port),//-- LED matrix value (ON/OFF)
           .c(c));                //-- ON/OFF Control pin, '1' first
                                         //-- '0' second display
always
# 1 clk_in <= ~clk_in;

initial begin
//-- Store Results
$dumpfile("display_test_tb.vcd");
$dumpvars(0, seven_segment_decoder_tb);

# 200 $display("END of simulation");
$finish;
end

endmodule
