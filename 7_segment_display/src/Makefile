DEPS = seven_segment_decoder.v clk_divider.v genrom
NAME = display_test
PATH_TB = ../test/display_test


all: sim sint

sint: $(NAME).bin

$(NAME).bin: $(NAME).pcf $(NAME).v

	#-- Sinth
	yosys -p 'synth_ice40 -top $(NAME) -json $(NAME).json' $(NAME).v $(DEPS).v


	#-- Place & route
	nextpnr-ice40 --hx8k --package tq144:4k --json $(NAME).json --pcf $(NAME).pcf --asc $(NAME).asc

	#-- Type `$ make flash` to upload bistream
	icepack $(NAME).asc $(NAME).bin

#------------------------------
#-- Upload the bitsream to board
#------------------------------
flash:
		iceprog -d i:0x0403:0x6010:0 $(NAME).bin

clean:
	rm -f *.bin *.asc *.json *.out *.vcd *~

.PHONY: all clean
