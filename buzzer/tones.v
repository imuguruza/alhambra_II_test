//-----------------------------------------------------------------------------
//-- Generador de tonos de 1Khz, 2Khz, 3Khz y 4Khz
//-- (C) BQ. August 2015. Written by Juan Gonzalez
//-- Modified by Iñigo Muguruza Goenaga
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------

//-- Incluir las constantes del modulo del divisor
`include "divider.vh"


//-- Parameteros:
//-- clk: Reloj de entrada de la placa iCEstick
//-- data: Valor del contador de segundos, a sacar por los leds de la iCEstick
//module tones(input wire clk, output wire ch0, ch1, ch2, ch3);
module tones(input wire clk, output wire out);

//-- Parametro del divisor. Fijarlo a 1Hz
//-- Se define como parametro para poder modificarlo desde el testbench
//-- para hacer pruebas
parameter F0 = `F_1KHz;
parameter F1 = `F_2KHz;
parameter F2 = `F_3KHz;
parameter F3 = `F_4KHz;

//Now let's divide define new constants for diving 4Khzs
parameter Fbase =  `F_4KHz;
parameter F4khz = 10;
parameter F3khz = 5;
parameter F2khz = 20;
parameter F1khz = 1;
parameter F1hz = 12_000_000;

//Out of first divider
wire base;
wire count_clk;
//wire hold;
wire ch0;
wire ch1;
wire ch2;
wire ch3;
// 0 to 3 counter
reg [1:0] counter = 0;

//-- Base frequency generator
divider #(Fbase)
  CHbase (
    .clk_in(clk),
    .clk_out(base)
  );

//-- Generador de tono 0
divider #(F1khz)
  CH0 (
    .clk_in(base),
    .clk_out(ch0)
  );

//-- Generador de tono 1
divider #(F2khz)
  CH1 (
    .clk_in(base),
    .clk_out(ch1)
  );

//-- Generador de tono 2
divider #(F3khz)
  CH2 (
    .clk_in(base),
    .clk_out(ch2)
  );

//-- Generador de tono 3
divider #(F4khz)
  CH3 (
    .clk_in(base),
    .clk_out(ch3)
  );

//-- 1Hz generator
divider #(F1hz)
  CH4 (
    .clk_in(clk),
    .clk_out(count_clk)
  );

//Count
always @(posedge count_clk)
  if (counter == 3) //Restart counting
    counter = 0;
  else
    counter <= counter + 1;

//-- Implementación del multiplexor de 4 a 1
always@*
//always @(counter or ch1 or ch2 or ch3 or ch4)
  case (counter)
    0 : out <= ch0;
    1 : out <= ch1;
    2 : out <= ch2;
    3 : out <= ch3;
    default : out <= 0;
  endcase

endmodule
