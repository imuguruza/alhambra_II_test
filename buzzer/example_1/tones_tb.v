//-------------------------------------------------------------------
//-- tones_tb.v
//-- Banco de pruebas para el generador de 4 tonos
//-------------------------------------------------------------------
//-- BQ August 2015. Written by Juan Gonzalez (Obijuan)
//-- Modified by Iñigo Muguruza
//-------------------------------------------------------------------
//-- GPL License
//-------------------------------------------------------------------

module tones_tb();

//-- Clock Register
reg clk = 0;

//-- Salidas de los canales
wire out;


//-- Instantiate with low values, to simulate
tones #(
  .Fbase(2),
  .F0(3),
  .F1(4),
  .F2(5),
  .F3(6),
  .Fsel(20)
)
  dut(
    .clk(clk),
    .out(out)
  );

//-- Generate clock
always
  # 1 clk <= ~clk;

initial begin

  //-- Dump data to file
  $dumpfile("tones_tb.vcd");
  $dumpvars(0, tones_tb);

  # 200 $display("FIN de la simulacion");
  $finish;
end

endmodule
