

module term_accumulator #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23,
	parameter NUM_ADDERS = 4,
	parameter NUM_MULTIPLIERS = 2)
	
	(
		input logic clk,
		input logic enable,
		input logic reset,

		output logic );