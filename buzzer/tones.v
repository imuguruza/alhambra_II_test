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

//Now let's divide define new constants for diving 4Khzs
parameter Fbase =  `F_4KHz;
//This constants are used to divide 4Khz signal
parameter F0 = 12;
parameter F1 = 5;
parameter F2 = 23;
parameter F3 = 34;
parameter Fsel = 12_000_000;

//Out of first divider
wire base;
wire count_clk;
reg hold;
wire ch0;
wire ch1;
wire ch2;
wire ch3;
// 0 to 3 counter
reg [1:0] counter = 0;

//-- Base frequency generator (4Khz)
divider #(.M(Fbase))
  CHbase (
    .clk_in(clk),
    .clk_out(base)
  );

//-- Tone 0 generator
divider #(.M(F0))
  CH0 (
    .clk_in(base),
    .clk_out(ch0)
  );

//-- Tone 1 generator
divider #(.M(F1))
  CH1 (
    .clk_in(base),
    .clk_out(ch1)
  );

//-- Tone 2 generator
divider #(.M(F2))
  CH2 (
    .clk_in(base),
    .clk_out(ch2)
  );

//-- Tone 3 generator
divider #(.M(F3))
  CH3 (
    .clk_in(base),
    .clk_out(ch3)
  );

//-- Selector counter frequency
divider #(.M(Fsel))
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

always@*
//always @(counter or ch1 or ch2 or ch3 or ch4)
  case (counter)
    0 : hold <= ch0;
    1 : hold <= ch1;
    2 : hold <= ch2;
    3 : hold <= ch3;
    default : hold <= 0;
  endcase
//Assign out value
assign out = hold;
endmodule
