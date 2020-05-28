module uart_rx (input wire clk,
                input wire rst,
                input wire rx,
                output reg data_rdy,// Data ready flag
                output reg [7:0] data); // Data

// Defaults
parameter clk_freq = 12000000;
parameter baud = 115200;


wire baud_tick;
reg rx_r;

// Microorders
reg en;      // Enable baud tick gen
reg clear;   // Clear read bit counter
reg load;    // Load data


// Register RX lane
always @(posedge clk)
  rx_r <= rx;

//-- Instantiate baud ticks to read data
baudgen #(
            .clk_freq(clk_freq),
            .baud(baud)
            )
  baudgen0 (
    .clk(clk),
    .en(en),
    .baud_tick(baud_tick)
  );

//-- Bit counter
reg [3:0] bitc;

always @(posedge clk)
  if (clear)
    bitc <= 4'd0;
  else if (clear == 0 && baud_tick == 1)
    bitc <= bitc + 1;


//-- Data register start + data + stop
reg [9:0] raw_data;

always @(posedge clk)
  if (baud_tick == 1) begin
    raw_data = {rx_r, raw_data[9:1]};
  end

//-- Load data to out
always @(posedge clk)
  if (rst == 1)
    data <= 0;
  else if (load)
    data <= raw_data[8:1];


// CONTROLLER
localparam IDLE = 2'd0;  // Idle state
localparam RECV = 2'd1;  // Read state
localparam LOAD = 2'd2;  // Load received data
localparam DAV = 2'd3;   // Data enale state, flag to fetch data

reg [1:0] state;

// Transitions
always @(posedge clk)

  if (rst == 1)
    state <= IDLE;

  else
    case (state)
      IDLE :
        // Check if start has happened
        if (rx_r == 0)
          state <= RECV;
        else
          state <= IDLE;
      RECV:
        //-- Stay here till 10 bit are read
        if (bitc == 4'd10)
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

// Set outputs
always @* begin
  en <= (state == RECV) ? 1 : 0;
  clear <= (state == IDLE) ? 1 : 0;
  load <= (state == LOAD) ? 1 : 0;
  data_rdy <= (state == DAV) ? 1 : 0;
end


endmodule
