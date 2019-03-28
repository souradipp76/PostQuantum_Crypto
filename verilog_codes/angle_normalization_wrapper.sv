module angle_normalization_wrapper #(
	parameter EXP_LEN = 8,
	parameter MANTISSA_LEN = 23,
	parameter NUM_ANGLE = 22)

	(
	input logic clock,
	input logic start_angle_normalization,

	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] mem_angle_combination_value_data_out,
	
	input logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_normalization_add_sum,
	input logic angle_normalization_add_ready,

	output logic [$clog2(NUM_ANGLE)-1:0] mem_angle_combination_value_read_addr,
	output logic [$clog2(NUM_ANGLE)-1:0] mem_angle_combination_value_write_addr,
	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] mem_angle_combination_value_data_in,
	output logic mem_angle_combination_value_write_en,
	
	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_normalization_add_a,
	output logic [EXP_LEN+MANTISSA_LEN+1-1:0] angle_normalization_add_b,
	output logic angle_normalization_add_start) ;


//////////////////////////////////////////
localparam STATE_DEFAULT = 4'd0;
localparam STATE_NORMALIZATION_WAIT = 4'd1;
localparam STATE_END_SEQUENCE = 4'd2;

//////////////////////////////////////////
logic [3:0] state_angle_normalization;

logic angle_normalization_input_ready;
logic angle_normalization_out_ready;

assign mem_angle_combination_value_write_addr = mem_angle_combination_value_read_addr - 1;

angle_normalization #(
	.EXP_LEN(EXP_LEN),
	.MANTISSA_LEN(MANTISSA_LEN)
) inst_angle_normalization (
	.clk                             (clock),
	.reset                           (0),
	.input_data_ready                (angle_normalization_input_ready),
	.input_angle                     (mem_angle_combination_value_data_out),
	.angle_normalization_add_sum     (angle_normalization_add_sum),
	.angle_normalization_add_ready   (angle_normalization_add_ready),
	.output_angle_normalization_done (angle_normalization_out_ready),
	.output_normalized_angle         (mem_angle_combination_value_data_in),
	.angle_normalization_add_a       (angle_normalization_add_a),
	.angle_normalization_add_b       (angle_normalization_add_b),
	.angle_normalization_add_start   (angle_normalization_add_start)
);



always @(posedge clock) begin

	case (state_angle_normalization)

		STATE_DEFAULT : begin
			
			case (start_angle_normalization)
				1'b1 : begin
					state_angle_normalization <= STATE_NORMALIZATION_WAIT;
					angle_normalization_input_ready <= 1'b1;
					mem_angle_combination_value_read_addr <= mem_angle_combination_value_read_addr + 1;
					end

				1'b0 : begin
					state_angle_normalization <= STATE_DEFAULT;
					angle_normalization_input_ready <= 1'b0;
					mem_angle_combination_value_read_addr <= 0;
					end
				endcase
			end

		STATE_NORMALIZATION_WAIT : begin
			angle_normalization_input_ready <= 1'b0;

			if (angle_normalization_out_ready)
				state_angle_normalization <= STATE_END_SEQUENCE;
				mem_angle_combination_value_write_en <= 1'b1;
			else
				state_angle_normalization <= STATE_NORMALIZATION_WAIT;
				mem_angle_combination_value_write_en <= 1'b0;
			end

		STATE_END_SEQUENCE : begin
			mem_angle_combination_value_read_addr <= mem_angle_combination_value_read_addr + 1;

			if (mem_angle_combination_value_read_addr == (NUM_ANGLE-1))
				state_angle_normalization <= STATE_DEFAULT;
				angle_normalization_input_ready <= 1'b0;
			else
				state_angle_normalization <= STATE_NORMALIZATION_WAIT;
				angle_normalization_input_ready <= 1'b1;
			end 

		default : begin
			state_angle_normalization <= STATE_DEFAULT;
			end
		endcase
	end

endmodule
