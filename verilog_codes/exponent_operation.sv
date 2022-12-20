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

localparam MULT_DELAY = 7;

logic [3:0] state_exponent_operation;
logic [DATA_WIDTH-1:0] value;
logic [EXPONENT_WIDTH-1:0] exponent;
logic [DATA_WIDTH-1:0] intermediate_prod;

logic [DATA_WIDTH-1:0] exponent_operation_mult_prod;

logic [DATA_WIDTH-1:0] exponent_operation_mult_a;
logic [DATA_WIDTH-1:0] exponent_operation_mult_b;
logic exponent_operation_mult_start;

logic [2:0] counter;

float_point_multiplier_wrapper 
 inst_float_point_multiplier_wrapper (
	.clock             (clock),
	.inp_a             (exponent_operation_mult_a),
	.inp_b             (exponent_operation_mult_b),
	.inp_data_ready    (exponent_operation_mult_start),
	.out_product_ready (out_product_ready),
	.out_product       (exponent_operation_mult_prod)
);


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
			//exponent <= inp_exponent;
			output_ready <= 4'd0;

			case (inp_exponent)
				32'b01000000000000000000000000000000 : exponent <= 3'd2;
				32'b01000000010000000000000000000000 : exponent <= 3'd3;
				default : exponent <= 3'd1;
				endcase
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

			exponent_operation_mult_start <= 1'b1;

			exponent <= exponent - 1;
			state_exponent_operation <= 4'd3;
			end // 4'd2 :

		4'd3 : begin
			if (counter == (MULT_DELAY - 1)) begin
				state_exponent_operation <= 4'd4;
				counter <= 0;
				end
			else begin
				state_exponent_operation <= 4'd3;
				counter <= counter + 1;
				end
			exponent_operation_mult_start <= 1'b0;
			intermediate_prod <= exponent_operation_mult_prod;
			end

		4'd4 : begin
			if (exponent == 0) begin
				state_exponent_operation <= 4'd5;
				end
			else begin
				state_exponent_operation <= 4'd2;
				end
			end

		4'd5 : begin
			state_exponent_operation <= 4'd0;
			output_ready <= 4'd1;
			out_value <= intermediate_prod;
			end

		default : begin
			state_exponent_operation <= 4'd0;
			exponent_operation_mult_start <= 1'b0;
			out_value <= 0;
			output_ready <= 0;
			counter <= 0;
			end
		endcase
	end

endmodule