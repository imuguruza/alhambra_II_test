/*
    UART Receiver
    ==============
    Reades RX line and offers the data in the output.
    8 bit, comm assumed

    - Input: CLK
    - Input: Reset
    - Input: RX, read data wire
    - Output: data_rdy, flag to grab data
    - Output: Received 8 bit data

    `ifdef SIMULATION

*/

`default_nettype none

module uart_receiver(
                input wire clk,
                input wire reset,
                input wire rx,
                output reg data_rdy,
                output reg[7:0] data
              );

//Assign value in Fusesoc core?
param clk_freq;
param baud_speed;

reg reset_baud;
reg clear;   //-- Poner a cero contador de bits
reg load;    //-- Cargar dato recibido


baudgen
 #( //Reduce with this value counting time
   .clk_hz(clk_freq),
   .baud(baud_speed)
 )
 baudgenerator(
  .clk(clk_in),
  .reset(reset_baud),
  .baud_tick(tick)
 );

reg [1:0] state;
//-- Received bit counter
reg [3:0] counter;

always @(posedge clk)
  if (clear)
    counter <= 4'd0;
  else if (clear == 0 && tick == 1)
    counter <= counter + 1;

//State machine controller
//-------------------------
localparam IDLE = 2'b00;
localparam READ = 2'b01;
localparam LOAD = 2'd10;
localparam DAV =  2'b11;

always @(posedge clk)
  if (reset == 0)
    state <= IDLE;
  else
    case (state)
      //Wait for asserting the line
      IDLE :
        state <= rx ? RECV : IDLE;
      RECV:
        //-- Vamos por el ultimo bit: pasar al siguiente estado
        if (counter == 4'd10)
          state <= LOAD;
        else
          state <= RECV;
      LOAD:
        state <= DAV;
      DAV:
        state <= IDLE;
    default:
      state <= IDLE;
    endcase
//-------------------------

//-- Registro de desplazamiento para almacenar los bits recibidos
//--------------------------
reg [9:0] raw_data;

always @(posedge clk)
  if (tick == 1) begin
    raw_data = {rx, raw_data[9:1]};
  end
//-- Registro de datos. Almacenar el dato recibido
always @(posedge clk)
  if (reset == 1)
    data <= 0;
  else if (load)
    data <= raw_data[8:1];
//--------------------------

//-- Set flags
always @* begin
  reset_baud <= (state == RECV) ? 1 : 0;
  clear <= (state == IDLE) ? 1 : 0;
  load <= (state == LOAD) ? 1 : 0;
  rcv <= (state == DAV) ? 1 : 0;
end

endmodule
