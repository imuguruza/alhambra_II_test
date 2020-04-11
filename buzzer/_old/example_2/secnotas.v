//-----------------------------------------------------------------------------
//-- Note generator
//-- It creates a secuence of C7 - I, III, V and VIIb notes of C
//-----------------------------------------------------------------------------
//-- Based in file created by (C) BQ. August 2015. Written by Juan Gonzalez
//-- Adapted by Iñigo Muguruza Goenaga
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------

//-- Incluir las constantes del modulo del divisor
`include "divider.vh"

//-- Parameteros:
//-- clk: Reloj de entrada de la placa iCEstick
//-- ch_out: Canal de salida
//module secnotas(input wire clk, output reg ch_out);
module secnotas(input wire clk, input wire button, output reg ch_out);

//-- Note parameters for dividers
parameter N0 = `DO_4;
parameter N1 = `MI_4;
parameter N2 = `SOL_4;
parameter N3 = `LAs_4;
parameter DUR = `T_250ms;//Use this value to read the button

//-- Out of dividers
wire ch0, ch1, ch2, ch3;

//-- Multiplexer input
reg [1:0] sel = 0;

//-- Reloj con la duracion de la nota
wire clk_dur;

//-- CH0
divider #(N0)
  CH0 (
    .clk_in(clk),
    .clk_out(ch0)
  );


//-- CH1
divider #(N1)
  CH1 (
    .clk_in(clk),
    .clk_out(ch1)
  );

//-- CH2
divider #(N2)
  CH2 (
    .clk_in(clk),
    .clk_out(ch2)
  );

//-- CH3
divider #(N3)
  CH3 (
    .clk_in(clk),
    .clk_out(ch3)
  );

//-- Multiplexer, select depending on "sel"
always @*
  case (sel)
     0 : ch_out <= ch0;
     1 : ch_out <= ch1;
     2 : ch_out <= ch2;
     3 : ch_out <= ch3;
     default : ch_out <= 0;
  endcase

//-- Check if the button is pressed
//-- Use the clk generated with a T of 250ms to be able to
//-- press and realease the button
always @(posedge clk_dur)
//  sel <= sel + 1;
  if (button == 1)
    sel <= sel + 1;

//-- 12MHz => 250ms Clock generator
divider #(DUR)
  TIMER0 (
    .clk_in(clk),
    .clk_out(clk_dur)
  );

endmodule
