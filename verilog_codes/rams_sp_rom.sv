
module rams_sp_rom_1 #(
	parameter MEM_WIDTH = 32,
	parameter MEM_DEPTH = 1024)
	(
	input logic clock,
	input logic enable, 
	input logic [$clog2(MEM_DEPTH)-1:0] address,

	output logic [MEM_WIDTH-1:0] dout);

(*rom_style = "block"*) logic [MEM_WIDTH-1:0] data;

assign dout = data;

always @(posedge clock) begin
	if (enable)
		case(address)
			6'b000000: data <= 20'h0200A;
			6'b000001: data <= 20'h00300;
	 		6'b000010: data <= 20'h08101;
			endcase
	end

endmodule  
