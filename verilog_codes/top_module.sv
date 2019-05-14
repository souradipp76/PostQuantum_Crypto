
module top_module #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23)
	
	(
		input logic clock,
		input logic start_top,
		input logic reset);



localparam NUM_INIT_VAL = 6;
localparam NUM_EVAL_VAL = 3;
localparam NUM_STATE_VAR = NUM_EVAL_VAL + NUM_INIT_VAL;

localparam NUM_KEY_VAL = 13;

localparam DELTA_T = 32'h3a83126f;///delta_t = 0.001
localparam EXP_BIAS = (2**(EXP_LEN-1)) - 1;
localparam DATA_WIDTH = EXP_LEN + MANTISSA_LEN + 1;

///////////////////////////////////////////////////
logic clock_mem;
assign clock_mem = ~clock;

///////////////////////////////////////////////////
logic start_exp_evaluator;

logic [$clog2(NUM_KEY_VAL)-1:0] exp_evaluator_mem_key_val_addr;
logic [$clog2(NUM_STATE_VAR)-1:0] exp_evaluator_mem_state_var_read_addr;
logic [$clog2(NUM_STATE_VAR)-1:0] exp_evaluator_mem_state_var_write_addr;

logic [DATA_WIDTH-1:0] exp_evaluator_mem_state_var_write_data_in;
logic exp_evaluator_mem_state_var_write_we;

logic [DATA_WIDTH-1:0] exp_evaluator_mult_operand_a;
logic [DATA_WIDTH-1:0] exp_evaluator_mult_operand_b;
logic exp_evaluator_mult_start;

logic [DATA_WIDTH-1:0] exp_evaluator_add_operand_a [1:0];
logic [DATA_WIDTH-1:0] exp_evaluator_add_operand_b [1:0];
logic exp_evaluator_add_start [1:0];

logic [DATA_WIDTH-1:0] exp_evaluator_exponent_operand_a;
logic [DATA_WIDTH-1:0] exp_evaluator_exponent_operand_b;
logic exp_evaluator_exponent_start;

logic [DATA_WIDTH-1:0] exp_evaluator_div_operand_a;
logic [DATA_WIDTH-1:0] exp_evaluator_div_operand_b;
logic exp_evaluator_div_start;


///////////////////////////////////////////////////
logic [DATA_WIDTH-1:0] mem_key_val_data_out;
logic [DATA_WIDTH-1:0] mem_key_val_data_in;
logic [$clog2(NUM_KEY_VAL)-1:0] mem_key_val_read_addr;
logic [$clog2(NUM_KEY_VAL)-1:0] mem_key_val_write_addr;
logic mem_key_val_write_we;

assign mem_key_val_read_addr = exp_evaluator_mem_key_val_addr;
/////////////////////////////////////////////////////
logic [DATA_WIDTH-1:0] mem_state_var_data_out;
logic [DATA_WIDTH-1:0] mem_state_var_data_in;
logic [$clog2(NUM_STATE_VAR)-1:0] mem_state_var_read_addr;
logic [$clog2(NUM_STATE_VAR)-1:0] mem_state_var_write_addr;
logic mem_state_var_write_we;



/////////////////////////////////////////////////////
logic start_mult_add;

logic [DATA_WIDTH-1:0] mult_add_mult_operand_a;
logic [DATA_WIDTH-1:0] mult_add_mult_operand_b;
logic mult_add_mult_start;

logic [DATA_WIDTH-1:0] mult_add_add_operand_a;
logic [DATA_WIDTH-1:0] mult_add_add_operand_b;
logic mult_add_add_start;

logic [DATA_WIDTH-1:0] mult_add_result;
logic mult_add_result_ready;

logic [DATA_WIDTH-1:0] top_mult_add_operand [2:0];


//////////////////////////////////////////////////////
logic [DATA_WIDTH-1:0] mult_result;
logic mult_result_ready;

logic mult_start;
logic [DATA_WIDTH-1:0] mult_operand_a;
logic [DATA_WIDTH-1:0] mult_operand_b;


//////////////////////////////////////////////////////
logic [DATA_WIDTH-1:0] add_result [1:0];
logic add_result_ready [1:0];

logic add_start [1:0];
logic [DATA_WIDTH-1:0] add_operand_a [1:0];
logic [DATA_WIDTH-1:0] add_operand_b [1:0];


//////////////////////////////////////////////////////
logic exponent_start;
logic [DATA_WIDTH-1:0] exponent_operand_a;
logic [DATA_WIDTH-1:0] exponent_operand_b;
logic exponent_result_ready;
logic [DATA_WIDTH-1:0] exponent_result;

/////////////////////////////////////////////////////
logic div_start;
logic div_result_ready;
logic [DATA_WIDTH-1:0] div_divisor;
logic [DATA_WIDTH-1:0] div_dividend;
logic [DATA_WIDTH-1:0] div_result;

/////////////////////////////////////////////////////
logic [$clog2(NUM_STATE_VAR)-1:0] top_mem_state_var_write_addr;
logic [$clog2(NUM_STATE_VAR)-1:0] top_mem_state_var_read_addr;

//assign top_mem_state_var_write_addr = top_mem_state_var_read_addr - 1;

logic top_mem_state_var_write_we;
logic [DATA_WIDTH-1:0] top_mem_state_var_write_data_in;

///////////////////////////////////////////////////////
logic [3:0] state_top;
logic exp_evaluator_data_ready;

logic [DATA_WIDTH-1:0] epsilon_inv;
logic [DATA_WIDTH-1:0] map_min;

logic [DATA_WIDTH-1:0] mult_add_data;
logic [MANTISSA_LEN-1:0] interval_mantissa;
logic [EXP_LEN-1:0] interval_exponent;
logic [7:0] mem_encrypt_txt_addr;
logic [3*DATA_WIDTH+3-1:0] mem_encrypt_txt_data_in;
logic [3*DATA_WIDTH+3-1:0] mem_encrypt_txt_data_out;
logic [DATA_WIDTH-1:0] timestamp;

localparam STATE_DEFAULT = 4'd0;
localparam STATE_KEY_RX = 4'd1;
localparam STATE_EXP_EVAL_BEGIN = 4'd2;
localparam STATE_EXP_EVAL_WAIT = 4'd3;
localparam STATE_POST_PROCESS_1 = 4'd4;
localparam STATE_POST_PROCESS_2 = 4'd5;
localparam STATE_POST_PROCESS_3 = 4'd6;
localparam STATE_POST_PROCESS_3_WAIT = 4'd7;
localparam STATE_ENCRYPT = 4'd8;
localparam STATE_ENCRYPT_STORE = 4'd9;
localparam STATE_MULT_ADD_WAIT = 4'd10;

exp_evaluator #(
	.DATA_WIDTH(DATA_WIDTH),
	.NUM_INIT_VAL(NUM_INIT_VAL),
	.NUM_EVAL_VAL(NUM_EVAL_VAL),
	.NUM_KEY_VAL(NUM_KEY_VAL)
) inst_exp_evaluator (
	.clock                       (clock),
	.clock_mem					 (clock_mem),
	.start_exp_evaluator         (start_exp_evaluator),
	.reset                       (0),
	.mem_state_var_read_data_out (mem_state_var_data_out),
	.mem_key_val_data_out        (mem_key_val_data_out),
	.mult_result_ready           (mult_result_ready),
	.mult_result                 (mult_result),
	.add_result_ready            (add_result_ready),
	.add_result                  (add_result),
	.exponent_result_ready       (exponent_result_ready),
	.exponent_result             (exponent_result),
	.div_result_ready            (div_result_ready),
	.div_result                  (div_result),
	.mem_state_var_read_addr     (exp_evaluator_mem_state_var_read_addr),
	.mem_state_var_write_addr    (exp_evaluator_mem_state_var_write_addr),
	.mem_state_var_write_data_in (exp_evaluator_mem_state_var_write_data_in),
	.mem_state_var_write_we      (exp_evaluator_mem_state_var_write_we),
	.mem_key_val_addr            (exp_evaluator_mem_key_val_addr),
	.mult_operand_a              (exp_evaluator_mult_operand_a),
	.mult_operand_b              (exp_evaluator_mult_operand_b),
	.mult_start                  (exp_evaluator_mult_start),
	.add_operand_a               (exp_evaluator_add_operand_a),
	.add_operand_b               (exp_evaluator_add_operand_b),
	.add_start                   (exp_evaluator_add_start),
	.exponent_operand_a          (exp_evaluator_exponent_operand_a),
	.exponent_operand_b          (exp_evaluator_exponent_operand_b),
	.exponent_start              (exp_evaluator_exponent_start),
	.div_divisor                 (exp_evaluator_div_operand_b),
	.div_dividend                (exp_evaluator_div_operand_a),
	.div_start                   (exp_evaluator_div_start),
    .exp_eval_data_ready         (exp_evaluator_data_ready)
);


simple_dual_one_clock #(
	.MEM_WIDTH(DATA_WIDTH),
	.MEM_DEPTH(NUM_KEY_VAL)
) mem_key_values (
	.clock      (clock_mem),
	.en_a       (1),
	.en_b       (1),
	.write_en_a (mem_key_val_write_we),
	.addr_a     (mem_key_val_write_addr),
	.addr_b     (mem_key_val_read_addr),
	.data_in_a  (mem_key_val_data_in),
	.data_out_b (mem_key_val_data_out)
);


simple_dual_one_clock #(
	.MEM_WIDTH(DATA_WIDTH),
	.MEM_DEPTH(NUM_EVAL_VAL+NUM_INIT_VAL)
) mem_state_var (
	.clock      (clock_mem),
	.en_a       (1),
	.en_b       (1),
	.write_en_a (mem_state_var_write_we),
	.addr_a     (mem_state_var_write_addr),
	.addr_b     (mem_state_var_read_addr),
	.data_in_a  (mem_state_var_data_in),
	.data_out_b (mem_state_var_data_out)
);


mult_add #(
	.DATA_WIDTH(DATA_WIDTH)
) inst_mult_add (
	.clock             (clock),
	.start_mult_add    (start_mult_add),
	.inp_values        (top_mult_add_operand),
	.mult_result       (mult_result),
	.mult_result_ready (mult_result_ready),
	.add_result        (add_result[0]),
	.add_result_ready  (add_result_ready[0]),
	.mult_a            (mult_add_mult_operand_a),
	.mult_b            (mult_add_mult_operand_b),
	.mult_start        (mult_add_mult_start),
	.add_a             (mult_add_add_operand_a),
	.add_b             (mult_add_add_operand_b),
	.add_start         (mult_add_add_start),
	.out_value         (mult_add_result),
	.data_ready        (mult_add_result_ready)
);


float_point_multiplier_wrapper #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN)
) inst_float_point_multiplier_wrapper (
	.clock             (clock),
	.inp_a             (mult_operand_a),
	.inp_b             (mult_operand_b),
	.inp_data_ready    (mult_start),
	.out_product_ready (mult_result_ready),
	.out_product       (mult_result)
);


float_point_adder #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN)
) inst_float_point_adder_0 (
	.clk            (clock),
	.a              (add_operand_a[0]),
	.b              (add_operand_b[0]),
	.inp_data_ready (add_start[0]),
	.sum            (add_result[0]),
	.sum_ready      (add_result_ready[0])
);

float_point_adder #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN)
) inst_float_point_adder_1 (
	.clk            (clock),
	.a              (add_operand_a[1]),
	.b              (add_operand_b[1]),
	.inp_data_ready (add_start[1]),
	.sum            (add_result[1]),
	.sum_ready      (add_result_ready[1])
);


exponent_operation #(
	.DATA_WIDTH(DATA_WIDTH),
	.EXPONENT_WIDTH(EXP_LEN)
) inst_exponent_operation (
	.clock        (clock),
	.start        (exponent_start),
	.inp_value    (exponent_operand_a),
	.inp_exponent (exponent_operand_b),
	.output_ready (exponent_result_ready),
	.out_value    (exponent_result)
);


/*
float_point_divider inst_float_point_divider (
	.input_a      (div_dividend),
	.input_b      (div_divisor),
	.input_a_stb  (div_start),
	.input_b_stb  (div_start),
	.output_z_ack (1),
	.clk          (clock),
	.rst          (start_top),
	.output_z     (div_result),
	.output_z_stb (div_result_ready),
	.input_a_ack  (input_a_ack),
	.input_b_ack  (input_b_ack)
);
*/


float_point_divider_ip inst_float_point_divider_ip (
	.clock        (clock),
	.dividend     (div_dividend),
	.divisor      (div_divisor),
	.div_start    (div_start),
	.div_result   (div_result),
	.result_ready (div_result_ready)
);



logic [DATA_WIDTH-1:0] initial_conditions [5:0];
integer temp_counter = 0;

initial begin
	initial_conditions[0] = 32'h40ba5532;
	initial_conditions[1] = 32'h40a27fcb;
	initial_conditions[2] = 32'h409888ce;
	initial_conditions[3] = 0;
	initial_conditions[4] = 0;
	initial_conditions[5] = 0;
end


always @(posedge clock) begin

	case (state_top)

		STATE_DEFAULT : begin
			case (start_top)
				1'b1 : state_top <= STATE_KEY_RX;
				1'b0 : state_top <= STATE_DEFAULT;
				endcase
			top_mem_state_var_read_addr <= 0;
			top_mem_state_var_write_we <= 0;
			top_mem_state_var_write_addr <= 0;
			top_mem_state_var_write_data_in <= 0;
			end

		STATE_KEY_RX : begin
			case(temp_counter)
				32'd6 : begin
					state_top <= STATE_EXP_EVAL_BEGIN;
					temp_counter <= 0;
					top_mem_state_var_write_we <= 0;
					end
				default : begin
					state_top <= STATE_KEY_RX;
					temp_counter <= temp_counter + 1;
					top_mem_state_var_write_we <= 1;
					end
				endcase
			top_mem_state_var_write_addr <= temp_counter;
			top_mem_state_var_write_data_in <= initial_conditions[temp_counter];
			end

		STATE_EXP_EVAL_BEGIN : begin
			start_exp_evaluator <= 1'b1;
			state_top <= STATE_EXP_EVAL_WAIT;
            			          
			end

		STATE_EXP_EVAL_WAIT : begin
			start_exp_evaluator <= 1'b0;
			case (exp_evaluator_data_ready)
				1'b1 : state_top <= STATE_POST_PROCESS_1;
				1'b0 : state_top <= STATE_EXP_EVAL_WAIT;
				endcase
            	
			end

		STATE_POST_PROCESS_1 : begin

			case (top_mem_state_var_read_addr)
				4'd9 : begin
					state_top <= STATE_POST_PROCESS_3;
					top_mem_state_var_read_addr <= 0;
					end
				default : begin
					state_top <= STATE_POST_PROCESS_2;
					top_mem_state_var_read_addr <= top_mem_state_var_read_addr + 6;
					end
				endcase
			top_mult_add_operand[0] <= DELTA_T;
			top_mult_add_operand[2] <= mem_state_var_data_out;
			top_mem_state_var_write_we <= 1'b0;
			end

		STATE_POST_PROCESS_2 : begin
			start_mult_add <= 1'b1;
			top_mult_add_operand[1] <= mem_state_var_data_out;
			top_mem_state_var_read_addr <= top_mem_state_var_read_addr - 5;
			state_top <= STATE_MULT_ADD_WAIT;
			end

		STATE_POST_PROCESS_3 : begin
			top_mult_add_operand[0] <= mem_state_var_data_out;
			top_mult_add_operand[1] <= epsilon_inv;
			top_mult_add_operand[2] <= map_min;
			start_mult_add <= 1'b1;
			state_top <= STATE_POST_PROCESS_3_WAIT;
			end

		STATE_POST_PROCESS_3_WAIT : begin
			case (mult_add_result_ready)
				1'b1 : state_top <= STATE_ENCRYPT;
				1'b0 : state_top <= STATE_POST_PROCESS_3_WAIT;
				endcase
			interval_mantissa <= mult_add_data[MANTISSA_LEN-1:0];
			interval_exponent <= mult_add_data[EXP_LEN+MANTISSA_LEN-1:MANTISSA_LEN];
			end

		STATE_ENCRYPT : begin
			case (interval_exponent)
				EXP_BIAS+0 : mem_encrypt_txt_addr <= {{7{1'b0}}, interval_mantissa[MANTISSA_LEN-1]};
				EXP_BIAS+1 : mem_encrypt_txt_addr <= {{6{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-2]};
				EXP_BIAS+2 : mem_encrypt_txt_addr <= {{5{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-3]};
				EXP_BIAS+3 : mem_encrypt_txt_addr <= {{4{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-4]};
				EXP_BIAS+4 : mem_encrypt_txt_addr <= {{3{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-5]};
				EXP_BIAS+5 : mem_encrypt_txt_addr <= {{2{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-6]};
				EXP_BIAS+6 : mem_encrypt_txt_addr <= {{1{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-7]};
				EXP_BIAS+7 : mem_encrypt_txt_addr <= {{0{1'b0}}, interval_mantissa[MANTISSA_LEN-1:MANTISSA_LEN-8]};
				default : mem_encrypt_txt_addr <= 0;
				endcase
			state_top <= STATE_ENCRYPT_STORE;
			end

		STATE_ENCRYPT_STORE : begin
			case (mem_encrypt_txt_data_out[3*DATA_WIDTH + 2:3*DATA_WIDTH])
				3'b000 : mem_encrypt_txt_data_in <= {3'b100, timestamp, {DATA_WIDTH{1'b0}}, {DATA_WIDTH{1'b0}}};
				3'b100 : mem_encrypt_txt_data_in <= {3'b110, mem_encrypt_txt_data_out[(3*DATA_WIDTH)-1:2*DATA_WIDTH], timestamp,  {DATA_WIDTH{1'b0}}};
				3'b110 : mem_encrypt_txt_data_in <= {3'b111, mem_encrypt_txt_data_out[(3*DATA_WIDTH)-1:2*DATA_WIDTH], mem_encrypt_txt_data_out[(2*DATA_WIDTH)-1:1*DATA_WIDTH], timestamp};
				default : mem_encrypt_txt_data_in <= mem_encrypt_txt_data_out;
				endcase
			state_top <= STATE_DEFAULT;
			timestamp <= timestamp + DELTA_T;
			end

		STATE_MULT_ADD_WAIT : begin
			case (mult_add_result_ready)
				1'b1 : begin 
					state_top <= STATE_POST_PROCESS_1;
					top_mem_state_var_write_we <= 1'b1;
					end
				1'b0 : begin 
					state_top <= STATE_MULT_ADD_WAIT;
					top_mem_state_var_write_we <= 1'b0;
					end
				endcase
						start_mult_add <= 1'b0;
			top_mem_state_var_write_data_in <= mult_add_result;
			top_mem_state_var_write_addr <= top_mem_state_var_read_addr - 1;
			end

		default : begin 
			state_top <= STATE_DEFAULT;
			top_mem_state_var_write_we <= 0;
			top_mem_state_var_write_addr <= 0;
			top_mem_state_var_read_addr <= 0;
			top_mem_state_var_write_data_in <= 0;
			end
		endcase // start_top
	end
	
always @(*) begin

    case (state_top)

    	STATE_KEY_RX : begin
			mem_state_var_write_we = top_mem_state_var_write_we;
			mem_state_var_write_addr = top_mem_state_var_write_addr;
			mem_state_var_read_addr = 0;
			mem_state_var_data_in = top_mem_state_var_write_data_in;
        	end
        
		STATE_EXP_EVAL_WAIT : begin
			mem_state_var_write_we = exp_evaluator_mem_state_var_write_we;
			mem_state_var_write_addr = exp_evaluator_mem_state_var_write_addr;
			mem_state_var_read_addr = exp_evaluator_mem_state_var_read_addr;
			mem_state_var_data_in = exp_evaluator_mem_state_var_write_data_in;
            end

        STATE_MULT_ADD_WAIT : begin
			mem_state_var_write_we = top_mem_state_var_write_we;
			mem_state_var_write_addr = top_mem_state_var_write_addr;
			mem_state_var_read_addr = top_mem_state_var_read_addr;
			mem_state_var_data_in = top_mem_state_var_write_data_in;
			end

		STATE_POST_PROCESS_1 : begin
			mem_state_var_write_we = top_mem_state_var_write_we;
			mem_state_var_write_addr = top_mem_state_var_write_addr;
			mem_state_var_read_addr = top_mem_state_var_read_addr;
			mem_state_var_data_in = top_mem_state_var_write_data_in;
			end

        default: begin
			mem_state_var_write_we = 0;
			mem_state_var_write_addr = 0;
			mem_state_var_read_addr = top_mem_state_var_read_addr;
			mem_state_var_data_in = 0;
			end
		endcase
	end

always @(*) begin

	case(state_top)
	
		STATE_EXP_EVAL_WAIT : begin
			div_dividend = exp_evaluator_div_operand_b;
			div_divisor = exp_evaluator_div_operand_a;
			div_start = exp_evaluator_div_start;
			end
        
        STATE_MULT_ADD_WAIT : begin
			div_dividend = 0;
			div_divisor = 0;
			div_start = 0;
			end
        
		default : begin
			div_dividend = 0;
			div_divisor = 0;
			div_start = 0;
			end
		endcase
	end

always @(*) begin

	case(state_top)
    
		STATE_EXP_EVAL_WAIT : begin
			add_operand_a[0] = exp_evaluator_add_operand_a[0];
			add_operand_b[0] =  exp_evaluator_add_operand_b[0];
			add_operand_a[1] = exp_evaluator_add_operand_a[1];
			add_operand_b[1] =  exp_evaluator_add_operand_b[1];
			add_start[0] = exp_evaluator_add_start[0];
			add_start[1] = exp_evaluator_add_start[1];
			end
        
		STATE_MULT_ADD_WAIT : begin
			add_operand_a[0] = mult_add_add_operand_a;
			add_operand_b[0] = mult_add_add_operand_b;
			add_start[0] = mult_add_add_start;
			add_operand_a[1] = 0;
			add_operand_b[1] = 0;
			add_start[1] = 0;
			end
        
		default : begin
			add_operand_a[0] = 0;
			add_operand_b[0] = 0;
			add_operand_a[1] = 0;
			add_operand_b[1] = 0;
			add_start[0]     = 0;
			add_start[1]     = 0;
			end
		endcase
	end

always @(*) begin

	case(state_top)
    
		STATE_EXP_EVAL_WAIT : begin
			mult_operand_a = exp_evaluator_mult_operand_a;
			mult_operand_b = exp_evaluator_mult_operand_b;
			mult_start = exp_evaluator_mult_start;
			end
        
		STATE_MULT_ADD_WAIT : begin
			mult_operand_a = mult_add_mult_operand_a;
			mult_operand_b = mult_add_mult_operand_b;
			mult_start = mult_add_mult_start;
			end
        
		default : begin
			mult_operand_a = 0;
			mult_operand_b = 0;
			mult_start = 0;
			end
		endcase
	end


always @(*) begin

	case(state_top)
    
        STATE_EXP_EVAL_WAIT : begin
			exponent_operand_a = exp_evaluator_exponent_operand_a;
			exponent_operand_b = exp_evaluator_exponent_operand_b;
			exponent_start = exp_evaluator_exponent_start;
			end
        
		STATE_MULT_ADD_WAIT : begin
			exponent_operand_a = 0;
			exponent_operand_b = 0;
			exponent_start = 0;
			end
        
		default : begin
			exponent_operand_a = 0;
			exponent_operand_b = 0;
			exponent_start = 0;
			end
		endcase
	end

endmodule
