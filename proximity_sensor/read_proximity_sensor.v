// ================================
//  **Read Proximity Sensor**
//
// Reads the proximity senor value
// ================================

`default_nettype none

module read_proximity_sensor (
           input wire clk,    //-- Input clock
           input wire pin,    //-- Physical input pin
           //input wire enable,
           output wire led
           );   //-- LED to display value


//Wire to connect the pin value
//wire value;
reg enable = 1;

//Assign to LED the read value
//always @ (posedge clk)
//    led <= (enable) ? value : 1'bz;

proximity_sensor sensor(
                      .clk(clk),
                      .enable(enable),
                      .pin(pin),
                      .value(led)
                      );

endmodule
