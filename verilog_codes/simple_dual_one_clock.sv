/*
simple_dual_one_clock #(
	.MEM_WIDTH(<Widh of memory>),
	.MEM_DEPTH(<Depth of memeory>))	<memory_name>
	
	(
	.clock(clock),
	.en_a(enable),
	.en_b(enable),
	.write_en_a(write_en),
	.addr_a(address),
	.addr_b(address),
    .data_in_a(data_in),
	.data_out_b(data_out));
*/

module simple_dual_one_clock#(
	parameter MEM_WIDTH = 32,
	parameter MEM_DEPTH = 1024) 
	(
	input logic clock,
	input logic en_a,
	input logic en_b,
	input logic write_en_a,
	input logic [$clog2(MEM_DEPTH)-1:0] addr_a,
	input logic [$clog2(MEM_DEPTH)-1:0] addr_b,
	input logic [MEM_WIDTH-1:0] data_in_a,
	
	output logic [MEM_WIDTH-1:0] data_out_b);

	reg [MEM_WIDTH-1:0] ram [MEM_DEPTH-1:0];

integer i;	
initial begin
    for(i=0;i<MEM_DEPTH;i=i+1) begin
        ram[i]=$random;
        end
end	

always @(posedge clock) begin
	if (en_a) begin
		if (write_en_a)
		ram[addr_a] <= data_in_a;
	end
end

always @(posedge clock) begin
	if (en_b)
	data_out_b <= ram[addr_b];
end
endmodule