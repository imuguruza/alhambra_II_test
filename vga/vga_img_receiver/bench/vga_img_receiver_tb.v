`default_nettype none
//`timescale 1ns/1ps  // time-unit = 1 ns, precision = 10 ps

module vga_img_receiver_tb();

//-- Input registers
reg clk_in = 0;
// Disable reset
reg reset;
reg rx;
wire clk_out;
wire h_sync;
wire v_sync;
wire clk_sys;
//reg [9:0] h_count;
wire [9:0] h_count;
//reg [9:0] v_count;
wire [9:0] v_count;
wire display_en;

wire [8:0] rgb_port;
wire clk_led;
wire locked_led;

//------------------------------------------------------------

// File to load in RAM
parameter   img_file      = "bender.mem";
localparam  test_file     = "test.mem";
parameter   AddressWidth  = 14; // 2^14 = 16384
parameter   DataWidth     = 8;
localparam  AddressPos    = 2**AddressWidth;

reg [DataWidth-1: 0] test_img    [0: AddressPos-1];
reg [DataWidth-1: 0] default_img [0: AddressPos-1];

//------------------------------------------------------------

// IMAGE CREATION HELPERS
localparam  h_total       = 800;
localparam  v_total       = 525;
localparam  h_pixel       = 640;
localparam  v_pixel       = 480;
localparam  h_image_pixel = 100;
localparam  v_image_pixel = 100;

// Total pixel amount will indicate how many addresses we need to read/write
localparam addr_amount = h_image_pixel * v_image_pixel;

// Calculate where the image needs to be drawn
localparam   h_image_start  = h_total/2 - h_image_pixel/2;
localparam   h_image_finish = h_total/2 + h_image_pixel/2;
localparam   v_image_start  = v_total/2 - v_image_pixel/2;
localparam   v_image_finish = v_total/2 + v_image_pixel/2;
//------------------------------------------------------------

//UART parameters
parameter clk_freq = 12000000;
parameter baud     = 115200;
localparam BITRATE = (clk_freq/baud << 1) * 3;
//-- Tics necesarios para enviar una trama serie completa, mas un bit adicional
localparam FRAME = (BITRATE * 10) * 3 ;
//-- Tiempo entre dos bits enviados
localparam FRAME_WAIT = (BITRATE * 4)* 3;

//------------------------------------------------------------


integer counter;
integer i;
integer row;
integer vertical;
integer horizontal;
integer img_vertical = 0;
integer pixel = "";

//----------------------------------------
//-- Task for sending pixel color
//----------------------------------------
  task send_car;
    input [7:0] car;
  begin
    rx <= 0;                 //-- Bit start
    #BITRATE rx <= car[0];   //-- Bit 0
    #BITRATE rx <= car[1];   //-- Bit 1
    #BITRATE rx <= car[2];   //-- Bit 2
    #BITRATE rx <= car[3];   //-- Bit 3
    #BITRATE rx <= car[4];   //-- Bit 4
    #BITRATE rx <= car[5];   //-- Bit 5
    #BITRATE rx <= car[6];   //-- Bit 6
    #BITRATE rx <= car[7];   //-- Bit 7
    #BITRATE rx <= 1;        //-- Bit stop
    #BITRATE rx <= 1;        //-- Esperar a que se envie bit de stop
  end
  endtask



vga_img_receiver #(.img_file(img_file),
                     .clk_freq(clk_freq),
                     .baud(baud)
                    )
                    dut(
                      .clk_in(clk_in),
                      .reset(reset),
                      .rx(rx),
                      .rgb_port(rgb_port),
                      .h_sync(h_sync),
                      .v_sync(v_sync),
                      .clk_led(clk_led),
                      .locked_led(locked_led)
                    );



always
  # 1 clk_in <= ~clk_in;

initial begin

  // 1) Open test image
  // 2) Check if the default img is generated OK
  // 3) For loop => send new image
  // 4) Check if new message it's stored
  // 5) Check if new image it's displayed

    //-- Store Results
  $dumpfile("vga_img_receiver_tb.vcd");
  $dumpvars(0, vga_img_receiver_tb);

  //Load default img to check
  $readmemh(img_file, test_img);
  //Load img to transfer
  $readmemh(test_file, default_img);

  reset   = 0;

  // CHECK DEFAULT IMG AT OUTPUT
  // --------------------------- //
/*
  # 1; // Sync with internal clock
  $display ("Testing default image output...\n");
  for (vertical = 0; vertical <= v_total ; vertical = vertical + 1)
  begin

    for (horizontal = 0; horizontal <= h_total ; horizontal = horizontal + 1)
    begin
      //$display ("horizontal %d, vertical %d\n", horizontal, vertical);
      if (vertical >= v_image_start &&  vertical <= v_image_finish
          && horizontal > h_image_start && horizontal < h_image_finish)
      begin //Check horizontal pixel
        if (rgb_port == default_img[horizontal+ img_vertical*v_image_pixel]) $display("time %d, %d,%d pixel OK, %x==%d\n",     $time, horizontal, vertical,rgb_port, horizontal+ img_vertical*v_image_pixel);
        else                                                   $display("time %d, %d,%d pixel WRONG, %x==%d\n",  $time, horizontal, vertical,rgb_port, horizontal+ img_vertical*v_image_pixel);
      end
      #2;// Delay 1 clock
    end
    img_vertical = img_vertical + 1;
  end
*/
  // SEND NEW IMAGE
  // --------------------------- //
  for (i = 0; i < v_image_pixel * h_image_pixel; i=i+1)
  begin
    pixel = test_img[i];//Load new pixel to send
    send_car(pixel);
  end

  # 100 $display("END of simulation");
  $finish;
end

endmodule
