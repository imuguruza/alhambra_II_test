//                                                 //
// -- Creates 25 MHz clock for system using PLL -- //
//=================================================//

module pll(
	input  clock_in,
	output clock_out,
	output locked
	);

/*
$ icepll -i 12 -o 25.175 

F_PLLIN:    12.000 MHz (given)
F_PLLOUT:   25.175 MHz (requested)
F_PLLOUT:   25.125 MHz (achieved)

FEEDBACK: SIMPLE
F_PFD:   12.000 MHz
F_VCO:  804.000 MHz

DIVR:  0 (4'b0000)
DIVF: 66 (7'b1000010)
DIVQ:  5 (3'b101)

FILTER_RANGE: 1 (3'b001)

*/

// Store PLL config values in local parameters
localparam  DIVR_val = 4'b0000;
localparam  DIVF_val = 7'b1000010;
localparam  DIVQ_val = 3'b101;
localparam  FILTER_val = 3'b001;

SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(DIVR_val),
		.DIVF(DIVF_val),
		.DIVQ(DIVQ_val),
		.FILTER_RANGE(FILTER_val)
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(clock_in),
		.PLLOUTCORE(clock_out)
		);
endmodule
