/*
rams_sp_rf_rst #(
	.MEM_WIDTH(<Widh of memory>),
	.MEM_DEPTH(<Depth of memeory>))	<memory_name>
	
	(
	.clock(clock),
	.enable(enable),
	.write_en(write_en),
	.reset(reset),
	.address(address),
	.data_in(data_in),
	.data_out(data_out));
*/


module rams_sp_rf_rst #(
	parameter MEM_WIDTH = 32,
	parameter MEM_DEPTH = 1024)
	
	(
	input logic clock,
	input logic enable,
	input logic write_en,
	input logic reset,
	input logic [$clog2(MEM_DEPTH)-1:0] address,
	input logic [MEM_WIDTH-1:0] data_in,

	output logic [MEM_WIDTH-1:0] data_out);

logic [MEM_WIDTH-1:0] ram [MEM_DEPTH-1:0];

initial begin
	// ram[0] <= 32'h3f16bb98;
	// ram[1] <= 32'h3eb4bc6a;
	// ram[2] <= 32'h3e41f212;
	// ram[3] <= 32'h3f820c49;
	// ram[4] <= 32'h3f020c49;
	// ram[5] <= 32'h3e820c49;
	// ram[6] <= 32'h3c9ba5e3;
	// ram[7] <= 32'h3b51b717;
	// ram[8] <= 32'h39d1b717;
	// ram[9] <= 32'h3c23d70a;
	// ram[10] <= 32'h00000000;
	// ram[11] <= 32'h3ad1b717;
	// ram[12] <= 32'h419cf5c2;

	ram[0] <= 32'h3e96bb98;
	ram[1] <= 32'h3e34bc6a;
	ram[2] <= 32'h3dc1f212;
	ram[3] <= 32'h3f020c49;
	ram[4] <= 32'h3e820c49;
	ram[5] <= 32'h3e020c49;
	ram[6] <= 32'h3c1ba5e3;
	ram[7] <= 32'h3ad1b717;
	ram[8] <= 32'h3951b717;
	ram[9] <= 32'h3ba3d70a;
	ram[10] <= 32'h00000000;
	ram[11] <= 32'h3a51b717;
	ram[12] <= 32'h411cf5c2;
end

always @(posedge clock) begin
	if (enable) begin
 	
	 	if (write_en) //write enable
	 		ram[address] <= data_in;
	 	
	 	if (reset) //optional reset
	 		data_out <= 0;
	 	else
	 		data_out <= ram[address];
	 	end
	end

endmodule