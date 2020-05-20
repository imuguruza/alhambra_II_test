module uart_rx_tb();

parameter baud = 100; //Bauds, each bit will take 10 clock cycles
parameter  clk_freq = 1000; //1 MHz system clk
//-- Tics de reloj para envio de datos a esa velocidad
//-- Se multiplica por 2 porque el periodo del reloj es de 2 unidades
localparam BITRATE = (baud << 1);
//localparam BITRATE = baud;

//-- Tics necesarios para enviar una trama serie completa, mas un bit adicional
localparam FRAME = (BITRATE * 10);

//-- Tiempo entre dos bits enviados
localparam FRAME_WAIT = (BITRATE * 4);

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

  //-- Enviar datos de prueba
  #BITRATE    send_car(8'h55);
  #FRAME_WAIT send_car("K");

  #(FRAME_WAIT*4) $display("END of simulation");
  $finish;
end
endmodule
