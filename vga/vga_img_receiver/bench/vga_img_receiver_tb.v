`default_nettype none
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps

module vga_image_receiver_tb();

//-- Input registers
reg clk_in = 0;
// Disable reset
reg reset = 0;
wire rx;
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

// File to load in RAM
parameter img_file = "../data/bender.mem";
//UART parameters
parameter clk_freq = 12000000;
parameter baud     = 115200;

vga_image_receiver #(.img_file(img_file),
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
  # 20 clk_in <= ~clk_in;

initial begin
  //-- Store Results
  $dumpfile("vga_image_receiver_tb.vcd");
  $dumpvars(0, vga_image_receiver_tb);

  # 33728000 $display("END of simulation");
  $finish;
end

endmodule
