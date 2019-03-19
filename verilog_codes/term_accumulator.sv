

module term_accumulator #(
	parameter DATA_WIDTH = 32)
	
	(
	input logic clock,
	input logic reset,

	output logic );

localparam POSTFIX_DATA_WIDTH = 9;

localparam STATE_DEFAULT = 4'd0;
localparam STATE_POSTIX_TERM_READ = 4'd1;

logic [DATA_WIDTH-1:0] stack_extension [1:0];
logic [1:0] stack_extension_read_pointer;


assign decoded_data = ;	//OR of all decoded outputs	//Result is DATA_WIDTH

always @(posedge clock) begin

case (state_term_accumulator)

	STATE_DEFAULT : begin
		case (term_accumulator_start)
			1'b1 : state_term_accumulator <= STATE_POSTIX_TERM_READ;
			1'b0 : state_term_accumulator <= STATE_DEFAULT;
			endcase

		output_ready <= 4'd0;
		stack_extension_read_pointer <= 2'b00;
		end

	STATE_POSTFIX_TERM_READ : begin
		mem_term_detail_postfix_addr <= mem_term_detail_postfix_addr + 1;

		decoder_constant_code <= mem_term_detail_postfix_data_out;
		decoder_state_var_key_val_code <= mem_term_detail_postfix_data_out;
		term_detail_postfix <= mem_term_detail_postfix_data_out;

		stack_push <= 1'b0;

		case (mem_term_detail_postfix_data_out[])
			2'b00 : decoder_const_start <= 1'b1; 
			2'b01 : decoder_state_var_key_val_start <= 1'b1;
			2'b11 : decoder_trigo_start <= 1'b1;
			endcase

		case (mem_term_detail_postfix_data_out[])
			2'b10   : state_term_accumulator <= STATE_OPN
			default : state_term_accumulator <= STATE_WAIT_DATA_DECODE;
			endcase
		end

	STATE_WAIT_DATA_DECODE : begin
		case (decoded_data_ready)
			1'b1    : state_term_accumulator <= STACK_PUSH_DATA_DECODED;
			default : state_term_accumulator <= STATE_WAIT_DATA_DECODE;
			endcase
		stack_push_value <= decoded_data;
		end

	STACK_PUSH_DATA_DECODED : begin
		
		case (stack_extension_read_pointer)

			2'b11 : begin
				stack_push <= 1'b1;
				stack_input <= stack_extension[0];
				stack_extension[0] <= stack_extension[1];
				stack_extension[1] <= stack_push_value;
				stack_extension_read_pointer <= 2'b11;
				end

			2'b01 : begin
				stack_push <= 1'b0;
				stack_input <= stack_extension[0];
				stack_extension[0] <= stack_extension[0];
				stack_extension[1] <= stack_push_value;
				stack_extension_read_pointer <= 2'b11;
				end

			2'b00 : begin
				stack_push <= 1'b0;
				stack_input <= stack_extension[0];
				stack_extension[0] <= stack_push_value;
				stack_extension[1] <= stack_push_value;
				stack_extension_read_pointer <= 2'b01;
				end

			default : begin
				stack_push <= 1'b0;
				stack_input <= stack_extension[0];
				stack_extension[0] <= stack_extension[1];
				stack_extension[1] <= stack_push_value;
				stack_extension_read_pointer <= 2'b11;
				end
			endcase
		state_term_accumulator <= STATE_POSTIX_TERM_READ;
		end

	STATE_OPN : begin
		state_term_accumulator <= STATE_WAIT_OPN;

		operand_a <= stack_extension[0];

		case (term_detail_postfix[])
			5'b10010 : operand_b <= {stack_extension[1][DATA_WIDTH-1], stack_extension[1][DATA_WIDTH-2:0]};
			default  : operand_b <= stack_extension[1];
			endcase

		case (term_detail_postfix[])
			5'b10000 : term_accumulator_mult_start <= 1'b1;
			5'b10001 : term_accumulator_add_start <= 1'b1;
			5'b10010 : term_accumulator_add_start <= 1'b1;
			5'b10011 : term_accumulator_divide_start <= 1'b1;
			5'b10100 : term_accumulator_exponent_start <= 1'b1;
			endcase
		end

	STATE_WAIT_OPN : begin
		term_accumulator_mult_start <= 1'b0;
		term_accumulator_add_start <= 1'b0;
		term_accumulator_exponent_start <= 1'b0;
		term_accumulator_divide_start <= 1'b0;

		case (ALU_data_ready)
			1'b1 : begin
				state_term_accumulator <= STATE_PUSH_DATA_ALU;
				stack_pop <= 1'b1;
				end
			default : begin
				state_term_accumulator <= STATE_WAIT_OPN;
				stack_pop <= 1'b0;
				end
			endcase
		stack_push_value <= alu_output;
		end

	STATE_PUSH_DATA_ALU : begin
		stack_extension[1] <= stack_push_value;
		stack_extension[0] <= stack_output;

		stack_pop <= 1'b0;

		state_term_accumulator <= STATE_POSTFIX_TERM_READ;
		end

	default : begin
		state_term_accumulator <= STATE_DEFAULT;
		end
	endcase
end

endmodule


