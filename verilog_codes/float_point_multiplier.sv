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

module float_point_multiplier #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)

	(
	input logic clk,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] input_a,
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] input_b,

	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] output_product);

localparam BIAS = (2**(EXP_LEN-1)) - 1;

logic product_sign [4:0];
logic product_zero [4:0];
logic [EXP_LEN-1:0] product_exp [4:1];

logic zero_a;
logic zero_b;
assign zero_a = ~|input_a[EXP_LEN+MANTISSA_LEN-1:0];
assign zero_b = ~|input_b[EXP_LEN+MANTISSA_LEN-1:0];

logic [MANTISSA_LEN+1-1:0] mantissa_a;
logic [MANTISSA_LEN+1-1:0] mantissa_b;

logic [EXP_LEN-1:0] exp_a;
logic [EXP_LEN-1:0] exp_b;

logic [MANTISSA_LEN+1-1:0] mantissa_prod_h_h;
logic [MANTISSA_LEN+1-1:0] mantissa_prod_l_h;
logic [MANTISSA_LEN+1-1:0] mantissa_prod_h_l;
logic [MANTISSA_LEN+1-1:0] mantissa_prod_l_l;

logic [MANTISSA_LEN+1-1:0] mantissa_prod_sum_1;
logic [MANTISSA_LEN+MANTISSA_LEN:(MANTISSA_LEN+1)/2] mantissa_prod_sum_2;

logic [MANTISSA_LEN+MANTISSA_LEN+1:(MANTISSA_LEN+1)/2] product_mantissa;


logic [EXP_LEN-1:0] product_exp_adjusted;
logic [MANTISSA_LEN-1:0] product_mantissa_adjusted;

logic zero_product[3:0];

assign output_product = {product_sign[4], product_exp_adjusted, product_mantissa_adjusted};

always @(posedge clk) begin
	///////////////////////////////////////////////////////////////////////////////////
	if (zero_product[3] == 1'b1) begin
		product_exp_adjusted <= 0;
		product_mantissa_adjusted <= 0;
		product_sign[4] <= 0;
		end

	else begin

		case (product_mantissa[MANTISSA_LEN+MANTISSA_LEN+1:MANTISSA_LEN+MANTISSA_LEN])
			2'b10 : begin
				product_exp_adjusted <= product_exp[3] + 1;//
				product_mantissa_adjusted <= product_mantissa[MANTISSA_LEN+MANTISSA_LEN:MANTISSA_LEN+1];
				end

			2'b11 : begin
				product_exp_adjusted <= product_exp[3] + 1;//
				product_mantissa_adjusted <= product_mantissa[MANTISSA_LEN+MANTISSA_LEN:MANTISSA_LEN+1];
				end

			default : begin
				product_exp_adjusted <= product_exp[3];
				product_mantissa_adjusted <= product_mantissa[MANTISSA_LEN+MANTISSA_LEN+1:MANTISSA_LEN+1+1];
				end
			endcase

		product_sign[4] <= product_sign[3];
		end
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	product_mantissa <= mantissa_prod_sum_1 + mantissa_prod_sum_2;

	product_sign[3] <= product_sign[2];
	product_zero[3] <= product_zero[2];
	product_exp[3] <= product_exp[2];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	product_exp[2] <= product_exp[1] - BIAS;
	mantissa_prod_sum_1 <= mantissa_prod_l_h + mantissa_prod_h_l;
	mantissa_prod_sum_2 <= {mantissa_prod_h_h, mantissa_prod_l_l[MANTISSA_LEN:(MANTISSA_LEN+1)/2]};

	product_sign[2] <= product_sign[1];
	product_zero[2] <= product_zero[1];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	product_exp[1] <= exp_a + exp_b;
	mantissa_prod_h_h <= mantissa_a[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2]*mantissa_b[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2];
	mantissa_prod_l_h <= mantissa_a[((MANTISSA_LEN+1)/2)-1:0]*mantissa_b[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2];
	mantissa_prod_h_l <= mantissa_a[MANTISSA_LEN+1-1:(MANTISSA_LEN+1)/2]*mantissa_b[((MANTISSA_LEN+1)/2)-1:0];
	mantissa_prod_l_l <= mantissa_a[((MANTISSA_LEN+1)/2)-1:0]*mantissa_b[((MANTISSA_LEN+1)/2)-1:0];

	product_sign[1] <= product_sign[0];
	product_zero[1] <= product_zero[0];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	exp_a <= input_a[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];
	exp_b <= input_b[MANTISSA_LEN+EXP_LEN-1:MANTISSA_LEN];

	mantissa_a <= {1'b1, input_a[MANTISSA_LEN-1:0]};
	mantissa_b <= {1'b1, input_b[MANTISSA_LEN-1:0]};
	
	product_sign[0] <= input_a[MANTISSA_LEN+EXP_LEN+1-1]^input_b[MANTISSA_LEN+EXP_LEN+1-1];
	product_zero[0] <= (~(zero_a && zero_b));
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
end

endmodule