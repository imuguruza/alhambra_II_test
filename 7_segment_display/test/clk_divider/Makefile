#DEPS = note_gen
#NAME = buzzer
CLK_TEST = clk_divider
SRC_PTH = ../../

clock_sim: $(CLK_TEST)_tb.vcd

$(CLK_TEST)_tb.vcd: $(SRC_PTH)$(CLK_TEST).v $(CLK_TEST)_tb.v

	#-- Compile
	iverilog $^ -o $(CLK_TEST)_tb.out

	#-- Simulate
	./$(CLK_TEST)_tb.out

	#-- Check sim using gtkwave
	gtkwave $@ $(CLK_TEST)_tb.gtkw &

clean:
	rm -f *.out *.vcd *~

.PHONY: all clean
