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
	parameter DATA_WIDTH = 32,
	parameter NUM_INIT_VAL = 6,
	parameter NUM_EVAL_VAL = 3)
	
	(
		input logic clock,
		input logic start_exp_evaluator,
		input logic reset,

		input logic [DATA_WIDTH-1:0] mem_state_var_data_out,

		output logic [$clog2(NUM_INIT_VAL+NUM_EVAL_VAL)-1:0] mem_state_var_addr,
		output logic [DATA_WIDTH-1:0] mem_state_var_data_in,
		output logic mem_state_var_we,
		
		output logic [DATA_WIDTH-1:0] exp_eval_mult_a,
        output logic [DATA_WIDTH-1:0] exp_eval_mult_b,
        output logic exp_eval_mult_start,
        
        output logic [DATA_WIDTH-1:0] exp_eval_add_a [1:0],
        output logic [DATA_WIDTH-1:0] exp_eval_add_b [1:0],
        output logic exp_eval_add_start [1:0],
        
        output logic [DATA_WIDTH-1:0] exp_eval_exponent_a,
        output logic [DATA_WIDTH-1:0] exp_eval_exponent_b,
        output logic exp_eval_exponent_start,
                
        output logic exp_eval_divide_start,
        
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
////////////////////////////////////////

/////////////////////////////////////////
logic [DATA_WIDTH-1:0] init_val [NUM_INIT_VAL-1:0];
logic [3:0] state_exp_eval;
integer counter;
/////////////////////////////////////////////

/////////////////////////////////////
logic angle_combination_start;
logic angle_combination_done;
logic normalize_angle_start;
logic normalize_angle_done;
logic term_accumulation_start;
logic term_accumulation_done;
////////////////////////////////////

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
logic term_accumulator_divide_start;
logic term_accumulator_exponent_start;

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
			mem_state_var_addr <= 3'd0;
			end

		STATE_FETCH_INIT_VAL : begin
			case (counter)
				NUM_INIT_VAL : begin
					counter <= 1;
					mem_state_var_addr <= 0;
					state_exp_eval <= STATE_ANGLE_COMB_START;
					end
				default : begin
					counter <= counter + 1;
					mem_state_var_addr <= counter;
					state_exp_eval <= STATE_FETCH_INIT_VAL;
					end
				endcase
			init_val[mem_state_var_addr] <= mem_state_var_data_out;
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
			normalize_angle_start <= 1'b1;
			state_exp_eval <= STATE_NORM_ANGLE_WAIT;
			end

		STATE_NORM_ANGLE_WAIT : begin
			if (normalize_angle_done == 1'b1) begin
				state_exp_eval <= STATE_TERM_ACC_START;
				end
			else begin
				state_exp_eval <= STATE_NORM_ANGLE_WAIT;
				end
			normalize_angle_start <= 1'b0;
			end

		STATE_TERM_ACC_START : begin
			term_accumulation_start <= 1'b1;
			state_exp_eval <= STATE_TERM_ACC_WAIT;
			end

		STATE_TERM_ACC_WAIT : begin
			if (term_accumulation_done == 1'b1) begin
				state_exp_eval <= STATE_DATA_OUT;
				end
			else begin
				state_exp_eval <= STATE_TERM_ACC_WAIT;
				end
			term_accumulation_start <= 1'b0;
			end

		STATE_DATA_OUT : begin
			exp_eval_data_ready <= 1'b1;
			state_exp_eval <= STATE_DEFAULT;
			end

		default : begin
			state_exp_eval <= STATE_DEFAULT;
			exp_eval_data_ready <= 1'b1;
			angle_combination_start <= 1'b0;
			normalize_angle_start <= 1'b0;
			term_accumulation_start <= 1'b0;
			//term_division_start <= 1'b0;
			//init_val <= 0;	//write a loop here
			end
		endcase
	end



always @(*) begin

	case (state_exp_eval)
		
		STATE_ANGLE_COMB_WAIT : begin
			exp_eval_mult_a <= 0;
			exp_eval_mult_b <= 0;
			exp_eval_mult_start <= 0;

			exp_eval_add_a[0] <= angle_combination_add_a[0];
			exp_eval_add_b[0] <= angle_combination_add_b[0];
			exp_eval_add_start[0] <= angle_combination_add_start[0];
			
			exp_eval_add_a[1] <= angle_combination_add_a[1];
			exp_eval_add_b[1] <= angle_combination_add_b[1];
			exp_eval_add_start[1] <= angle_combination_add_start[1];

			exp_eval_exponent_a <= 0;
			exp_eval_exponent_b <= 0;
			exp_eval_mult_start <= 0;

			exp_eval_divide_start <= 0;
			end // STATE_ANGLE_COMB_WAIT :

		STATE_NORM_ANGLE_WAIT : begin
			exp_eval_add_a[0] <= angle_normalization_add_a;
			exp_eval_add_b[0] <= angle_normalization_add_b;
			exp_eval_add_start[0] <= angle_normalization_add_start;

			exp_eval_add_a[1] <= 0;
			exp_eval_add_b[1] <= 0;
			exp_eval_add_start[1] <= 0;

			exp_eval_mult_a <= 0;
			exp_eval_mult_b <= 0;
			exp_eval_mult_start <= 0;

			exp_eval_divide_start <= 0;

			end

		STATE_TERM_ACC_WAIT: begin
			exp_eval_add_a[0] <= term_accumulator_operand_a;
			exp_eval_add_b[0] <= term_accumulator_operand_b;
			exp_eval_add_start[0] <= term_accumulator_add_start;

			exp_eval_add_a[1] <= 0;
			exp_eval_add_b[1] <= 0;
			exp_eval_add_start[1] <= 0;

			exp_eval_mult_a <= term_accumulator_operand_a;
			exp_eval_mult_b <= term_accumulator_operand_b;
			exp_eval_mult_start <= term_accumulator_mult_start;

			exp_eval_exponent_a <= term_accumulator_operand_a;
			exp_eval_exponent_b <= term_accumulator_operand_b;
			exp_eval_exponent_start <= term_accumulator_exponent_start;
			
			exp_eval_divide_start <= term_accumulator_divide_start;
			end
		default: begin
			exp_eval_add_a[0] <= 0;
			exp_eval_add_b[0] <= 0;
			exp_eval_add_a[1] <= 0;
            exp_eval_add_b[1] <= 0;
			exp_eval_add_start[0] <= 0;
            exp_eval_add_start[1] <= 0;

			exp_eval_mult_a <= 0;
			exp_eval_mult_b <= 0;
			exp_eval_mult_start <= 0;

			exp_eval_exponent_a <= 0;
			exp_eval_exponent_b <= 0;

			exp_eval_exponent_start <= 0;
			exp_eval_divide_start <= 0;
			end
		endcase
    end
    
simple_dual_one_clock #(
        .MEM_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(21)) mem_angle_combination_value
        
        (
        .clock(clock),
        .en_a(1),
        .en_b(1),
        .write_en_a(mem_angle_combination_value_write),
        .addr_a(mem_angle_combination_value_addr),
        .addr_b(address),
        .data_in_a(mem_angle_combination_value_in),
        .data_out_b(data_out));
endmodule