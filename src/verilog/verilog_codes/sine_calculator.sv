module sine_calculator #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23) 

	(
	input logic clk,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] inp_theta,
	input logic inp_sine_cosine,
	input logic inp_data_ready,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] out_value,
	output logic out_data_ready);


localparam SIG_MANTISSA_BITS = 3;

logic [3:0] state_sine_calculator;

logic [EXP_LEN-1:0] theta_exp;
logic [MANTISSA_LEN-1:0] theta_mantissa;
logic theta_sign;

logic sine_cosine;

logic [SIG_MANTISSA_BITS-1:0] mem_sine_cosine_lut_addr;

logic [EXP_LEN+MANTISSA_LEN+1-1:0] sine_cosine_value;
logic [EXP_LEN+MANTISSA_LEN+1-1:0] sine_cosine_value_adjusted;

logic [EXP_LEN+MANTISSA_LEN+1-1:0] mem_sine_cosine_lut_data_out [2**(EXP_LEN)-1:0];

always @(posedge clk) begin

	case (state_sine_calculator) begin

		4'd0 : begin
			if (inp_data_ready == 1'b1) begin
				state_sine_calculator <= 4'd1;
				end
			else begin
				state_sine_calculator <= 4'd0;
				end
			theta_exp <= inp_theta[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
			theta_mantissa <= inp_theta[MANTISSA_LEN-1:0];
			theta_sign <= inp_theta[MANTISSA_LEN+EXP_LEN+1-1];

			sine_cosine <= inp_sine_cosine;
			end

		4'd1 : begin
			mem_sine_cosine_lut_addr <= theta_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-(SIG_MANTISSA_BITS-1)-1];
			state_sine_calculator <= 4'd2;
			end

		4'd2 : begin
			sine_cosine_value <= mem_sine_cosine_lut_data_out[theta_exp];
			state_sine_calculator <= 4'd3;
			end

		4'd3 : begin
			case ({sine_cosine, theta_sign})
				2'b11 : begin
					sine_cosine_value_adjusted <= {~sine_cosine_value[MANTISSA_LEN+EXP_LEN+1-1], sine_cosine_value[MANTISSA_LEN+EXP_LEN+1-1-1:0]};
					end
				default : begin
					sine_cosine_value_adjusted <= sine_cosine_value;
					end
				endcase
			state_sine_calculator <= 4'd4;
			end

		4'd4 : begin
			state_sine_calculator <= 4'd0;
			out_value <= sine_cosine_value_adjusted;
			end
		endcase
	end

endmodule // sine_calculator

