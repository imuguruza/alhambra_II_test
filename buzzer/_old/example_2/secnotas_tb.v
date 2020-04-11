//-------------------------------------------------------------------
//-- sectones_tb.v
//-- Banco de pruebas para el secuenciador de 4 notas
//-------------------------------------------------------------------
//-- BQ August 2015. Written by Juan Gonzalez (Obijuan)
//-------------------------------------------------------------------
//-- GPL License
//-------------------------------------------------------------------

module secnotas_tb();

//-- Registro para generar la señal de reloj
reg clk = 0;
reg button = 0;

//-- Salidas de los canales
wire ch_out;


//-- Instanciar el componente y establecer el valor del divisor
//-- Se pone un valor bajo para simular (de lo contrario tardaria mucho)
secnotas #(.N0(4), .N1(3), .N2(2), .N3(5), .DUR(10))
  dut(
    .clk(clk),
    .button(button),
    .ch_out(ch_out)
  );

//-- Generador de reloj. Periodo 2 unidades
always
  # 1 clk <= ~clk;
always
  # 4 button <= ~button;


//-- Proceso al inicio
initial begin

  //-- Fichero donde almacenar los resultados
  $dumpfile("secnotas_tb.vcd");
  $dumpvars(0, secnotas_tb);

  # 200 $display("END of simulation");
  $finish;
end

endmodule
