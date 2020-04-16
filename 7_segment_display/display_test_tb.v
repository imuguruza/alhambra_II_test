`include "divider.vh"
/*
module buzzer_tb();

//-- registers
reg clk = 0;
//-- Output signal
wire wave_pin;


//-- Instantiate and set note gen to 1st Octave RE note
buzzer #(.note_divider_value(2))
  dut(
    .clk_in(clk),
    .out (wave_pin)
  );

//-- Generate clock and enable signals
always
  # 1 clk <= ~clk;
//always
//  # 4 en <= ~en;

//-- Proceso al inicio
initial begin

  //-- Fichero donde almacenar los resultados
  $dumpfile("buzzer_tb.vcd");
  $dumpvars(0, buzzer_tb);

  # 200 $display("END of simulation");
  $finish;
end

endmodule*/
