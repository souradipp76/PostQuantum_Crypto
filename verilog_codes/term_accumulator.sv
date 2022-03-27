//Add ROM with postfix details

module term_accumulator #(
	parameter DATA_WIDTH = 32,
	parameter CODE_WIDTH = 8,
	parameter NUM_KEY_VAL = 10,
	parameter NUM_STATE_VAR = 9,
	parameter ANGLE_ADDR_WIDTH = 22,
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)
	
	(
	input logic clock,
	input logic clock_mem,
	input logic reset,
	input logic term_accumulator_start,
	input logic [1:0] expression_index,

	input logic [DATA_WIDTH-1:0] mult_result,
	input logic [DATA_WIDTH-1:0] add_result,
	input logic [DATA_WIDTH-1:0] divide_result,
	input logic [DATA_WIDTH-1:0] exponent_result,

	input logic mult_data_ready,
	input logic add_data_ready,
	input logic divide_data_ready,
	input logic exponent_data_ready,

	input logic [DATA_WIDTH-1:0] mem_angle_normalized_data_out,
	input logic [DATA_WIDTH-1:0] mem_key_val_data_out,
	input logic [DATA_WIDTH-1:0] mem_state_var_data_out,

	output logic mult_start,
	output logic add_start,
	output logic exponent_start,
	output logic divide_start,

	output logic [DATA_WIDTH-1:0] operand_a,
	output logic [DATA_WIDTH-1:0] operand_b,

	output logic [ANGLE_ADDR_WIDTH-1:0] mem_angle_normalized_addr,
	output logic [$clog2(NUM_KEY_VAL)-1:0] mem_key_val_addr,
	output logic [$clog2(NUM_STATE_VAR)-1:0] mem_state_var_addr,

	output logic [DATA_WIDTH-1:0] output_value,
	output logic output_ready);

///////////////////////////////////////////////
localparam POSTFIX_DATA_WIDTH = CODE_WIDTH;     //localparam POSTFIX_DATA_WIDTH = 9;
localparam POSTFIX_DATA_DEPTH = 1425;
localparam POSTFIX_DATA_END_CODE = {CODE_WIDTH{1'b1}};

///////////////////////////////////////////////
localparam STATE_DEFAULT = 4'd0;
localparam STATE_POSTFIX_TERM_READ = 4'd1;
localparam STATE_OPN = 4'd2;
localparam STATE_WAIT_OPN = 4'd3;
localparam STATE_WAIT_DATA_DECODE = 4'd4;
localparam STATE_PUSH_DATA_ALU = 4'd5;
localparam STATE_PUSH_DATA_DECODED = 4'd6;
localparam STATE_DATA_OUT = 4'd7;

///////////////////////////////////////////////
logic [3:0] state_term_accumulator;
logic [POSTFIX_DATA_WIDTH-1:0] term_detail_postfix;
logic [POSTFIX_DATA_WIDTH-1:0] term_detail_postfix_wire;
logic [1:0] expression_index_reg;

///////////////////////////////////////////////
logic [$clog2(POSTFIX_DATA_DEPTH)-1:0] mem_term_detail_postfix_addr;
logic [POSTFIX_DATA_WIDTH-1:0] mem_term_detail_postfix_data_out [2:0];

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

////////////////////////////////////////////////
logic [DATA_WIDTH-1:0] sine_calc_sin_value;
logic sine_calc_done;

logic [DATA_WIDTH-1:0] decoder_trigo_angle;
logic decoder_trigo_sine_cosine;
logic decoder_trigo_sine_calc_start;

///////////////////////////////////////////////////
decoder_type_1 #(
	.DATA_WIDTH(DATA_WIDTH),
	.CODE_WIDTH(CODE_WIDTH)
) decoder_constants (
	.clock        (clock),
	.decode_start (decoder_const_start),
	.inp_code     (term_detail_postfix),
	.data_ready   (decoder_const_data_ready),
	.out_value    (decoder_const_data)
);


decoder_type_2 #(
	.DATA_WIDTH(DATA_WIDTH),
	.CODE_WIDTH(CODE_WIDTH),
	.MEM_ADDR_WIDTH($clog2(NUM_KEY_VAL))
) decoder_key_val_state_var (
	.clock                  (clock),
	.decode_start           (decoder_state_var_key_val_start),
	.inp_code               (term_detail_postfix),
	.mem_key_val_data_out   (mem_key_val_data_out),
	.mem_state_var_data_out (mem_state_var_data_out),
	.mem_key_val_addr       (mem_key_val_addr),
	.mem_state_var_addr     (mem_state_var_addr),
	.out_value              (decoder_state_var_key_val_data),
	.data_ready             (decoder_state_var_key_val_data_ready)
);


decoder_type_3 #(
	.DATA_WIDTH(DATA_WIDTH),
	.CODE_WIDTH(CODE_WIDTH),
	.ANGLE_ADDR_WIDTH(ANGLE_ADDR_WIDTH)
) decoder_trigo (
	.clock                         (clock),
	.decode_start                  (decoder_trigo_start),
	.inp_code                      (term_detail_postfix),
	.inp_sine_cosine_value         (sine_calc_sin_value),
	.mem_angle_normalized_data_out (mem_angle_normalized_data_out),
	.mem_angle_normalized_addr     (mem_angle_normalized_addr),
	.sin_calc_start                (decoder_trigo_sine_calc_start),
	.out_angle                     (decoder_trigo_angle),
	.out_sine_cosine               (decoder_trigo_sine_cosine),
	.data_ready                    (decoder_trigo_data_ready),
	.out_value                     (decoder_trigo_data)
);


sine_calculator #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN)
) inst_sine_calculator (
	.clk             (clock),
	.inp_data_ready  (decoder_trigo_sine_calc_start),
	.inp_theta       (decoder_trigo_angle),
	.inp_sine_cosine (decoder_trigo_sine_cosine),
	.out_value       (sine_calc_sin_value),
	.out_data_ready  (sine_calc_done)
);


logic stack_reset;
stack #(
	.DATA_WIDTH(DATA_WIDTH),
	.DEPTH(64)
) inst_stack (
	.clock       (clock),
	.clock_mem   (clock_mem),
	.reset       (stack_reset),
	.inp_data    (stack_input),
	.push        (stack_push),
	.pop         (stack_pop),
	.out_data    (stack_output),
	.stack_empty (stack_empty),
	.stack_full  (stack_full)
);

rams_sp_rom_pf1 #(
) inst_rams_sp_rom_pf1 (
	.clock   (clock_mem),
	.enable  (1),
	.address (mem_term_detail_postfix_addr),
	.dout    (mem_term_detail_postfix_data_out[0])
);

rams_sp_rom_pf2 #(
) inst_rams_sp_rom_pf2 (
	.clock   (clock_mem),
	.enable  (1),
	.address (mem_term_detail_postfix_addr),
	.dout    (mem_term_detail_postfix_data_out[1])
);

rams_sp_rom_pf3 #(
) inst_rams_sp_rom_pf3 (
	.clock   (clock_mem),
	.enable  (1),
	.address (mem_term_detail_postfix_addr),
	.dout    (mem_term_detail_postfix_data_out[2])
);

always @(*) begin
	case (expression_index)
		2'b00 : term_detail_postfix_wire = mem_term_detail_postfix_data_out[0];
		2'b01 : term_detail_postfix_wire = mem_term_detail_postfix_data_out[1];
		2'b10 : term_detail_postfix_wire = mem_term_detail_postfix_data_out[2];
		default : term_detail_postfix_wire = mem_term_detail_postfix_data_out[0];
		endcase
	end

/////////////////////////////////////////////////
always @(posedge clock) begin


case (state_term_accumulator)

	STATE_DEFAULT : begin
		case (term_accumulator_start)
			1'b1 : state_term_accumulator <= STATE_POSTFIX_TERM_READ;
			1'b0 : state_term_accumulator <= STATE_DEFAULT;
			endcase

		output_ready <= 4'd0;
		stack_extension_read_pointer <= 2'b00;
		mem_term_detail_postfix_addr <= 0;
		expression_index_reg <= expression_index;
		stack_reset <= 1'b1;
		end

	STATE_POSTFIX_TERM_READ : begin
		mem_term_detail_postfix_addr <= mem_term_detail_postfix_addr + 1;
		term_detail_postfix <= term_detail_postfix_wire;

		stack_push <= 1'b0;
		stack_reset <= 1'b0;

		case (term_detail_postfix_wire[CODE_WIDTH-1:CODE_WIDTH-1-1])
			2'b00 : decoder_const_start <= 1'b1; 
			2'b01 : decoder_state_var_key_val_start <= 1'b1;
			2'b11 : decoder_trigo_start <= 1'b1;
			default : decoder_const_start <= 1'b0;
			endcase

		case (term_detail_postfix_wire[CODE_WIDTH-1:CODE_WIDTH-1-1])
			2'b10   : state_term_accumulator <= STATE_OPN;
			default : state_term_accumulator <= STATE_WAIT_DATA_DECODE;
			endcase
		end

	STATE_WAIT_DATA_DECODE : begin

		decoder_const_start <= 1'b0;
		decoder_state_var_key_val_start <= 1'b0;
		decoder_trigo_start <= 1'b0;

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

		operand_a <= stack_extension[0];

		case (term_detail_postfix[CODE_WIDTH-1-5:0])
			3'b100 : operand_b <= {~stack_extension[1][DATA_WIDTH-1], stack_extension[1][DATA_WIDTH-2:0]};
			default  : operand_b <= stack_extension[1];
			endcase

		case (term_detail_postfix[CODE_WIDTH-1-5:0])
			3'b100 : add_start <= 1'b1;
			3'b011 : add_start <= 1'b1;
			3'b010 : divide_start <= 1'b1;
			3'b001 : mult_start <= 1'b1;
			3'b000 : exponent_start <= 1'b1;
			endcase
		end

	STATE_WAIT_OPN : begin
		mult_start <= 1'b0;
		add_start <= 1'b0;
		exponent_start <= 1'b0;
		divide_start <= 1'b0;

		case (alu_data_ready)
			1'b1 : begin
				state_term_accumulator <= STATE_PUSH_DATA_ALU;
				stack_pop <= (1'b1 & (~stack_empty));
				end
			default : begin
				state_term_accumulator <= STATE_WAIT_OPN;
				stack_pop <= 1'b0;
				end
			endcase

		case (term_detail_postfix[CODE_WIDTH-1-5:0])
			3'b100 : stack_push_value <= add_result;
			3'b011 : stack_push_value <= add_result;
			3'b010 : stack_push_value <= divide_result;
			3'b001 : stack_push_value <= mult_result;
			3'b000 : stack_push_value <= exponent_result;
			endcase
		end

	STATE_PUSH_DATA_ALU : begin
		//stack_extension[1] <= stack_push_value;
		//stack_extension[0] <= stack_output;

		case (stack_empty)
			1'b0 : begin
				stack_extension[1] <= stack_push_value;
				stack_extension[0] <= stack_output;
				stack_extension_read_pointer <= 2'b11;
				end
			1'b1 : begin
				stack_extension[1] <= 0;
				stack_extension[0] <= stack_push_value;
				stack_extension_read_pointer <= 2'b01;
				end
			endcase

		stack_pop <= 1'b0;

		case (term_detail_postfix_wire)
			POSTFIX_DATA_END_CODE : state_term_accumulator <= STATE_DATA_OUT;
			default : state_term_accumulator <= STATE_POSTFIX_TERM_READ;
			endcase
		end

	STATE_DATA_OUT : begin
		output_ready <= 1'b1;
		output_value <= stack_extension[0];
		state_term_accumulator <= STATE_DEFAULT;
		end

	default : begin
		state_term_accumulator <= STATE_DEFAULT;
		mult_start <= 1'b0;
		add_start <= 1'b0;
		exponent_start <= 1'b0;
		divide_start <= 1'b0;
		stack_pop <= 1'b0;
		stack_push <= 1'b0;
		end
	endcase
end

endmodule


