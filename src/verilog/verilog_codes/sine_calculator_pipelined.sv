//3 stage pipeline

module sine_calculator #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23) 

	(
	input logic clk,
	input logic enable,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] inp_theta,
	input logic inp_sine_cosine,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] out_value,
	output logic out_data_ready);


localparam SIG_MANTISSA_BITS = 3;

logic [3:0] state_sine_calculator;

logic [EXP_LEN-1:0] theta_exp;
logic [MANTISSA_LEN-1:0] theta_mantissa;
logic theta_sign [1:0];

logic sine_cosine [1:0];

logic [SIG_MANTISSA_BITS-1:0] mem_sine_cosine_lut_addr;

logic [EXP_LEN+MANTISSA_LEN+1-1:0] sine_cosine_value;

logic [EXP_LEN+MANTISSA_LEN+1-1:0] mem_sine_cosine_lut_data_out [2**(EXP_LEN)-1:0];

always @(posedge clk) begin
	////////////////////////////////////////////////////////////////
	if (enable) begin
		theta_exp <= inp_theta[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
		theta_sign[0] <= inp_theta[MANTISSA_LEN+EXP_LEN+1-1];
		sine_cosine[0] <= inp_sine_cosine;
		mem_sine_cosine_lut_addr <= theta_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-(SIG_MANTISSA_BITS-1)-1];
		//theta_mantissa <= inp_theta[MANTISSA_LEN-1:0];
		end

	else begin
		theta_exp <= 0;
		theta_sign[0] <= 0;
		sine_cosine[0] <= 0;
		mem_sine_cosine_lut_addr <= 0;
		//theta_mantissa <= 0;
		end
	////////////////////////////////////////////////////////////////////
	sine_cosine_value <= mem_sine_cosine_lut_data_out[theta_exp];

	theta_sign[1] <= theta_sign[0];
	sine_cosine[1] <= sine_cosine[0];
	////////////////////////////////////////////////////////////////////
	case ({sine_cosine[1], theta_sign[1]})
		2'b11 : begin
			out_value <= {~sine_cosine_value[MANTISSA_LEN+EXP_LEN+1-1], sine_cosine_value[MANTISSA_LEN+EXP_LEN+1-1-1:0]};
			end
		default : begin
			out_value <= sine_cosine_value;
			end
		endcase
	/////////////////////////////////////////////////////////////////////
	end

endmodule // sine_calculator