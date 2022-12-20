`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:44 02/13/2019 
// Design Name: 
// Module Name:    angle_normalization 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//				angle_normalization.sv
//
//This module normalizes the input angle (in radians) to
//a value between 0 to 2*PI
//
//::Parameters::
//EXP_LEN		=> No. of bits of exponent in floating point notation
//MANTISSA_LEN	=> No. of bits of mantissa in floating point notation
//
//////////////////////////////////////////////////////////////////////////

module angle_normalization #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)

	(
	input logic clk,
	input logic reset,
	input logic input_data_ready,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] input_angle,

	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_normalization_add_sum,
	input logic angle_normalization_add_ready,

	output logic output_angle_normalization_done,
	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] output_normalized_angle,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_normalization_add_a,
	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_normalization_add_b,
	output logic angle_normalization_add_start);

localparam PI_MANTISSA = ;
localparam EXP_BIAS = 127;

logic [3:0] state_angle_normalization;

logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_magnitude;
logic angle_sign;

logic [EXP_LEN-1:0] angle_excess_exponent;


always @(posedge clk) begin

	case (state_angle_normalization)

		4'd0 : begin
			if (input_data_ready == 1'b1) begin
				state_angle_normalization <= 4'd1;
				end
			else begin
				state_angle_normalization <= 4'd0;
				end
			output_angle_normalization_done <= 1'b0;

			angle_magnitude <= {1'b0, input_angle[EXP_LEN+MANTISSA_LEN-1:0]};
			angle_sign <= input_angle[EXP_LEN+MANTISSA_LEN];
			end

		4'd1 : begin
			if (angle[MANTISSA_LEN-1:0] > PI_MANTISSA) begin
				angle_excess_exponent <= angle_magnitude[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
				end
			else begin
				angle_excess_exponent <= angle_magnitude[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN] - 1;
				end
			state_angle_normalization <= 4'd2;
			end

		4'd2 : begin
			angle_normalization_add_a <= angle_magnitude;
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
			if (angle_magnitude[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN] > ((EXP_BIAS + 8'd1)) begin
				state_angle_normalization <= 4'd1;
				end

			else begin
				if (angle_magnitude[MANTISSA_LEN-1:0] > PI_MANTISSA) begin
					state_angle_normalization <= 4'd1;
					end
				else begin
					state_angle_normalization <= 4'd6;
					end
				end
			end

		4'd6 : begin
			if (angle_sign == 1'b0) begin
				state_angle_normalization <= 4'd8;
				end
			else begin
				state_angle_normalization <= 4'd7;
				angle_normalization_add_start <= 1'b1;
				end

			angle_normalization_add_a <= {angle_sign, angle_magnitude[EXP_LEN+MANTISSA_LEN-1:0]};
			angle_normalization_add_b <= {1'b0, (EXP_BIAS+1), PI_MANTISSA};
			end

		4'd7 : begin
			angle_normalization_add_start <= 1'b0;
			angle_magnitude <= angle_normalization_add_sum;

			if (angle_normalization_add_ready == 1'b1) begin
				state_angle_normalization <= 4'd8;
				end
			else begin
				state_angle_normalization <= 4'd7;
				end
			end

		4'd8 : begin
			output_normalized_angle <= {1'b0, angle_magnitude[EXP_LEN+MANTISSA_LEN-1:0]};
			output_angle_normalization_done <= 1'b1;

			state_angle_normalization <= 4'd0;
			end

		default : begin
			state_angle_normalization <= 4'd0;
			output_angle_normalization_done <= 1'b0;
			output_normalized_angle <= 0;
			end

		endcase
	end

endmodule

