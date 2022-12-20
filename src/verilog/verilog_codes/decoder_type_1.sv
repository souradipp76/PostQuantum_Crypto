
module decoder_type_1 #(
	
	parameter DATA_WIDTH = 32,
	parameter CODE_WIDTH = 8)
	
	(
	input logic clock,
	input logic decode_start,
	input logic [CODE_WIDTH-1:0] inp_code,

	output logic data_ready,
	output logic [DATA_WIDTH-1:0] out_value);

localparam STATE_DEFAULT = 4'd0;
localparam STATE_DECODE = 4'd1;

logic [3:0] state_decoder;
logic [CODE_WIDTH-1:0] code;


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

		case (code[CODE_WIDTH-1-2:0])
			6'd0 : out_value <= 32'b0;
			6'd1 : out_value <= 32'b00111111100000000000000000000000;
			6'd2 : out_value <= 32'b01000000000000000000000000000000;
			6'd3 : out_value <= 32'b01000000010000000000000000000000;
			6'd4 : out_value <= 32'b01000000100000000000000000000000;
			6'd5 : out_value <= 32'b01000000110000000000000000000000;
			6'd6 : out_value <= 32'b01000001000000000000000000000000;
			6'd7 : out_value <= 32'b01000001010000000000000000000000;
			6'd8 : out_value <= 32'b01000001100000000000000000000000;
			6'd9 : out_value <= 32'b01000001110000000000000000000000;
			6'd10 : out_value <= 32'b01000010000000000000000000000000;
			6'd11 : out_value <= 32'b01000010010000000000000000000000;
			6'd12 : out_value <= 32'b01000010100000000000000000000000;
			default : out_value <= 32'b0;
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
