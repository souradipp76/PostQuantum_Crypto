//////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
//////////////////////////////////////////////////////////////////////

module float_point_adder #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23) 

	(
	input logic clk,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] a,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] b,
	input logic inp_data_ready,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] sum
	output logic sum_ready);


always @(posedge clk) begin

	case (state)

		4'd0 : begin
			if (inp_data_ready == 1'b1) begin
				state <= 4'd1;
				sum_ready <= 1'b0;
				end
			else begin
				state <= 4'd0;
				sum_ready <= 1'b1;
				end

			in_exponent_a <= a[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
			in_exponent_b <= b[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];

			in_mantissa_a <= {1'b1, a[MANTISSA_LEN-1:0]};
			in_mantissa_b <= {1'b1, b[MANTISSA_LEN-1:0]};

			in_sign_a <= a[MANTISSA_LEN+EXP_LEN];
			in_sign_b <= b[MANTISSA_LEN+EXP_LEN];

			in_magnitudes_equal <= ;
			operation_subtract <= a[MANTISSA_LEN+EXP_LEN]^b[MANTISSA_LEN+EXP_LEN];
			end

		4'd1 : begin
			if (in_magnitudes_equal == 1'b1) begin
				if (operation_subtract == 1'b1) begin
					sign_sum <= 0;
					exponent_sum <= 0;
					mantissa_sum <= 0;
					state <= 4'd;
				end // if (operation_subtract == 1'b1)
				else begin
					sign_sum <= in_sign_a;
					exponent_sum <= in_exponent_a + 1;
					mantissa_sum <= in_mantissa_a;
					state <= 4'd;
					end
				end
			else if (a_zero == 1'b1) begin
				sign_sum <= in_sign_b;
				exponent_sum <= in_exponent_b;
				mantissa_sum <= in_mantissa_b;
				state <= 4'd;
				end
			else if (b_zero == 1'b1) begin
				sign_sum <= in_sign_a;
				exponent_sum <= in_exponent_a;
				mantissa_sum <= in_mantissa_a;
				state <= 4'd;
				end
			else begin
				sign_sum <= 0;
				exponent_sum <= 0;
				mantissa_sum <= 0;
				state <= 4'd2;
				end
			exponent_diff <= in_exponent_a - in_exponent_b;
			mantissa_diff <= in_mantissa_a - in_mantissa_b;
			end

		4'd2 : begin
			if (exponent_diff[] == 1'b1) begin
				a_greater_b <= 1'b0;
				exponent_sum <= in_exponent_b;
				exponent_diff <= -exponent_diff;
				end
			else if (exponent_diff_zero == 1'b0) begin
				a_greater_b <= 1'b1;
				exponent_sum <= in_exponent_a;
				exponent_diff <= exponent_diff;
				end
			else begin
				if (mantissa_diff[] == 1'b1) begin
					a_greater_b <= 1'b0;
					exponent_sum <= in_exponent_a;
					exponent_diff <= exponent_diff;
					end
				else begin
					a_greater_b <= 1'b1;
					exponent_sum <= in_exponent_a;
					exponent_diff <= exponent_diff;
					end
				end
			state <= 4'd3;
			end

		4'd3 : begin
			if (exponent_diff_zero == 1'b1) begin
				mantissa_a_shifted <= in_mantissa_a;
				mantissa_b_shifted <= in_mantissa_b;
				end
			else begin
				if (a_greater_b == 1'b1) begin
					mantissa_a_shifted <= in_mantissa_a;
					mantissa_b_shifted <= in_mantissa_b >> exponent_diff;
					end
				else begin
					mantissa_a_shifted <= in_mantissa_a >> exponent_diff;
					mantissa_b_shifted <= in_mantissa_b;
					end
				end
			state <= 4'd4;
			end

		4'd4 : begin
			if (operation_subtract == 1'b1) begin
				if (a_greater_b == 1'b1) begin
					mantissa_sum <= mantissa_a_shifted - mantissa_b_shifted;
					sign_sum <= in_sign_a;
					end
				else begin
					mantissa_sum <= mantissa_b_shifted - mantissa_a_shifted;
					sign_sum <= in_sign_b;
					end
				end
			else begin
				mantissa_sum <= mantissa_a_shifted + mantissa_b_shifted;
				sign_sum <= in_sign_a;
				end
			state <= 4'd5;
			end

		4'd5 : begin
			case (mantissa_sum[])

				4'b0000 : begin
					mantissa_sum <= mantissa_sum << 4;
					exponent_sum <= exponent_sum + 4;
					state <= 4'd5;
					end
				4'b0001 : begin
					mantissa_sum <= mantissa_sum << 3;
					exponent_sum <= exponent_sum + 3;
					state <= 4'd6;
					end
				4'b0010 : begin
					mantissa_sum <= mantissa_sum << 2;
					exponent_sum <= exponent_sum + 2;
					state <= 4'd6;
					end
				4'b0011 : begin
					mantissa_sum <= mantissa_sum << 2;
					exponent_sum <= exponent_sum + 2;
					state <= 4'd6;
					end
				4'b0100 : begin
					mantissa_sum <= mantissa_sum << 1;
					exponent_sum <= exponent_sum + 1;
					state <= 4'd6;
					end
				4'b0101 : begin
					mantissa_sum <= mantissa_sum << 1;
					exponent_sum <= exponent_sum + 1;
					state <= 4'd6;
					end
				4'b0110 : begin
					mantissa_sum <= mantissa_sum << 1;
					exponent_sum <= exponent_sum + 1;
					state <= 4'd6;
					end
				4'b0111 : begin
					mantissa_sum <= mantissa_sum << 1;
					exponent_sum <= exponent_sum + 1;
					state <= 4'd6;
					end
				4'b1000 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1001 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1010 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1011 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1100 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1101 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1110 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				4'b1111 : begin
					mantissa_sum <= mantissa_sum;
					exponent_sum <= exponent_sum;
					state <= 4'd6;
					end
				endcase
			end

		4'd6 : begin
			sum <= {sign_sum, exponent_sum, mantissa_sum};
			sum_ready <= 1'b1;
			state <= 4'd0;
			end

		default : begin
			state <= 4'd0;
			sum <= 0;
			sum_ready <= 1'b0;
			end // default :
		endcase
	end


endmodule