module sine_calculator #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23) 

	(
	input logic clk,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] theta,
	input logic sine_cosine,
	input logic inp_data_ready,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] value,
	output logic data_ready);


always @(posedge clk) begin

	case (state) begin

		4'd0 : begin
			if (inp_data_ready == 1'b1) begin


