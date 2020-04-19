DEPS = seven_segment_decoder.v clk_divider.v genrom
NAME = display_test


all: sim sint

sim: $(NAME)_tb.vcd

sint: $(NAME).bin

$(NAME)_tb.vcd: $(DEPS).v $(NAME).v $(NAME)_tb.v

	#-- Compile
	iverilog $^ -o $(NAME)_tb.out

	#-- Simulate
	./$(NAME)_tb.out

	#-- Check sim using gtkwave
	gtkwave $@ $(NAME)_tb.gtkw &

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
