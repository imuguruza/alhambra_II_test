
`default_nettype none

module baudgen_tb();

parameter clk_freq = 12000000;
parameter baud = 115200;
integer i;

reg clk_in = 0;
// Disable
reg en = 0;
wire tick;
localparam EN_TIME = 0;
localparam CHECK_TIME = clk_freq/baud + EN_TIME;
localparam  WAIT_TIME = clk_freq/baud;

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
  # EN_TIME en = 1;

  $display ("\t\t========================  ");
  $display ("\t\t Starting simulation...   ");
  $display ("\t\t========================\n");
  for (i = 0; i<10; i=i+1) begin
    # CHECK_TIME if  (tick == 1)  $display ("%d Tick generated OK!", $time);
                 else             $display ("%d ERROR: Tick generated NOT OK!", $time);
    # WAIT_TIME ;
  end
      $display  ("\n\t\t========================");
  # 5 $display  ("  \t\t END of simulation"      );
      $display  ("  \t\t========================");
  $finish;
end

endmodule
