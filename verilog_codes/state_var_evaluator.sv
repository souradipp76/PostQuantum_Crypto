/////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////

module state_var_evaluator #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23,
	parameter NUM_ADDERS = 4,
	parameter NUM_MULTIPLIERS = 2)
	
	(
		input logic clk,
		input logic enable,
		input logic reset,

		output logic );

localparam DELTA_T = ;
localparam NUM_STATE_VAR = 3,
localparam DIFF_EQN_ORDER = 2,
localparam STATE_EQN_DEG = 2,
localparam NUM_TERMS = 32,

logic [EXP_LEN+MANTISSA_LEN+1-1:0] init_val [(NUM_STATE_VAR*DIFF_EQN_ORDER)-1:0];

always @(posedge clk) begin

	case (state) begin

		4'd0 : begin
			if (enable) begin
				init_val <= initial_value;
				state <= 4'd1;
				data_ready <= 1'b0;
				end
			else begin
				init_val <= init_val;
				state <= 4'd0;
				data_ready <= 1'b1;
				end
			end

		4'd1 : begin
			angle_combination_start <= 1'b1;
			state <= 4'd2;
			end

		4'd2 : begin
			if (angle_combination_done == 1'b1) begin
				state <= 4'd3;
				end
			else begin
				state <= 4'd2;
				end
			angle_combination_start <= 1'b0;
			end

		4'd3 : begin
			normalize_angle_start <= 1'b1;
			state <= 4'd4;
			end

		4'd4 : begin
			if (normalize_angle_done == 1'b1) begin
				state <= 4'd5;
				end
			else begin
				state <= 4'd4;
				end
			normalize_angle_start <= 1'b0;
			end

		4'd5 : begin
			term_accumulation_start <= 1'b1;
			state <= 4'd6;
			end

		4'd6 : begin
			if (term_accumulation_done == 1'b1) begin
				state <= 4'd7;
				end
			else begin
				state <= 4'd6;
				end
			term_accumulation_start <= 1'b0;
			end

		4'd7 : begin
			data_ready <= 1'b1;
			state <= 4'd0;
			end

		default : begin
			state <= 4'd0;
			data_ready <= 1'b1;
			angle_combination_start <= 1'b0;
			normalize_angle_start <= 1'b0;
			term_accumulation_start <= 1'b0;
			//term_division_start <= 1'b0;
			init_val <= 0;	//write a loop here
			end
		endcase
	end


/*
		4'd1 : begin
			for (i = 0; i <= (NUM_STATE_VAR-1); i=i+1) begin
				term_detail[i] <= ; 								//term details from memory
				angle_address <= ;
				sine_calc_cos_mode <= ;
				end

			if ([] == ) begin	//checking if trigo term present
				state <= 4'd2;
				end
			else begin
				state <= 4'd3;
				end

			end

		4'd2 : begin

*/


/*
4'd7 : begin
	term_division_start <= 1'b1;
	state <= 4'd8;
	end

4'd8 : begin
	if (term_division_done == 1'b1) begin
		state <= 4'd9;
		end
	else begin
		state <= 4'd8;
		end
	term_division_start <= 1'b0;
	end
*/