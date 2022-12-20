

module float_point_multiplier_wrapper #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)

	(
	input logic clock,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] inp_a,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] inp_b,
	input logic inp_data_ready,

	output logic out_product_ready,
	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] out_product);


localparam STATE_DEFAULT = 4'd0;
localparam STATE_MULT_WAIT = 4'd1;
localparam STATE_DATA_OUT = 4'd2;
localparam MULT_DELAY = 4;

logic mult_enable;

logic [3:0] state_float_point_multiplier_wrapper;
integer counter_mult;


always @(posedge clock) begin

	case (state_float_point_multiplier_wrapper)

		STATE_DEFAULT : begin
			state_float_point_multiplier_wrapper <= STATE_DEFAULT;
			out_product_ready <= 1'b0;

			if (inp_data_ready) begin
				state_float_point_multiplier_wrapper <= STATE_MULT_WAIT;
				mult_enable <= 1'b1;
				end
			else begin
				state_float_point_multiplier_wrapper <= STATE_DEFAULT;
				mult_enable <= 1'b0;
				end
			end

		STATE_MULT_WAIT : begin
			case (counter_mult)
				4'd0 : begin
					state_float_point_multiplier_wrapper  <= STATE_DATA_OUT;
					counter_mult <= MULT_DELAY;
					end
				default : begin
					state_float_point_multiplier_wrapper <= STATE_MULT_WAIT;
					counter_mult <= counter_mult - 1;
					end
				endcase
			end

		STATE_DATA_OUT : begin
			mult_enable <= 1'b0;
			out_product_ready <= 1'b1;
			state_float_point_multiplier_wrapper <= STATE_DEFAULT;
			end

		default : begin
			state_float_point_multiplier_wrapper <= STATE_DEFAULT;
			mult_enable <= 0;
			counter_mult <= MULT_DELAY;
			end
		endcase
	end

float_point_multiplier #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN)
) inst_float_point_multiplier (
	.clk            (clock),
	.reset_neg      (mult_enable),
	.input_a        (inp_a),
	.input_b        (inp_b),
	.output_product (out_product)
);

endmodule