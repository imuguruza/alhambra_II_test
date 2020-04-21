// ================================
//  **Proximity sensor**
//
// Reads the digital input
// ================================

`default_nettype none

module proximity_sensor (
           input wire clk,
           input wire enable,  //-- Input clock
           input wire pin,
           output reg value);   //-- 0/1

//If enable is ON, read pin value, otherwise high-impedances
always @(posedge clk)
    value <= (enable) ? pin : 1'bz;

endmodule
