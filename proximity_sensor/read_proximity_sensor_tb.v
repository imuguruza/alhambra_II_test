// ======================
//  Prosimity sensor test bench
// ======================

`default_nettype none


module read_proximity_sensor_tb();

reg clk = 0;
wire led;
reg pin = 0;
//reg enable = 0;

read_proximity_sensor
        dut(
           .clk(clk),       //-- Input clock
           .pin(pin),        //--  input pin
           //.enable(enable), //-- Enable signal
           .led(led)        //-- LED to display value
           );


always
# 1 clk <= ~clk;
always
# 5 pin <= ~pin;

initial begin
  //-- Store Results
  $dumpfile("read_proximity_sensor_tb.vcd");
  $dumpvars(0, read_proximity_sensor_tb);

  # 20 $display("END of simulation");
  $finish;
end

endmodule
