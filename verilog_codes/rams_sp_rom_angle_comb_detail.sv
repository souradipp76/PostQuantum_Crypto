
module rams_sp_rom_angle_comb_detail #(
	parameter MEM_WIDTH = 16,
	parameter MEM_DEPTH = 20)
	(
	input logic clock,
	input logic enable, 
	input logic [$clog2(MEM_DEPTH)-1:0] address,

	output logic [MEM_WIDTH-1:0] dout);

(*rom_style = "block"*) logic [MEM_WIDTH-1:0] data;

assign dout = data;

always @(posedge clock) begin
	if (enable) begin
		case(address)
			5'b00000: data <= 16'h1fdf;
			5'b00001: data <= 16'h1bff;
			5'b00010: data <= 16'h0aff;
			5'b00011: data <= 16'h02df;
			5'b00100: data <= 16'h0fcf;
			5'b00101: data <= 16'h0b4f;
			5'b00110: data <= 16'h0fff;
			5'b00111: data <= 16'h0fdf;
			5'b01000: data <= 16'hf3df;
			5'b01001: data <= 16'h0bff;
			5'b01010: data <= 16'hf2ff;
			5'b01011: data <= 16'hf2cf;
			5'b01100: data <= 16'h1acf;
			5'b01101: data <= 16'h1aff;
			5'b01110: data <= 16'hf2df;
			5'b01111: data <= 16'h12df;
			5'b10000: data <= 16'hff4f;
			5'b10001: data <= 16'h1fcf;
			5'b10010: data <= 16'hf3cf;
			5'b10011: data <= 16'h1b4f;
			endcase
			end
	end
endmodule	
