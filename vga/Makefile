NAME = vga_sync_test
DEPS = vga_sync
DEPS2 = pll
SIM = vga_sync


sim: $(SIM)_tb.vcd

$(SIM)_tb.vcd: $(SIM).v $(SIM)_tb.v

	#-- Compile
	iverilog $^ -o $(SIM)_tb.out

	#-- Simulate
	./$(SIM)_tb.out

	#-- Check sim using gtkwave
	gtkwave $@ $(SIM)_tb.gtkw &

sint: $(NAME).bin

$(NAME).bin: $(NAME).pcf $(NAME).v

	#-- Sinth
	yosys -p 'synth_ice40 -top $(NAME) -json $(NAME).json' $(NAME).v $(DEPS).v $(DEPS2).v


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
