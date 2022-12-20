module rams_sp_rom_sine_val_exp1 #(
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
			6'b000000: data<= 32'h3f68c7b7;
			6'b000001: data<= 32'h3f65567d;
			6'b000010: data<= 32'h3f61abef;
			6'b000011: data<= 32'h3f5dc8f7;
			6'b000100: data<= 32'h3f59ae8e;
			6'b000101: data<= 32'h3f555dbb;
			6'b000110: data<= 32'h3f50d791;
			6'b000111: data<= 32'h3f4c1d32;
			6'b001000: data<= 32'h3f472fce;
			6'b001001: data<= 32'h3f42109e;
			6'b001010: data<= 32'h3f3cc0eb;
			6'b001011: data<= 32'h3f374209;
			6'b001100: data<= 32'h3f319557;
			6'b001101: data<= 32'h3f2bbc41;
			6'b001110: data<= 32'h3f25b83d;
			6'b001111: data<= 32'h3f1f8acb;
			6'b010000: data<= 32'h3f193578;
			6'b010001: data<= 32'h3f12b9d8;
			6'b010010: data<= 32'h3f0c198a;
			6'b010011: data<= 32'h3f055637;
			6'b010100: data<= 32'h3efce31f;
			6'b010101: data<= 32'h3eeeda97;
			6'b010110: data<= 32'h3ee0965a;
			6'b010111: data<= 32'h3ed219f8;
			6'b011000: data<= 32'h3ec36911;
			6'b011001: data<= 32'h3eb48751;
			6'b011010: data<= 32'h3ea57870;
			6'b011011: data<= 32'h3e964032;
			6'b011100: data<= 32'h3e86e264;
			6'b011101: data<= 32'h3e6ec5be;
			6'b011110: data<= 32'h3e4f8b03;
			6'b011111: data<= 32'h3e301c66;
			6'b100000: data<= 32'h3e1081c3;
			6'b100001: data<= 32'h3de18601;
			6'b100010: data<= 32'h3da1d01b;
			6'b100011: data<= 32'h3d43e385;
			6'b100100: data<= 32'h3c87ebb8;
			6'b100101: data<= 32'hbc70232a;
			6'b100110: data<= 32'hbd3bf86f;
			6'b100111: data<= 32'hbd9ddc8b;
			6'b101000: data<= 32'hbddd9569;
			6'b101001: data<= 32'hbe0e8b71;
			6'b101010: data<= 32'hbe2e288b;
			6'b101011: data<= 32'hbe4d9a1d;
			6'b101100: data<= 32'hbe6cd849;
			6'b101101: data<= 32'hbe85eda0;
			6'b101110: data<= 32'hbe954da0;
			6'b101111: data<= 32'hbea4884f;
			6'b110000: data<= 32'hbeb399db;
			6'b110001: data<= 32'hbec27e83;
			6'b110010: data<= 32'hbed1328c;
			6'b110011: data<= 32'hbedfb249;
			6'b110100: data<= 32'hbeedfa1b;
			6'b110101: data<= 32'hbefc066f;
			6'b110110: data<= 32'hbf04e9e2;
			6'b110111: data<= 32'hbf0baf52;
			6'b111000: data<= 32'hbf1251d7;
			6'b111001: data<= 32'hbf18cfc9;
			6'b111010: data<= 32'hbf1f2787;
			6'b111011: data<= 32'hbf25577d;
			6'b111100: data<= 32'hbf2b5e1d;
			6'b111101: data<= 32'hbf3139e7;
			6'b111110: data<= 32'hbf36e963;
			6'b111111: data<= 32'hbf3c6b25;

			endcase
			end
	end
endmodule	