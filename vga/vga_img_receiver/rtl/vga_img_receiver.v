`default_nettype none

module vga_image_receiver(
    input  wire      clk_in,
    input  wire      reset,
    input  wire      rx,
    output reg [8:0] rgb_port,
    output wire      h_sync,
    output wire      v_sync,
    output wire      clk_led,
    output wire      locked_led
  );

// PARAMETERS
//-----------------------------------------------------------

parameter img_file = "../data/bender.mem";

//UART parameters
parameter clk_freq = 12000000;
parameter baud     = 115200;

// RAM interfacing
// (100 pixel x 8 bits color) x 100 pixel
parameter  AddressWidth = 14; // 2^14 = 16384
parameter  DataWidth    = 8;

// IMAGE CREATION HELPERS
localparam  h_total       = 640;
localparam  v_total       = 480;
localparam  h_image_pixel = 100;
localparam  v_image_pixel = 100;

// Total pixel amount will indicate how many addresses we need to read/write
localparam addr_amount = h_image_pixel * v_image_pixel;

// Calculate where the image needs to be drawn
localparam   h_image_start  = h_total/2 - h_image_pixel/2;
localparam   h_image_finish = h_total/2 + h_image_pixel/2;
localparam   v_image_start  = v_total/2 - v_image_pixel/2;
localparam   v_image_finish = v_total/2 + v_image_pixel/2;
//----------------------------------------------------------------


wire       clk_sys;       //VGA Clock
wire       display_en;
wire [9:0] h_count; //Pixel location
wire [9:0] v_count; //Pixel location
reg  [7:0] rgb_out; //RGB Value register

// RAM
reg  [AddressWidth-1:0] addr = 0;
reg  [DataWidth-1:0]    data_in;
wire [DataWidth-1:0]    w_data_out;
// RAM read enabled by default
reg rw = 1;

// RX
// Data read from RX lane
reg [7:0]  rx_data;
//Cross-clock domain flip flops
reg data_rdy;
reg data_rdy_rx;
reg data_rdy_ram_prev;
reg data_rdy_ram;

// Read and write addresses
reg [AddressWidth-1:0] write_addr = 0;
reg [AddressWidth-1:0] read_addr = 0;

// synchronize read ready flag to sys_clk clock domain
// Pass three times, so with the last two
// we can detect a posedge
always @(posedge clk_sys) begin
	data_rdy_rx       <= data_rdy_rx;;
	data_rdy_ram_prev <= data_rdy_rx;
  data_rdy_ram      <= data_rdy_ram_prev;
end

/*
always @(posedge clk_sys) begin
  if (data_rdy_ram_prev == 0 && data_rdy_ram == 1) //Posedge happened, new data
    begin
      rw <= (addr == 0) ? 0 : rw; // First positive edge, put RAM in write mode
      data_in <= rx_data;
      addr <= addr + 1;
      if (addr >= addr_amount)
        begin
          // We have achieved to write the img, reset addr and out RAM in read mode
          addr <= 0;
          rw <= 1;
        end
    end
end
*/

//Blink Led with clk
assign  clk_led = clk_sys;

  uart_rx #(
            .clk_freq(clk_freq),
            .baud(baud)
      )rx0(
            .clk(clk_in),           //Board 12MHz clk
            .rst(reset),            // Board rst button
            .rx(rx),                //Board rx lane
            .data_rdy(data_rdy),    // Data ready flag
            .data(rx_data));        // RX Data

  vga_sync vga_s(
        .clk_in(clk_in),         //12MHz clock input
        .reset(reset),           // RST assigned to SW1
        .h_sync(h_sync),
        .v_sync(v_sync),
        .clk_sys(clk_sys),       //25.125 MHz clock generated by PLL
        .h_count(h_count),
        .v_count(v_count),
        .display_en(display_en), // '1' => pixel region
        .locked(locked_led)      // PLL signal, '1' => OK
        );

  ram #(
         .AddressWidth(AddressWidth),
         .DataWidth(DataWidth),
         .RAMFILE(img_file)
        )ram
        (
         .clk(clk_sys),
         .rw(rw), //Read '1', write '0'
         .addr(addr),
         .data_in(data_in),
         .data_out(w_data_out)
         );

/*
// Load the image from RAM if RW=1
always @(posedge clk_sys) begin
 if ( rw  && (v_count >= v_image_start-1 && v_count < v_image_finish-1)
          && (h_count >= h_image_start-1 && h_count < h_image_finish-1))
  begin
  //Load Image from RAM
   rgb_out <= w_data_out;
   addr <= addr + 1;//Load new row pixel
   if (addr >= addr_amount -1)//Out of bounce, go to 0
     addr <= 0;
   end
end
*/


// CONTROLLER
localparam IDLE  = 1'b0;  // Idle state
localparam WRITE = 1'b1;  // write state

reg [1:0] state;

// Transitions
always @(posedge clk_sys)
begin
  if (reset == 1)
        state <= IDLE;
  else
    case (state)
      IDLE :
        if (data_rdy_ram_prev == 0 && data_rdy_ram == 1 && write_addr == 0)
          state <= WRITE;
        else
          state <= IDLE;
      WRITE:
        if (write_addr == addr_amount)
          state <= IDLE;
        else
          state <= WRITE;
     default:
          state <= IDLE;
        endcase
end

// Set rw depending state
always @* begin
  rw   <= (state == IDLE) ? 1 : 0;
  addr <= (state == IDLE) ? read_addr : write_addr;
end



// Load the image from RAM if RW=1 otherwise write
always @(posedge clk_sys) begin
 if (rw) //READ
    begin
      if ((v_count >= v_image_start-1 && v_count < v_image_finish-1)
          && (h_count >= h_image_start-1 && h_count < h_image_finish-1))
        begin
        //Load Image from RAM
          rgb_out <= w_data_out;
          read_addr <= read_addr + 1;//Load new row pixel
            if (read_addr >= addr_amount -1)//Out of bounce, go to 0
              read_addr <= 0;
        end

    end
  else //Write
    begin
      if (data_rdy_ram_prev == 0 && data_rdy_ram == 1) //Posedge happened, new data
        begin
          data_in <= rx_data;
          write_addr <= write_addr + 1;
          if (write_addr >= addr_amount)
              // We have achieved to write the img, reset addr and out RAM in read mode
              write_addr <= 0;
        end
    end
end

// Draw in the frame the image, canvas otherwise
always @(posedge clk_sys) begin
 if (display_en) begin
   if (rw && (v_count > v_image_start-1 && v_count < v_image_finish-1)
          && (h_count > h_image_start-1 && h_count < h_image_finish-1))
     //Image
     rgb_port <= {1'b1,rgb_out};
   else
     rgb_port <= 9'b10111111;
   end else
   // Pixels out of display
   rgb_port <= 9'b000000000;
end


  endmodule