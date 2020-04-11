`include "divider.vh"


//-- Inputs: source clk, enable and note to create as parameter for the
//-- wave generator (clk divider), reg as output
//--module note_gen #(parameter note_divider_value = LA_8)
module note_gen
  (input wire clk_in,
  input wire enable,
  output wire wave);

parameter note_divider_value = `LA_8;
//-- Calculate the register sice in bits required for the note generator
localparam N = $clog2(note_divider_value);

//-- Counter register creation & initialization
reg [N-1:0] divcounter = 0;
//-- Signal carrier
reg out = 0;

//-- Count
always @(posedge clk_in)
  if (divcounter == note_divider_value - 1)
    divcounter <= 0;
  else
    divcounter <= divcounter + 1;

  //divcounter <= (divcounter == note_divider_value - 1) ? 0 : divcounter + 1;

// Assign wave output value depending enable value
//always @(posedge clk_in)
always @*
  if (enable == 1)
    out <= divcounter[N-1];
  else
    out <= 0;
//  out <= (enable == 1) ? divcounter[N-1] : 0;

assign wave = out;

//-- Sacar el bit mas significativo por clk_out
//assign wave = divcounter[N-1];

endmodule
