//Fix the following issue
//The input value of exponent will be in floatig point
//We need to convert to an integer before starting operation.

module exponent_operation #(
	
	parameter DATA_WIDTH = 32,
	parameter EXPONENT_WIDTH = 3)
	
	(
	input logic clock,
	input logic start,
	input logic [DATA_WIDTH-1:0] inp_value,
	input logic [DATA_WIDTH-1:0] inp_exponent,

	output logic output_ready,
	output logic [DATA_WIDTH-1:0] out_value);

localparam MULT_DELAY = 4;

logic [3:0]state_exponent_operation;
logic [DATA_WIDTH-1:0]value;
logic [EXPONENT_WIDTH-1:0]exponent;
logic [DATA_WIDTH-1:0]intermediate_prod;
logic [DATA_WIDTH-1:0]exponent_operation_mult_a;
logic [DATA_WIDTH-1:0]exponent_operation_mult_b;
logic [DATA_WIDTH-1:0]exponent_operation_mult_prod;
logic counter;

always @(posedge clock) begin

	case (state_exponent_operation)

		4'd0 : begin
			if (start) begin
				state_exponent_operation <= 4'd1;
				end
			else begin
				state_exponent_operation <= 4'd0;
				end
			value <= inp_value;
			exponent <= inp_exponent;
			output_ready <= 4'd0;
			end

		4'd1 : begin
			if (exponent == 1) begin
				state_exponent_operation <= 4'd5;
				end
			else begin
				state_exponent_operation <= 4'd2;
				end
			intermediate_prod <= value;
			exponent <= exponent - 1;
			end

		4'd2 : begin
			exponent_operation_mult_a <= intermediate_prod;
			exponent_operation_mult_b <= value;

			exponent <= exponent - 1;
			state_exponent_operation <= 4'd3;
			end // 4'd2 :

		4'd3 : begin
			if (counter == (MULT_DELAY - 1)) begin
				state_exponent_operation <= 4'd4;
				counter <= 1;
				end
			else begin
				state_exponent_operation <= 4'd3;
				counter <= counter + 1;
				end
			end

		4'd4 : begin
			if (exponent == 0) begin
				state_exponent_operation <= 4'd5;
				end
			else begin
				state_exponent_operation <= 4'd2;
				end
			intermediate_prod <= exponent_operation_mult_prod;
			end

		4'd5 : begin
			state_exponent_operation <= 4'd0;
			output_ready <= 4'd1;
			out_value <= intermediate_prod;
			end

		default : begin
			state_exponent_operation <= 4'd0;
			output_ready <= 0;
			counter <= 1;
			end
		endcase
	end

endmodule