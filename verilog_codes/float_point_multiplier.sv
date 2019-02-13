////////////////////////////////////////////////////////
//				float_point_multiplier.sv
//
//This is a floating point multiplier with parameters to
//set the number of bits in mantissa and exponent.
//
//::Parameters::
//EXP_LEN => no. of bits in exponent
//MANTISSA_LEN => no. of bits in mantissa
//
////////////////////////////////////////////////////////

module float_point #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)

	(
	input logic clk,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] a,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] b,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] product);

logic [EXP_LEN-1:0] exp_a [:0];
logic [EXP_LEN-1:0] exp_b [:0];

logic [MANTISSA_LEN+1-1:0] mantissa_a [:0];
logic [MANTISSA_LEN+1-1:0] mantissa_b [:0];

logic [EXP_LEN-1:0] exp_product [:0];
logic sign_product [:0];

always @(posedge clk) begin
	///////////////////////////////////////////////////////////////////////////////////
	if (zero_product[3] == 1'b1) begin
		product_exp_adjusted <= 0;
		product_mantissa_adjusted <= 0;
		product_sign[4] <= 0;
		end // if (zero_product[3] == 1'b1)

	else begin

		case (prod_mantissa[])
			2'b10 : begin
				product_exp_adjusted <= product_exp[3] + 'd1;//
				product_mantissa_adjusted <= product_mantissa[];
				end

			2'b11 : begin
				product_exp_adjusted <= product_exp[3] + 'd1;//
				product_mantissa_adjusted <= product_mantissa[];
				end

			default : begin
				product_exp_adjusted <= product_exp[3];
				product_mantissa_adjusted <= product_mantissa[];
				end
			endcase

		product_sign[4] <= product_sign[3];
		end
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	product_mantissa <= mantissa_prod_sum_1 + mantissa_prod_sum_2;

	product_sign[3] <= product_sign[2];
	product_zero[3] <= product_zero[2];
	product_exp[3] <= exp_product[2];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	product_exp[2] <= product_exp[1] - BIAS;
	mantissa_prod_sum_1 <= inp_mantissa_prod_l_h + inp_mantissa_prod_h_l;
	mantissa_prod_sum_2 <= {inp_mantissa_prod_h_h, inp_mantissa_prod_l_l[MANTISSA_LEN:(MANTISSA_LEN+1)/2]};

	product_sign[2] <= product_sign[1];
	product_zero[2] <= product_zero[1];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	product_exp[1] <= inp_exp_a + inp_exp_b;
	inp_mantissa_prod_h_h <= inp_mantissa_a[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2]*inp_mantissa_b[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2];
	inp_mantissa_prod_l_h <= inp_mantissa_a[((MANTISSA_LEN+1)/2)-1:0]*inp_mantissa_b[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2];
	inp_mantissa_prod_h_l <= inp_mantissa_a[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2]*inp_mantissa_b[((MANTISSA_LEN+1)/2)-1:0];
	inp_mantissa_prod_l_l <= inp_mantissa_a[((MANTISSA_LEN+1)/2)-1:0]*inp_mantissa_b[((MANTISSA_LEN+1)/2)-1:0];

	product_sign[1] <= product_sign[0];
	product_zero[1] <= product_zero[0];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	inp_exp_a <= a[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
	inp_exp_b <= b[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];

	inp_mantissa_a <= {1'b1, a[MANTISSA_LEN-1:0]};
	inp_mantissa_b <= {1'b1, b[MANTISSA_LEN-1:0]};
	
	product_sign[0] <= a[MANTISSA_LEN+EXP_LEN+1-1]^b[MANTISSA_LEN+EXP_LEN+1-1];
	product_zero[0] <= (~(zero_a && zero_b));
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
end

endmodule // float_point