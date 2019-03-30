module mult_add #(
	parameter DATA_WIDTH = 32)
	
	(
		input logic clock,
		input logic start_mult_add,

		input logic [DATA_WIDTH-1:0] inp_values [2:0],

		input logic [DATA_WIDTH-1:0] mult_result,
		input logic mult_result_ready,

		input logic [DATA_WIDTH-1] add_result,
		input logic add_result_ready,

		output logic [DATA_WIDTH-1:0] mult_a,
		output logic [DATA_WIDTH-1:0] mult_b,
		output logic mult_start,

		output logic [DATA_WIDTH-1:0] add_a,
		output logic [DATA_WIDTH-1:0] add_b,
		output logic add_start.

		output logic [DATA_WIDTH-1:0] out_value,
		output logic data_ready);


logic [3:0] state_mult_add;

always @(posedge clock) begin

	case (state_mult_add)

		STATE_DEFAULT : begin
			case (start_mult_add)
				1'b1 : state_mult_add <= STATE_;
				1'b0 : state_mult_add <= STATE_DEFAULT;
				endcase
			mult_a <= inp_values[0];
			mult_b <= inp_values[1];
			add_a <= inp_values[2]

			data_ready <= 1'b0;
			end

		STATE_MULT_BEGIN : begin
			mult_start <= 1'b1;
			state_mult_add <= STATE_MULT_WAIT;
			end

		STATE_MULT_WAIT : begin
			mult_start <= 1'b0;
			add_b <= mult_result;

			case (mult_result_ready)
				1'b0 : begin
					state_mult_add <= STATE_MULT_WAIT;
					add_start <= 1'b0;
					end
				1'b1 : begin
					state_mult_add <= STATE_ADD_WAIT;
					add_start <= 1'b1;
					end
				endcase

		STATE_ADD_WAIT : begin
			add_start <= 1'b0;

			case (add_result_ready)
				1'b0 : begin
					state_mult_add <= STATE_ADD_WAIT;
					out_value <= out_value;
					data_ready <= 1'b0;
					end
				1'b1 : begin
					state_mult_add <= STATE_DEFAULT;
					out_value <= add_result;
					data_ready <= 1'b1;
					end
				endcase
			end

		default : begin
			state_mult_add <= STATE_DEFAULT;
			end
		endcase
	end

endmodule
