///////////////////////
///  Bit order 
///
/////////////////////


module angle_combination #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23,
	parameter NUM_ANGLE_COMB = 8)
	
	(
		input logic clk,
		input logic reset,
		input logic angle_combination_start,
		input logic [EXP_LEN+MANTISSA_LEN+1-1:0] input_initial_value [5:0],

		input logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_combination_add_sum [1:0],
		input logic angle_combination_add_ready [1:0],

		input logic [15:0] mem_angle_combination_detail_datao,

		output logic angle_combination_done,

		output logic angle_combination_add_start [1:0],
		output logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_combination_add_a [1:0],
		output logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_combination_add_b [1:0],

		output logic [$clog2(NUM_ANGLE_COMB):0] mem_angle_combination_detail_addr,
		output logic [$clog2(NUM_ANGLE_COMB):0] mem_angle_combination_value_addr,
		output logic mem_angle_combination_value_write,
		output logic [EXP_LEN+MANTISSA_LEN+1-1:0] mem_angle_combination_value_in);

logic [3:0] state_angle_combination;
logic [EXP_LEN+MANTISSA_LEN+1-1:0] init_val [2:0];
logic [3:0] angle_combination_detail [3:0];

logic angle_sign [3:0];
logic [EXP_LEN-1:0] angle_exponent [3:0];
logic [MANTISSA_LEN-1:0] angle_mantissa [3:0];
integer j;


always @(posedge clk) begin		//angle_combination

	case (state_angle_combination)

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
			init_val[0] <= input_initial_value[0];
			init_val[1] <= input_initial_value[1];
			init_val[2] <= input_initial_value[2];
			end

		4'd1 : begin
//			for (j = 0; j <= 3; j=j+1) begin
//				angle_combination_detail[j] <= mem_angle_combination_detail_datao[4*j+3:4*j];
//				end
            angle_combination_detail[0] <= mem_angle_combination_detail_datao[3:0];
            angle_combination_detail[1] <= mem_angle_combination_detail_datao[7:4];
            angle_combination_detail[2] <= mem_angle_combination_detail_datao[11:8];
            angle_combination_detail[3] <= mem_angle_combination_detail_datao[15:12];
            
			state_angle_combination <= 4'd2;
			mem_angle_combination_detail_addr <= mem_angle_combination_detail_addr + 1;
			end

		4'd2 : begin
			for (j = 0; j <= 3; j=j+1) begin

				case (angle_combination_detail[j][2:1])	//which state variable; there are 4 variables
					
					2'd0 : begin
						if (angle_combination_detail[j][0] == 1'b1) begin
							angle_exponent[j] <= init_val[0][MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN] + 1;
							end
						else begin
							angle_exponent[j] <= init_val[0][MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
							end

						if (angle_combination_detail[j][3] == 1'b1) begin
							angle_sign[j] <= ~init_val[0][MANTISSA_LEN+EXP_LEN];
							end
						else begin
							angle_sign[j] <= init_val[0][MANTISSA_LEN+EXP_LEN];
                            end
						angle_mantissa[j] <= init_val[0][MANTISSA_LEN-1:0];
						end

					2'd1 : begin
						if (angle_combination_detail[j][0] == 1'b1) begin
							angle_exponent[j] <= init_val[1][MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN] + 1;
							end
						else begin
							angle_exponent[j] <= init_val[1][MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
                        end
						if (angle_combination_detail[j][3] == 1'b1) begin
							angle_sign[j] <= ~init_val[1][MANTISSA_LEN+EXP_LEN];
							end
						else begin
							angle_sign[j] <= init_val[1][MANTISSA_LEN+EXP_LEN];
							end

						angle_mantissa[j] <= init_val[1][MANTISSA_LEN-1:0];
						end

					2'd2 : begin
						if (angle_combination_detail[j][0] == 1'b1) begin
							angle_exponent[j] <= init_val[2][MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN] + 1;
							end
						else begin
							angle_exponent[j] <= init_val[2][MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
							end

						if (angle_combination_detail[j][3] == 1'b1) begin
							angle_sign[j] <= ~init_val[2][MANTISSA_LEN+EXP_LEN];
							end
						else begin
							angle_sign[j] <= init_val[2][MANTISSA_LEN+EXP_LEN];
							end

						angle_mantissa[j] <= init_val[2][MANTISSA_LEN-1:0];
						end

					2'd3 : begin
						
						angle_exponent[j] <= 8'b0;
						angle_sign[j] <= 1'b0;
						angle_mantissa[j] <= 23'b0;
						
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

			angle_combination_add_start[0] <= 1'b1;
            angle_combination_add_start[1] <= 1'b1;
            
			state_angle_combination <= 4'd4;
			end

		4'd4 : begin
			angle_combination_add_start[0] <= 1'b0;
            angle_combination_add_start[1] <= 1'b0;

			case ({angle_combination_add_ready[0], angle_combination_add_ready[1]})
				2'b11 : state_angle_combination <= 4'd5;
				2'b00 : state_angle_combination <= 4'd4;
				2'b01 : state_angle_combination <= 4'd4;
				2'b10 : state_angle_combination <= 4'd4;
				//default : state_angle_combination <= 4'd4;
				endcase
			end

		4'd5 : begin
			angle_combination_add_a[0] <= angle_combination_add_sum[0];
			angle_combination_add_b[0] <= angle_combination_add_sum[1];

			angle_combination_add_start[0] <= 1'b1;

			state_angle_combination <= 4'd6;
			end

		4'd6 : begin
			angle_combination_add_start[0] <= 1'b0;

			case ({angle_combination_add_ready[0], angle_combination_add_ready[1]})
				2'b11 : state_angle_combination <= 4'd7;
				2'b00 : state_angle_combination <= 4'd6;
                2'b01 : state_angle_combination <= 4'd6;
                2'b10 : state_angle_combination <= 4'd6;
//				default : state_angle_combination <= 4'd6;
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


