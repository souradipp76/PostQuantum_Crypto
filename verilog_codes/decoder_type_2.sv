
module decoder_type_2 #(
	
	parameter DATA_WIDTH = 32,
	parameter CODE_WIDTH = 8,
	parameter NUM_KEY_VAL = 12)
	
	(
	input logic clock,
	input logic decode_start,
	input logic [CODE_WIDTH-1:0] inp_code,
	input logic [DATA_WIDTH-1:0] mem_key_val_data_out,
	input logic [DATA_WIDTH-1:0] mem_state_var_data_out,

	output logic [$clog(NUM_KEY_VAL)-1:0] mem_key_val_addr,
	output logic [$clog(NUM_KEY_VAL)-1:0] mem_state_var_addr,
	output logic [DATA_WIDTH-1:0] out_value);

localparam STATE_DEFAULT = 4'd0;
localparam STATE_MEM_WAIT = 4'd1;
localparam STATE_DATA_OUT = 4'd2;

logic [3:0] state_decoder;
logic counter;


always @(posedge clock) begin

	case (state_decoder)

		STATE_DEFAULT : begin
			case (decode_start)
				1'b1 : state_decoder <= STATE_MEM_WAIT ;
				1'b0 : state_decoder <= STATE_DEFAULT;
				endcase
			mem_key_val_addr <= inp_code[];
			mem_state_var_addr <= inp_code[];
			data_ready <= 1'b0;
			end

		STATE_MEM_WAIT : begin
			case (counter)
				3'b0 : begin
					counter <= MEM_DELAY - 1;
					state_decoder <= STATE_DATA_OUT;
					end
				default : begin
					counter <= counter - 1;
					state_decoder <= STATE_MEM_WAIT;
					end
				endcase
			end

		STATE_DATA_OUT : begin
			case (code[CODE_WIDTH-1-2])
				1'b0 : out_value <= mem_key_val_data_out;
				1'b1 : out_value <= mem_state_var_data_out;
				endcase
			state_decoder <= STATE_DEFAULT;
			data_ready <= 1'b1;
			end

		default : begin
			state_decoder <= STATE_DEFAULT;
			counter <= MEM_DELAY-1;
			end
		endcase
	end

endmodule