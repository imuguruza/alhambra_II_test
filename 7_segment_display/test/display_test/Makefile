TEST = display_test
DEP_1 = clk_divider
DEP_2 = genrom
DEP_3 = seven_segment_decoder
SRC_PTH = ../../src

sim: $(TEST)_tb.vcd

$(TEST)_tb.vcd: $(SRC_PTH)/$(TEST).v $(SRC_PTH)/$(DEP_1).v \
								$(SRC_PTH)/$(DEP_2).v $(SRC_PTH)/$(DEP_3).v $(TEST)_tb.v

	#-- Compile
	iverilog $^ -o $(TEST)_tb.out

	#-- Simulate
	./$(TEST)_tb.out

	#-- Check sim using gtkwave
	gtkwave $@ $(TEST)_tb.gtkw &

clean:
	rm -f *.out *.vcd *~

.PHONY: all clean
