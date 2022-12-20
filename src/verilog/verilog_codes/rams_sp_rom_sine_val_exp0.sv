module rams_sp_rom_sine_val_exp0 #(
	parameter MEM_WIDTH = 32,
	parameter MEM_DEPTH = 64)
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
			6'b000000: data<= 32'h3f576aa4;
			6'b000001: data<= 32'h3f598d28;
			6'b000010: data<= 32'h3f5ba213;
			6'b000011: data<= 32'h3f5da944;
			6'b000100: data<= 32'h3f5fa29b;
			6'b000101: data<= 32'h3f618df7;
			6'b000110: data<= 32'h3f636b3b;
			6'b000111: data<= 32'h3f653a48;
			6'b001000: data<= 32'h3f66fb02;
			6'b001001: data<= 32'h3f68ad4c;
			6'b001010: data<= 32'h3f6a510b;
			6'b001011: data<= 32'h3f6be625;
			6'b001100: data<= 32'h3f6d6c81;
			6'b001101: data<= 32'h3f6ee406;
			6'b001110: data<= 32'h3f704c9d;
			6'b001111: data<= 32'h3f71a62f;
			6'b010000: data<= 32'h3f72f0a7;
			6'b010001: data<= 32'h3f742bf0;
			6'b010010: data<= 32'h3f7557f7;
			6'b010011: data<= 32'h3f7674a8;
			6'b010100: data<= 32'h3f7781f1;
			6'b010101: data<= 32'h3f787fc3;
			6'b010110: data<= 32'h3f796e0d;
			6'b010111: data<= 32'h3f7a4cc0;
			6'b011000: data<= 32'h3f7b1bce;
			6'b011001: data<= 32'h3f7bdb2b;
			6'b011010: data<= 32'h3f7c8aca;
			6'b011011: data<= 32'h3f7d2aa0;
			6'b011100: data<= 32'h3f7dbaa4;
			6'b011101: data<= 32'h3f7e3acc;
			6'b011110: data<= 32'h3f7eab11;
			6'b011111: data<= 32'h3f7f0b6b;
			6'b100000: data<= 32'h3f7f5bd4;
			6'b100001: data<= 32'h3f7f9c48;
			6'b100010: data<= 32'h3f7fccc2;
			6'b100011: data<= 32'h3f7fed40;
			6'b100100: data<= 32'h3f7ffdbe;
			6'b100101: data<= 32'h3f7ffe3d;
			6'b100110: data<= 32'h3f7feebc;
			6'b100111: data<= 32'h3f7fcf3c;
			6'b101000: data<= 32'h3f7f9fbf;
			6'b101001: data<= 32'h3f7f6049;
			6'b101010: data<= 32'h3f7f10dc;
			6'b101011: data<= 32'h3f7eb17f;
			6'b101100: data<= 32'h3f7e4236;
			6'b101101: data<= 32'h3f7dc30a;
			6'b101110: data<= 32'h3f7d3401;
			6'b101111: data<= 32'h3f7c9525;
			6'b110000: data<= 32'h3f7be680;
			6'b110001: data<= 32'h3f7b281d;
			6'b110010: data<= 32'h3f7a5a07;
			6'b110011: data<= 32'h3f797c4c;
			6'b110100: data<= 32'h3f788ef9;
			6'b110101: data<= 32'h3f77921d;
			6'b110110: data<= 32'h3f7685c8;
			6'b110111: data<= 32'h3f756a0b;
			6'b111000: data<= 32'h3f743ef7;
			6'b111001: data<= 32'h3f73049f;
			6'b111010: data<= 32'h3f71bb17;
			6'b111011: data<= 32'h3f706274;
			6'b111100: data<= 32'h3f6efaca;
			6'b111101: data<= 32'h3f6d8431;
			6'b111110: data<= 32'h3f6bfec0;
			6'b111111: data<= 32'h3f6a6a8f;

			endcase
			end
	end
endmodule	