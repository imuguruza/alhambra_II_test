# 7 Segment Display

This folder contains an example of using a 2x 7 Segment Display. In this particular test, the [PMOD SSD](https://reference.digilentinc.com/reference/pmod/pmodssd/reference-manual) has been used.

For Vcc, 3v3 is recommended. Both are tied together, so you need to connect one to the Alhambra board 3v3.

Check the [reference manual](https://reference.digilentinc.com/_media/reference/pmod/pmodssd/pmodssd_rm.pdf) for more info

The `display_test` uses a counter that increments each second and displays the counter value (00 - FF) in the two segment display. For implementing this, I have used
different modules (genrom, clk_divider and seven_segment_decoder and the display_test itself). In the `test` folder, you can find test benches to simulate the behavior of them.

The `src` folder cointains the top file, called `display_test` that puts together everything.

## Pin out

This example uses the pins D0-D7 to control the 7-segment display and VCC & GND connections. I have attached them into the male pins.
For more info, check the [pcf file](src/display_test.pcf)


### Credits

I want to thank [FPGAwars](http://fpgawars.github.io/) the tutorials and the source files they created. I have use them as inspiration or copy them, like the `genrom`.
