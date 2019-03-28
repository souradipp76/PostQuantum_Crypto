module rams_sp_rom_sine_calculator #(
	parameter MEM_WIDTH = 16,
	parameter MEM_DEPTH = 21)
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
			endcase
		end
	end
endmodule		