`default_nettype none

module uart_rx_tb();

parameter baud = 0; //Bauds, each bit will take 10 clock cycles
parameter  clk_freq = 0; //1 MHz system clk
//-- Tics de reloj para envio de datos a esa velocidad
//-- Se multiplica por 2 porque el periodo del reloj es de 2 unidades

localparam BITRATE = (clk_freq/baud << 1);

//-- Tics necesarios para enviar una trama serie completa, mas un bit adicional
localparam FRAME = (BITRATE * 10);

//-- Tiempo entre dos bits enviados
localparam FRAME_WAIT = (BITRATE * 4);



integer  CHAR = "";

//----------------------------------------
//-- Tarea para enviar caracteres serie
//----------------------------------------
  task send_car;
    input [7:0] car;
  begin
    rx <= 0;                 //-- Bit start
    #BITRATE rx <= car[0];   //-- Bit 0
    #BITRATE rx <= car[1];   //-- Bit 1
    #BITRATE rx <= car[2];   //-- Bit 2
    #BITRATE rx <= car[3];   //-- Bit 3
    #BITRATE rx <= car[4];   //-- Bit 4
    #BITRATE rx <= car[5];   //-- Bit 5
    #BITRATE rx <= car[6];   //-- Bit 6
    #BITRATE rx <= car[7];   //-- Bit 7
    #BITRATE rx <= 1;        //-- Bit stop
    #BITRATE rx <= 1;        //-- Esperar a que se envie bit de stop
  end
  endtask

//-- Registro para generar la señal de reloj
reg clk = 0;

//-- Cables para las pruebas
reg rx = 1;
reg reset = 0;//Set reset to 0 for test
wire act;
wire [7:0] data;
wire rdy;

//-- Instanciar el modulo rxleds
uart_rx #(.clk_freq(clk_freq),
          .baud(baud)
         )
  dut(
    .clk,
    .rst(reset),
    .rx(rx),
    .data_rdy(rdy),
    .data(data)
  );

//-- Generador de reloj. Periodo 2 unidades
always
  # 1 clk <= ~clk;

//-- Proceso al inicio
initial begin

  //-- Fichero donde almacenar los resultados
  $dumpfile("uart_rx_tb.vcd");
  $dumpvars(0, uart_rx_tb);
  $display ("\t\t========================  ");
  $display ("\t\t Starting simulation...   ");
  $display ("\t\t========================  ");

  //-- Enviar datos de prueba
  CHAR = 8'h55;
  #BITRATE    send_car(CHAR);
  //->rdy_trigger;
  //wait(rdy)
  if ( data == CHAR) $display ("\t\tData received = %x, OK!   \n", data);
  else               $display ("\t\tData received = %x, ERROR!\n", data);

  CHAR = "K";
  #FRAME_WAIT send_car(CHAR);
  #BITRATE
  if ( data == CHAR) $display ("\t\tData received = %x, OK!   \n", data);
  else               $display ("\t\tData received = %x, ERROR!\n", data);

  //->rdy_trigger;
  #(FRAME_WAIT*4)  $display  ("\t\t========================");
                   $display  ("\t\t END of simulation"      );
                   $display  ("\t\t========================");
  $finish;
end

endmodule
