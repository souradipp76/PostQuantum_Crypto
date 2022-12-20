
module decoder_type_1 #(
	
	parameter DATA_WIDTH = 32,
	parameter CODE_WIDTH = 9)
	
	(
	input logic clock,
	input logic decode_start,
	input logic [CODE_WIDTH-1:0] inp_code,

	output logic data_ready,
	output logic [DATA_WIDTH-1:0] out_value);

always @(posedge clock) begin

case (state_decoder)

	STATE_DEFAULT : begin
		case (decode_start)
			1'b0 : state_decoder <= STATE_DEFAULT;
			1'b1 : state_decoder <= STATE_DECODE;
			endcase
		data_ready <= 1'b0;
		out_value <= 0;
		code <= inp_code;
		end

	STATE_DECODE : begin

		case (code)
			9'd0 : out_value <= ;
			9'd1 : out_value <= ;
			9'd2 : out_value <= ;
			9'd3 : out_value <= ;
			9'd4 : out_value <= ;
			endcase
		data_ready <= 1'b1;
		state_decoder <= STATE_DEFAULT;
		end

	default : begin
		state_decoder <= STATE_DEFAULT;
		end
	endcase
end


endmodule
