
module decoder_type_3 #(
	
	parameter DATA_WIDTH = 32,
	parameter CODE_WIDTH = 8,
	parameter ANGLE_ADDR_WIDTH = 5)
	
	(
	input logic clock,
	input logic decode_start,
	input logic [CODE_WIDTH-1:0] inp_code,
	input logic [DATA_WIDTH-1:0] inp_sine_cosine_value,
    input logic [DATA_WIDTH-1:0] mem_angle_normalized_data_out,
    
	output logic [ANGLE_ADDR_WIDTH-1:0] mem_angle_normalized_addr,
	output logic [DATA_WIDTH-1:0] out_angle,
	output logic out_sine_cosine,
	output logic sin_calc_start,
	
	output logic data_ready,
	output logic [DATA_WIDTH-1:0] out_value);

//////////////////////////////////////
localparam STATE_DEFAULT = 4'd0;
localparam STATE_MEM_WAIT = 4'd1;
localparam STATE_DATA_OUT = 4'd2;
localparam STATE_SIN_VALUE_FETCH = 4'd3;
localparam STATE_SIN_CALC_WAIT = 4'd4;

localparam MEM_DELAY = 2;
localparam SIN_CALC_DELAY = 3;


/////////////////////////////////////
logic [3:0] state_decoder;
logic counter_memory;
logic counter_sin_calc;
logic [CODE_WIDTH-1:0] code;


////////////////////////////////////
always @(posedge clock) begin

	case (state_decoder)

		STATE_DEFAULT : begin
			case (decode_start)
				1'b1 : state_decoder <= STATE_MEM_WAIT ;
				1'b0 : state_decoder <= STATE_DEFAULT;
				endcase
			mem_angle_normalized_addr <= inp_code[CODE_WIDTH-1-3:0];
			code <= inp_code;
			data_ready <= 1'b0;
			out_value <= 0;
			end

		STATE_MEM_WAIT : begin
			case (counter_memory)
				3'b0 : begin
					counter_memory <= MEM_DELAY - 1;
					state_decoder <= STATE_DATA_OUT;
					end
				default : begin
					counter_memory <= counter_memory - 1;
					state_decoder <= STATE_MEM_WAIT;
					end
				endcase
			end

		STATE_SIN_VALUE_FETCH : begin
			out_angle <= mem_angle_normalized_data_out;
			out_sine_cosine <= code[CODE_WIDTH-1-2];
			sin_calc_start <= 1'b1;
			state_decoder <= STATE_SIN_CALC_WAIT;
			end

		STATE_SIN_CALC_WAIT : begin
			sin_calc_start <= 1'b0;
			case (counter_sin_calc)
				3'b0 : begin
					counter_sin_calc <= SIN_CALC_DELAY - 1;
					state_decoder <= STATE_DATA_OUT;
					end
				default : begin
					counter_sin_calc <= counter_sin_calc - 1;
					state_decoder <= STATE_SIN_CALC_WAIT;
					end
				endcase
            end
		STATE_DATA_OUT : begin
			out_value <= inp_sine_cosine_value;
			state_decoder <= STATE_DEFAULT;
			data_ready <= 1'b1;
			end

		default : begin
			state_decoder <= STATE_DEFAULT;
			counter_memory <= MEM_DELAY - 1;
			counter_sin_calc <= SIN_CALC_DELAY - 1;
			out_angle <= 0;
			out_value <= 0;
			end
		endcase
	end

endmodule