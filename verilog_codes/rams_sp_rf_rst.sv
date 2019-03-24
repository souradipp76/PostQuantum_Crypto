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