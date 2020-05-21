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
