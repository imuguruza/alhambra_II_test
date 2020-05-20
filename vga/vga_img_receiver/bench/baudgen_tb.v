
`default_nettype none

module baudgen_tb();

parameter clk_freq = 12000000;
parameter baud = 115200;

reg clk_in = 0;
// Disable
reg en = 0;
wire tick;

baudgen
      #( //Reduce with this value counting time
      .clk_freq(clk_freq),
      .baud(baud)
      )
    dut(
      .clk(clk_in),
      .en(en),
      .baud_tick(tick)
      );

always
  # 1 clk_in <= ~clk_in;

initial begin
  //-- Store Results
  $dumpfile("baudgen_tb.vcd");
  $dumpvars(0, baudgen_tb);
  # 5 en = 1;
  # 100 $display("END of simulation");
  $finish;
end

endmodule
