// Copyright 2020 Iñigo Muguruza Goenaga
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


// ======================
//  vga image bench
// ======================

`default_nettype none
`timescale 1 ns/1 ns  // time-unit = 1 ns, precision = 10 ps


module vga_image_tb();

//-- Input registers
reg clk_in = 0;
// Disable reset
reg reset = 0;
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

vga_image dut(
      .clk_in(clk_in),
      .reset(reset),
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
  $dumpfile("vga_image_tb.vcd");
  $dumpvars(0, vga_image_tb);

  # 33728000 $display("END of simulation");
  $finish;
end

endmodule
