// ======================
//  clk_divider test bench
// ======================

`default_nettype none

// Include clock divider constants
`include "clk_divider_const.vh"

module clk_divider_tb();

//-- registers
reg clk_in = 0;
reg enable = 0;
wire clk_out;


//-- Instantiate test component
clk_divider #(.F(`F_1M2Hz))
  dut(
    .clk(clk_in),
    .en(enable),
    .clk_out (clk_out)
  );

//-- Generate clock and enable at 4th second
always
  # 1 clk_in <= ~clk_in;
always
  # 4 enable <= 1;


initial begin
  //-- Store Results
  $dumpfile("clk_divider_tb.vcd");
  $dumpvars(0, clk_divider_tb);

  # 200 $display("END of simulation");
  $finish;
end

endmodule
