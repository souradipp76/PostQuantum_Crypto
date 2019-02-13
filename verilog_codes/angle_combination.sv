

module angle_combination #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23,
	parameter NUM_ANGLE_COMB = 8)
	
	(
		input logic clk,
		input logic enable,
		input logic reset,

		output logic );


always @(posedge clk) begin		//angle_combination

	case (state_angle_combination) begin

		4'd0 : begin
			if (angle_combination_start == 1'b1) begin
				state_angle_combination <= 4'd1;
				end
			else begin
				state_angle_combination <= 4'd0;
				end
			mem_angle_combination_detail_addr <= 0;
			mem_angle_combination_value_addr <= 0;
			angle_combination_done <= 1'b0;
			end

		4'd1 : begin
			for (j = 0; j <= 3; j=j+1) begin
				angle_combination_detail[j] <= mem_angle_combination_detail_datao[:];
				end
			state_angle_combination <= 4'd2;
			mem_angle_combination_detail_addr <= mem_angle_combination_detail_addr + 1;
			end

		4'd2 : begin
			for (j = 0; j <= 3; j=j+1) begin

				case (angle_combination_detail[:]) begin	//which state variable; there are 4 variables
					
					2'd0 : begin
						if (angle_combination_detail[] == )
							angle_exponent[j] <= init_val[][] + 1;
						else
							angle_exponent[j] <= init_val[][];

						if (angle_combination_detail[] == )
							angle_sign[j] <= ~init_val[][];
						else
							angle_sign[j] <= init_val[][];

						angle_mantissa[j] <= init_val[][];
						end

					2'd1 : begin
						if (angle_combination_detail[] == )
							angle_exponent[j] <= init_val[][] + 1;
						else
							angle_exponent[j] <= init_val[][];

						if (angle_combination_detail[] == )
							angle_sign[j] <= ~init_val[][];
						else
							angle_sign[j] <= init_val[][];

						angle_mantissa[j] <= init_val[][];
						end

					2'd2 : begin
						if (angle_combination_detail[] == )
							angle_exponent[j] <= init_val[][] + 1;
						else
							angle_exponent[j] <= init_val[][];

						if (angle_combination_detail[] == )
							angle_sign[j] <= ~init_val[][];
						else
							angle_sign[j] <= init_val[][];

						angle_mantissa[j] <= init_val[][];
						end

					default : begin
						if (angle_combination_detail[] == )
							angle_exponent[j] <= init_val[][] + 1;
						else
							angle_exponent[j] <= init_val[][];

						if (angle_combination_detail[] == )
							angle_sign[j] <= ~init_val[][];
						else
							angle_sign[j] <= init_val[][];

						angle_mantissa[j] <= init_val[][];
						end
					endcase
				end
			state_angle_combination <= 4'd3;
			end

		4'd3 : begin
			angle_combination_add_a[0] <= {angle_sign[0], angle_exponent[0], angle_mantissa[0]};
			angle_combination_add_b[0] <= {angle_sign[1], angle_exponent[1], angle_mantissa[1]};

			angle_combination_add_a[1] <= {angle_sign[2], angle_exponent[2], angle_mantissa[2]};
			angle_combination_add_b[1] <= {angle_sign[3], angle_exponent[3], angle_mantissa[3]};

			angle_combination_add_start <= 1'b1;

			state_angle_combination <= 4'd4;
			end

		4'd4 : begin
			angle_combination_add_start <= 1'b0;

			case ({angle_combination_add_ready[0], angle_combination_add_ready[1]}) begin
				2'b11 : state_angle_combination <= 4'd5;
				default : state_angle_combination <= 4'd4;
				endcase
			end

		4'd5 : begin
			angle_combination_add_a[0] <= angle_combination_add_sum[0];
			angle_combination_add_b[0] <= angle_combination_add_sum[1];

			angle_combination_add_start <= 1'b1;

			state_angle_combination <= 4'd6;
			end

		4'd6 : begin
			angle_combination_add_start <= 1'b0;

			case ({angle_combination_add_ready[0], angle_combination_add_ready[1]}) begin
				2'b11 : state_angle_combination <= 4'd7;
				default : state_angle_combination <= 4'd6;
				endcase
			end

		4'd7 : begin
			mem_angle_combination_value_in <= angle_combination_add_sum[0];
			mem_angle_combination_value_write <= 1'b1;
			state_angle_combination <= 4'd8;
			end

		4'd8 : begin
			if (mem_angle_combination_value_addr == (NUM_ANGLE_COMB - 1)) begin
				state_angle_combination <= 4'd0;
				angle_combination_done <= 1'b1;
				end
			else begin
				state_angle_combination <= 4'd1;
				angle_combination_done <= 1'b0;
				end
			mem_angle_combination_value_write <= 1'b0;
			mem_angle_combination_value_addr <= mem_angle_combination_value_addr + 1;
			end

		default : begin
			state_angle_combination <= 4'd0;
			end
		endcase
	end

endmodule


