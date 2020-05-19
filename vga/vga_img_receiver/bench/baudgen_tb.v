
`default_nettype none

module baudgen_tb();

reg clk_in = 0;
// Disable reset
reg reset = 0;
wire tick;

baudgen
      #( //Reduce with this value counting time
      .clk_hz(100),
      .baud(10)
      )
    dut(
      .clk(clk_in),
      .reset(reset),
      .baud_tick(tick)
      );

always
  # 1 clk_in <= ~clk_in;

initial begin
  //-- Store Results
  $dumpfile("baudgen_tb.vcd");
  $dumpvars(0, baudgen_tb);

  # 100 $display("END of simulation");
  $finish;
end

endmodule
