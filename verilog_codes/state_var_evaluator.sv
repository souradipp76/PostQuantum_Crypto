/////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////

module exp_evaluator #(
	parameter NUM_INIT_VAL = 6,
	parameter NUM_EVAL_VAL = 3,
	parameter NUM_KEY_VAL = 23,
	parameter NUM_ANGLE_COMB = 21,
	parameter EXP_LEN = 8,
    parameter MANTISSA_LEN = 23,
    parameter CODE_WIDTH = 8,
    parameter DATA_WIDTH = 32)
	
	(
		input logic clock,
		input logic clock_mem,
		input logic start_exp_evaluator,
		input logic reset,

		input logic [DATA_WIDTH-1:0] mem_state_var_read_data_out,
		input logic [DATA_WIDTH-1:0] mem_key_val_data_out,


		input logic mult_result_ready,
		input logic [DATA_WIDTH-1:0] mult_result,
		
		input logic add_result_ready [1:0],
		input logic [DATA_WIDTH-1:0] add_result [1:0],
		
		input logic exponent_result_ready,
		input logic [DATA_WIDTH-1:0] exponent_result,
		
		input logic div_result_ready,
		input logic [DATA_WIDTH-1:0] div_result,


		output logic [$clog2(NUM_INIT_VAL+NUM_EVAL_VAL)-1:0] mem_state_var_read_addr,
		output logic [$clog2(NUM_INIT_VAL+NUM_EVAL_VAL)-1:0] mem_state_var_write_addr,
		output logic [DATA_WIDTH-1:0] mem_state_var_write_data_in,
		output logic mem_state_var_write_we,

		output logic [$clog2(NUM_KEY_VAL)-1:0] mem_key_val_addr,
		
		output logic [DATA_WIDTH-1:0] mult_operand_a,
        output logic [DATA_WIDTH-1:0] mult_operand_b,
        output logic mult_start,
        
        output logic [DATA_WIDTH-1:0] add_operand_a [1:0],
        output logic [DATA_WIDTH-1:0] add_operand_b [1:0],
        output logic add_start [1:0],
        
        output logic [DATA_WIDTH-1:0] exponent_operand_a,
        output logic [DATA_WIDTH-1:0] exponent_operand_b,
        output logic exponent_start,
                
        output logic [DATA_WIDTH-1:0] div_divisor,
        output logic [DATA_WIDTH-1:0] div_dividend,
        output logic div_start,
        
        
		output logic exp_eval_data_ready);

////////////////////////////////////////////
localparam STATE_DEFAULT = 4'd0;
localparam STATE_ANGLE_COMB_START = 4'd1;
localparam STATE_ANGLE_COMB_WAIT = 4'd2;
localparam STATE_NORM_ANGLE_START = 4'd3;
localparam STATE_NORM_ANGLE_WAIT = 4'd4;
localparam STATE_TERM_ACC_START = 4'd5;
localparam STATE_TERM_ACC_WAIT = 4'd6;
localparam STATE_FETCH_INIT_VAL = 4'd7;
localparam STATE_DATA_OUT = 4'd8;

/////////////////////////////////////////
logic [DATA_WIDTH-1:0] init_val [NUM_INIT_VAL-1:0];
logic [3:0] state_exp_eval;
integer counter;
/////////////////////////////////////
logic angle_combination_start;
logic angle_combination_done;
logic [$clog2(NUM_ANGLE_COMB)-1:0] mem_angle_combination_detail_addr;
logic [$clog2(NUM_ANGLE_COMB)-1:0] angle_combination_mem_angle_combination_value_write_addr;
logic angle_combination_mem_angle_combination_value_write_en;
logic [DATA_WIDTH-1:0] angle_combination_mem_angle_combination_value_data_in;

logic [$clog2(NUM_ANGLE_COMB)-1:0] angle_normalization_mem_angle_combination_value_read_addr;
logic [$clog2(NUM_ANGLE_COMB)-1:0] angle_normalization_mem_angle_combination_value_write_addr;
logic [DATA_WIDTH-1:0] angle_normalization_mem_angle_combination_value_data_in;
logic angle_normalization_mem_angle_combination_value_write_en;

logic term_accumulator_start;
logic [$clog2(NUM_EVAL_VAL+NUM_INIT_VAL)-1:0] term_accumulator_mem_state_var_addr;
logic [DATA_WIDTH-1:0] term_accumulator_output_value;


////////////////////////////////////
logic [DATA_WIDTH-1:0] angle_combination_add_a[1:0];
logic [DATA_WIDTH-1:0] angle_combination_add_b[1:0];
logic angle_combination_add_start[1:0];

logic [DATA_WIDTH-1:0] angle_normalization_add_a;
logic [DATA_WIDTH-1:0] angle_normalization_add_b;
logic angle_normalization_add_start;

logic [DATA_WIDTH-1:0] term_accumulator_operand_a;
logic [DATA_WIDTH-1:0] term_accumulator_operand_b;
logic term_accumulator_add_start;
logic term_accumulator_mult_start;
logic term_accumulator_div_start;
logic term_accumulator_exponent_start;
logic term_accumulator_output_ready;

////////////////////////////////////////
logic mem_angle_combination_value_write;
logic [$clog2(NUM_ANGLE_COMB)-1:0] mem_angle_combination_value_write_addr;
logic [$clog2(NUM_ANGLE_COMB)-1:0] mem_angle_combination_value_read_addr;
logic [DATA_WIDTH-1:0] mem_angle_combination_value_in;
logic [DATA_WIDTH-1:0] mem_angle_combination_value_data_out;
logic [15:0] mem_angle_combination_detail_datao;

logic [DATA_WIDTH-1:0] mem_angle_normalized_data_out;
logic [$clog2(NUM_ANGLE_COMB)-1:0] term_accumulator_mem_angle_normalized_addr;  
logic angle_normalization_start;
logic angle_normalization_done;


angle_combination #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN),
	.NUM_ANGLE_COMB(NUM_ANGLE_COMB)
) inst_angle_combination (
	.clock                              (clock),
	.reset                              (reset),
	.angle_combination_start            (angle_combination_start),
	.input_initial_value                (init_val),
	.angle_combination_add_sum          (add_result),
	.angle_combination_add_ready        (add_result_ready),
	.mem_angle_combination_detail_datao (mem_angle_combination_detail_datao),
	.angle_combination_done             (angle_combination_done),
	.angle_combination_add_start        (angle_combination_add_start),
	.angle_combination_add_a            (angle_combination_add_a),
	.angle_combination_add_b            (angle_combination_add_b),
	.mem_angle_combination_detail_addr  (mem_angle_combination_detail_addr),
	.mem_angle_combination_value_addr   (angle_combination_mem_angle_combination_value_write_addr),
	.mem_angle_combination_value_write  (angle_combination_mem_angle_combination_value_write_en),
	.mem_angle_combination_value_in     (angle_combination_mem_angle_combination_value_data_in)
);


angle_normalization_wrapper #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN),
	.NUM_ANGLE(NUM_ANGLE_COMB)
) inst_angle_normalization_wrapper (
	.clock                                  (clock),
	.start_angle_normalization              (angle_normalization_start),
	.mem_angle_combination_value_data_out   (mem_angle_combination_value_data_out),
	.angle_normalization_add_sum            (add_result[0]),
	.angle_normalization_add_ready          (add_result_ready[0]),
	.mem_angle_combination_value_read_addr  (angle_normalization_mem_angle_combination_value_read_addr),
	.mem_angle_combination_value_write_addr (angle_normalization_mem_angle_combination_value_write_addr),
	.mem_angle_combination_value_data_in    (angle_normalization_mem_angle_combination_value_data_in),
	.mem_angle_combination_value_write_en   (angle_normalization_mem_angle_combination_value_write_en),
	.angle_normalization_add_a              (angle_normalization_add_a),
	.angle_normalization_add_b              (angle_normalization_add_b),
	.angle_normalization_add_start          (angle_normalization_add_start),
	.angle_normalization_done				(angle_normalization_done)
);


term_accumulator #(
	.DATA_WIDTH(DATA_WIDTH),
	.CODE_WIDTH(CODE_WIDTH),
	.NUM_KEY_VAL(NUM_KEY_VAL),
	.NUM_STATE_VAR(NUM_INIT_VAL+NUM_EVAL_VAL),
	.ANGLE_ADDR_WIDTH($clog2(NUM_ANGLE_COMB))
) inst_term_accumulator (
	.clock                         (clock),
	.reset                         (reset),
	.term_accumulator_start        (term_accumulator_start),
	.mult_result                   (mult_result),
	.add_result                    (add_result[0]),
	.divide_result                 (div_result),
	.exponent_result               (exponent_result),
	.mult_data_ready               (mult_result_ready),
	.add_data_ready                (add_result_ready[0]),
	.divide_data_ready             (div_result_ready),
	.exponent_data_ready           (exponent_result_ready),
	.mem_angle_normalized_data_out (mem_angle_combination_value_data_out),
	.mem_key_val_data_out          (mem_key_val_data_out),
	.mem_state_var_data_out        (mem_state_var_read_data_out),
	.mult_start                    (term_accumulator_mult_start),
	.add_start                     (term_accumulator_add_start),
	.exponent_start                (term_accumulator_exponent_start),
	.divide_start                  (term_accumulator_div_start),
	.operand_a                     (term_accumulator_operand_a),
	.operand_b                     (term_accumulator_operand_b),
	.mem_angle_normalized_addr     (term_accumulator_mem_angle_normalized_addr),
	.mem_key_val_addr              (mem_key_val_addr),
	.mem_state_var_addr            (term_accumulator_mem_state_var_addr),
	.output_value                  (term_accumulator_output_value),
	.output_ready                  (term_accumulator_output_ready)
);


simple_dual_one_clock #(
	.MEM_WIDTH(DATA_WIDTH),
	.MEM_DEPTH(21)
) mem_angle_combination_value (
	.clock      (clock_mem),
	.en_a       (1),
	.en_b       (1),
	.write_en_a (mem_angle_combination_value_write),
	.addr_a     (mem_angle_combination_value_write_addr),
	.addr_b     (mem_angle_combination_value_read_addr),
	.data_in_a  (mem_angle_combination_value_in),
	.data_out_b (mem_angle_combination_value_data_out)
);



rams_sp_rom_angle_comb_detail #(
	.MEM_WIDTH(16),
	.MEM_DEPTH(21)
) inst_rams_sp_rom_angle_comb_detail (
	.clock   (clock_mem),
	.enable  (1),
	.address (mem_angle_combination_detail_addr),
	.dout    (mem_angle_combination_detail_datao)
);


always @(posedge clock) begin

	case (state_exp_eval)

		STATE_DEFAULT : begin
			if (start_exp_evaluator) begin
				state_exp_eval <= STATE_FETCH_INIT_VAL;
				end
			else begin
				state_exp_eval <= STATE_DEFAULT;
				end
			exp_eval_data_ready <= 1'b0;
			mem_state_var_read_addr <= 3'd0;
			end

		STATE_FETCH_INIT_VAL : begin
			case (counter)
				NUM_INIT_VAL : begin
					counter <= 1;
					mem_state_var_read_addr <= 0;
					state_exp_eval <= STATE_ANGLE_COMB_START;
					end
				default : begin
					counter <= counter + 1;
					mem_state_var_read_addr <= counter;
					state_exp_eval <= STATE_FETCH_INIT_VAL;
					end
				endcase
			init_val[mem_state_var_read_addr] <= mem_state_var_read_data_out;
			end

		STATE_ANGLE_COMB_START : begin
			angle_combination_start <= 1'b1;
			state_exp_eval <= STATE_ANGLE_COMB_WAIT;
			end

		STATE_ANGLE_COMB_WAIT : begin
			if (angle_combination_done == 1'b1) begin
				state_exp_eval <= STATE_NORM_ANGLE_START;
				end
			else begin
				state_exp_eval <= STATE_ANGLE_COMB_WAIT;
				end
			angle_combination_start <= 1'b0;
			end

		STATE_NORM_ANGLE_START : begin
			angle_normalization_start <= 1'b1;
			state_exp_eval <= STATE_NORM_ANGLE_WAIT;
			end

		STATE_NORM_ANGLE_WAIT : begin
			if (angle_normalization_done == 1'b1) begin
				state_exp_eval <= STATE_TERM_ACC_START;
				end
			else begin
				state_exp_eval <= STATE_NORM_ANGLE_WAIT;
				end
			angle_normalization_start <= 1'b0;
			end

		STATE_TERM_ACC_START : begin
			term_accumulator_start <= 1'b1;
			state_exp_eval <= STATE_TERM_ACC_WAIT;
			end

		STATE_TERM_ACC_WAIT : begin
			if (term_accumulator_output_ready == 1'b1) begin
				state_exp_eval <= STATE_DATA_OUT;
				end
			else begin
				state_exp_eval <= STATE_TERM_ACC_WAIT;
				end
			term_accumulator_start <= 1'b0;
			end

		STATE_DATA_OUT : begin
			exp_eval_data_ready <= 1'b1;
			state_exp_eval <= STATE_DEFAULT;
			end

		default : begin
			state_exp_eval <= STATE_DEFAULT;
			exp_eval_data_ready <= 1'b1;
			angle_combination_start <= 1'b0;
			angle_normalization_start <= 1'b0;
			term_accumulator_start <= 1'b0;
			counter <= 1;
			//term_division_start <= 1'b0;
			//init_val <= 0;	//write a loop here
			end
		endcase
	end



always @(*) begin

	case (state_exp_eval)
		
		STATE_ANGLE_COMB_WAIT : begin
			mult_operand_a <= 0;
			mult_operand_b <= 0;
			mult_start <= 0;

			add_operand_a[0] <= angle_combination_add_a[0];
			add_operand_b[0] <= angle_combination_add_b[0];
			add_start[0]     <= angle_combination_add_start[0];
			
			add_operand_a[1] <= angle_combination_add_a[1];
			add_operand_b[1] <= angle_combination_add_b[1];
			add_start[1]     <= angle_combination_add_start[1];

			exponent_operand_a <= 0;
			exponent_operand_b <= 0;
			exponent_start <= 0;

			div_start <= 0;
			
			/////memory part//////
            mem_angle_combination_value_write <= angle_combination_mem_angle_combination_value_write_en;
            mem_angle_combination_value_write_addr <= angle_combination_mem_angle_combination_value_write_addr;
            mem_angle_combination_value_read_addr <= 0;
            mem_angle_combination_value_in <= angle_combination_mem_angle_combination_value_data_in; 

			end

		STATE_NORM_ANGLE_WAIT : begin
			add_operand_a[0] <= angle_normalization_add_a;
			add_operand_b[0] <= angle_normalization_add_b;
			add_start[0]     <= angle_normalization_add_start;

			add_operand_a[1] <= 0;
			add_operand_b[1] <= 0;
			add_start[1]     <= 0;

			mult_operand_a <= 0;
			mult_operand_b <= 0;
			mult_start <= 0;
			
			exponent_operand_a <= 0;
            exponent_operand_b <= 0;
            exponent_start <= 0;

			div_start <= 0;
			
			/////memory part//////
            mem_angle_combination_value_write <= angle_normalization_mem_angle_combination_value_write_en;
            mem_angle_combination_value_write_addr <= angle_normalization_mem_angle_combination_value_write_addr;
            mem_angle_combination_value_read_addr <= angle_normalization_mem_angle_combination_value_read_addr;
            mem_angle_combination_value_in <= angle_normalization_mem_angle_combination_value_data_in; 
 
			end

		STATE_TERM_ACC_WAIT: begin
			add_operand_a[0] <= term_accumulator_operand_a;
			add_operand_b[0] <= term_accumulator_operand_b;
			add_start[0]     <= term_accumulator_add_start;

			add_operand_a[1] <= 0;
			add_operand_b[1] <= 0;
			add_start[1]     <= 0;

			mult_operand_a <= term_accumulator_operand_a;
			mult_operand_b <= term_accumulator_operand_b;
			mult_start <= term_accumulator_mult_start;

			exponent_operand_a <= term_accumulator_operand_a;
			exponent_operand_b <= term_accumulator_operand_b;
			exponent_start <= term_accumulator_exponent_start;
			
			div_start <= term_accumulator_div_start;
			
			
			/////memory part//////??????????? CHECK
            mem_angle_combination_value_write <= 0;
            mem_angle_combination_value_write_addr <= 0;
            mem_angle_combination_value_read_addr <= term_accumulator_mem_angle_normalized_addr;
            mem_angle_combination_value_in <= 0; 

			end
		default: begin
			add_operand_a[0] <= 0;
			add_operand_b[0] <= 0;
			add_operand_a[1] <= 0;
            add_operand_b[1] <= 0;
			add_start[0]     <= 0;
            add_start[1]     <= 0;

			mult_operand_a <= 0;
			mult_operand_b <= 0;
			mult_start <= 0;

			exponent_operand_a <= 0;
			exponent_operand_b <= 0;

			exponent_start <= 0;
			div_start <= 0;
			
			mem_state_var_write_we <= 0;
			/////memory part//////
			mem_angle_combination_value_write <= 0;
            mem_angle_combination_value_write_addr <= 0;
            mem_angle_combination_value_read_addr <= 0;
            mem_angle_combination_value_in <= 0; 
			
			end
		endcase
    end



endmodule