//2 stage pipeline

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


localparam SIG_MANTISSA_BITS = 6;

logic [3:0] state_sine_calculator;

logic [EXP_LEN-1:0] theta_exp;
logic [MANTISSA_LEN-1:0] theta_mantissa;
logic theta_sign;

logic sine_cosine;

logic [SIG_MANTISSA_BITS-1:0] mem_sine_cosine_lut_addr;
logic [EXP_LEN+MANTISSA_LEN+1-1:0] mem_sine_cosine_lut_data_out [2**(EXP_LEN)-1:0];

always @(posedge clk) begin
	////////////////////////////////////////////////////////////////
	if (enable) begin
		theta_exp <= inp_theta[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
		theta_sign <= inp_theta[MANTISSA_LEN+EXP_LEN+1-1];
		sine_cosine <= inp_sine_cosine;
		mem_sine_cosine_lut_addr <= theta_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-(SIG_MANTISSA_BITS-1)-1];
		//theta_mantissa <= inp_theta[MANTISSA_LEN-1:0];
		end

	else begin
		theta_exp <= 0;
		theta_sign <= 0;
		sine_cosine <= 0;
		mem_sine_cosine_lut_addr <= 0;
		//theta_mantissa <= 0;
		end
	////////////////////////////////////////////////////////////////////
	case ({sine_cosine, theta_sign})
		2'b11 : begin
			out_value <= {~mem_sine_cosine_lut_data_out[theta_exp][MANTISSA_LEN+EXP_LEN+1-1], mem_sine_cosine_lut_data_out[theta_exp][MANTISSA_LEN+EXP_LEN+1-1-1:0]};
			end
		default : begin
			out_value <= mem_sine_cosine_lut_data_out[theta_exp];
			end
		endcase
	/////////////////////////////////////////////////////////////////////
	end

rams_sp_rom_angle_sine_val_exp0 #(
    .MEM_WIDTH(32),
    .MEM_DEPTH(64)
) inst_rams_sp_rom_sine_val_exp0 (
    .clock   (clk),
    .enable  (1),
    .address (mem_sine_cosine_lut_addr),
    .dout    (mem_sine_cosine_lut_data_out[0])
);

rams_sp_rom_angle_sine_val_exp1 #(
    .MEM_WIDTH(32),
    .MEM_DEPTH(64)
) inst_rams_sp_rom_sine_val_exp1 (
    .clock   (clk),
    .enable  (1),
    .address (mem_sine_cosine_lut_addr),
    .dout    (mem_sine_cosine_lut_data_out[1])
);


endmodule // sine_calculator