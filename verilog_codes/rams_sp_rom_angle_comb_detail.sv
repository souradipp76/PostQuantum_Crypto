
module rams_sp_rom_angle_comb_detail #(
	parameter MEM_WIDTH = 8,
	parameter MEM_DEPTH = 22)
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
			10'b0000000000: data <= 8'h00;
			10'b0000000001: data <= 8'h02;
			10'b0000000010: data <= 8'h45;