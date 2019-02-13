

module angle_normalization #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)

	(
	input logic clk,
	input logic enable,
	input logic reset,

	output logic );

localparam PI_MANTISSA = ;
localparam EXP_BIAS = 127;

always @(posedge clk) begin

	case (state_angle_normalization)

		4'd0 : begin
			if (input_data_ready == 1'b1) begin
				state_angle_normalization <= 4'd1;
				end
			else begin
				state_angle_normalization <= 4'd0;
				end
			angle_normalization_done <= 1'b0;

			angle_magnitude <= {1'b0, input_angle[]};
			angle_sign <= input_angle[];
			end

		4'd1 : begin
			if (angle[] > PI_MANTISSA) begin
				angle_excess_exponent <= angle[];
				end
			else begin
				angle_excess_exponent <= angle[] - 1;
				end
			state_angle_normalization <= 4'd2;
			end

		4'd2 : begin
			angle_normalization_add_a <= angle;
			angle_normalization_add_b <= {1'b1, angle_excess_exponent, PI_MANTISSA};
			angle_normalization_add_start <= 1'b1;
			
			state_angle_normalization <= 4'd3;
			end

		4'd3 : begin
			angle_normalization_add_start <= 1'b0;

			if (angle_normalization_add_ready == 1'b1) begin
				state_angle_normalization <= 4'd4;
				end
			else begin
				state_angle_normalization <= 4'd3;
				end
			end

		4'd4 : begin
			angle_magnitude <= angle_normalization_add_sum;
			state_angle_normalization <= 4'd5;
			end

		4'd5 : begin
			if (angle_magnitude[] > 8'd) begin
				state_angle_normalization <= 4'd1;
				end

			else begin
				if (angle_magnitude[] > PI_MANTISSA) begin
					state_angle_normalization <= 4'd1;
					end
				else begin
					state_angle_normalization <= 4'd6;
					end
				end
			end

		4'd6 : begin //handle if the input angle is negative

			end

		4'd7 : begin
			out_normalized_angle <= {1'b0, angle_magnitude[]};
			angle_normalization_done <= 1'b1;

			state_angle_normalization <= 4'd0;
			end

		default : begin

			end

		endcase
	end

endmodule
