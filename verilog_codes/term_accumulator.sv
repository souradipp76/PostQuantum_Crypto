

module term_accumulator #(
	parameter DATA_WIDTH = 32,
	parameter CODE_WIDTH = 8)
	
	(
	input logic clock,
	input logic reset,
	input logic term_accumulator_start,

	input logic [DATA_WIDTH-1:0] mult_result,
	input logic [DATA_WIDTH-1:0] add_result,
	input logic [DATA_WIDTH-1:0] divide_result,
	input logic [DATA_WIDTH-1:0] exponent_result,
	input logic mult_data_ready,
	input logic add_data_ready,
	input logic divide_data_ready,
	input logic exponent_data_ready,

	output logic term_accumulator_mult_start,
	output logic term_accumulator_add_start,
	output logic term_accumulator_exponent_start,
	output logic term_accumulator_divide_start,
	output logic [DATA_WIDTH-1:0] term_accumulator_operand_a,
	output logic [DATA_WIDTH-1:0] term_accumulator_operand_b,
	output logic term_accumulator_output_ready);

///////////////////////////////////////////////
localparam POSTFIX_DATA_WIDTH = 9;
localparam POSTFIX_DATA_DEPTH = 1024;

///////////////////////////////////////////////
localparam STATE_DEFAULT = 4'd0;
localparam STATE_POSTFIX_TERM_READ = 4'd1;
localparam STATE_OPN = 4'd2;
localparam STATE_WAIT_OPN = 4'd3;
localparam STATE_WAIT_DATA_DECODE = 4'd4;
localparam STATE_PUSH_DATA_ALU = 4'd5;
localparam STATE_PUSH_DATA_DECODED = 4'd6;

///////////////////////////////////////////////
logic [3:0] state_term_accumulator;
logic [POSTFIX_DATA_WIDTH-1:0] term_detail_postfix;

///////////////////////////////////////////////
logic [$clog2(POSTFIX_DATA_DEPTH)-1:0] mem_term_detail_postfix_addr;
logic [POSTFIX_DATA_WIDTH-1:0] mem_term_detail_postfix_data_out;

///////////////////////////////////////////////
logic [DATA_WIDTH-1:0] stack_extension [1:0];
logic [1:0] stack_extension_read_pointer;

logic stack_push;
logic stack_pop;
logic [DATA_WIDTH-1:0] stack_push_value;
logic [DATA_WIDTH-1:0] stack_input;
logic [DATA_WIDTH-1:0] stack_output;

///////////////////////////////////////////////
logic decoder_const_start;
logic decoder_const_data_ready;

logic decoder_trigo_start;
logic decoder_trigo_data_ready;

logic decoder_state_var_key_val_start;
logic decoder_state_var_key_val_data_ready;

logic decoded_data_ready;
assign decoded_data_ready = decoder_const_data_ready | decoder_trigo_data_ready | decoder_state_var_key_val_data_ready;

logic [DATA_WIDTH-1:0] decoder_const_data;
logic [DATA_WIDTH-1:0] decoder_trigo_data;
logic [DATA_WIDTH-1:0] decoder_state_var_key_val_data;

logic [DATA_WIDTH-1:0] decoded_data;
assign decoded_data = decoder_const_data | decoder_trigo_data | decoder_state_var_key_val_data;	//OR of all decoded outputs	//Result is DATA_WIDTH

////////////////////////////////////////////////
logic alu_data_ready;
assign alu_data_ready = mult_data_ready | add_data_ready | divide_data_ready | exponent_data_ready;

logic alu_output;
assign alu_output = mult_result | add_result | divide_result | exponent_result;

/////////////////////////////////////////////////
always @(posedge clock) begin


case (state_term_accumulator)

	STATE_DEFAULT : begin
		case (term_accumulator_start)
			1'b1 : state_term_accumulator <= STATE_POSTFIX_TERM_READ;
			1'b0 : state_term_accumulator <= STATE_DEFAULT;
			endcase

		term_accumulator_output_ready<= 4'd0;
		stack_extension_read_pointer <= 2'b00;
		mem_term_detail_postfix_addr <= 0;
		end

	STATE_POSTFIX_TERM_READ : begin
		mem_term_detail_postfix_addr <= mem_term_detail_postfix_addr + 1;

		//decoder_constant_code <= mem_term_detail_postfix_data_out;
		//decoder_state_var_key_val_code <= mem_term_detail_postfix_data_out;
		term_detail_postfix <= mem_term_detail_postfix_data_out;

		stack_push <= 1'b0;

		case (mem_term_detail_postfix_data_out[CODE_WIDTH-1:CODE_WIDTH-1-1])
			2'b00 : decoder_const_start <= 1'b1; 
			2'b01 : decoder_state_var_key_val_start <= 1'b1;
			2'b11 : decoder_trigo_start <= 1'b1;
			endcase

		case (mem_term_detail_postfix_data_out[CODE_WIDTH-1:CODE_WIDTH-1-1])
			2'b10   : state_term_accumulator <= STATE_OPN;
			default : state_term_accumulator <= STATE_WAIT_DATA_DECODE;
			endcase
		end

	STATE_WAIT_DATA_DECODE : begin
		case (decoded_data_ready)
			1'b1    : state_term_accumulator <= STATE_PUSH_DATA_DECODED;
			default : state_term_accumulator <= STATE_WAIT_DATA_DECODE;
			endcase
		stack_push_value <= decoded_data;
		end

	STATE_PUSH_DATA_DECODED : begin
		
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
		state_term_accumulator <= STATE_POSTFIX_TERM_READ;
		end

	STATE_OPN : begin
		state_term_accumulator <= STATE_WAIT_OPN;

		term_accumulator_operand_a <= stack_extension[0];

		case (term_detail_postfix[CODE_WIDTH-1-5:0])
			3'b100 : term_accumulator_operand_b <= {stack_extension[1][DATA_WIDTH-1], stack_extension[1][DATA_WIDTH-2:0]};
			default  : term_accumulator_operand_b <= stack_extension[1];
			endcase

		case (term_detail_postfix[CODE_WIDTH-1-5:0])
			3'b100 : term_accumulator_add_start <= 1'b1;
			3'b011 : term_accumulator_add_start <= 1'b1;
			3'b010 : term_accumulator_mult_start <= 1'b1;
			3'b001 : term_accumulator_divide_start <= 1'b1;
			3'b000 : term_accumulator_exponent_start <= 1'b1;
			endcase
		end

	STATE_WAIT_OPN : begin
		term_accumulator_mult_start <= 1'b0;
		term_accumulator_add_start <= 1'b0;
		term_accumulator_exponent_start <= 1'b0;
		term_accumulator_divide_start <= 1'b0;

		case (alu_data_ready)
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


