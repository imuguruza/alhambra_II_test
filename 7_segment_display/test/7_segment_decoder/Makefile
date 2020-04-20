#DEPS = note_gen
#NAME = buzzer
NAME = seven_segment_decoder
DEPEND = clk_divider
DEPEND2 = genrom
SRC_PTH = ../../src/

sim: $(NAME)_tb.vcd

$(NAME)_tb.vcd: $(SRC_PTH)$(NAME).v $(SRC_PTH)$(DEPEND).v $(SRC_PTH)$(DEPEND2).v $(NAME)_tb.v

	#-- Compile
	iverilog $^ -o $(NAME)_tb.out

	#-- Simulate
	./$(NAME)_tb.out

	#-- Check sim using gtkwave
	gtkwave $@ $(NAME)_tb.gtkw &

clean:
	rm -f *.out *.vcd *~

.PHONY: all clean
