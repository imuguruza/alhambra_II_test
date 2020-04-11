`include "divider.vh"


module buzzer(input wire clk_in, output wire out);

// Enable always the output
reg en = 1;
parameter note_divider_value = `RE_3;


//-- Instantiate and set note gen to 1st Octave RE note
//-- Assign the hardware in/out
note_gen #(.note_divider_value(note_divider_value))
  note_gen(
    .clk_in(clk_in),
    .enable(en),
    .wave(out)
  );

endmodule
