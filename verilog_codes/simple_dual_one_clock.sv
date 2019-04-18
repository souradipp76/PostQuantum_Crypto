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

module simple_dual_one_clock #(
	parameter MEM_WIDTH = 32  ,
	parameter MEM_DEPTH = 1024
) (
	input  logic clock,
	input  logic en_a,
	input  logic en_b,
	input  logic write_en_a,
	input  logic [$clog2(MEM_DEPTH)-1:0] addr_a,
	input  logic [$clog2(MEM_DEPTH)-1:0] addr_b,
	input  logic [MEM_WIDTH-1:0] data_in_a,

	output logic [MEM_WIDTH-1:0] data_out_b
);

reg [MEM_WIDTH-1:0] ram[MEM_DEPTH-1:0];

initial begin
	ram[0] <= 32'h3f16bb98;
	ram[1] <= 32'h3eb4bc6a;
	ram[2] <= 32'h3e41f212;
	ram[3] <= 32'h3f820c49;
	ram[4] <= 32'h3f020c49;
	ram[5] <= 32'h3e820c49;
	ram[6] <= 32'h3c9ba5e3;
	ram[7] <= 32'h3b51b717;
	ram[8] <= 32'h39d1b717;
	ram[9] <= 32'h3c23d70a;
	ram[10] <= 32'h00000000;
	ram[11] <= 32'h3ad1b717;
	ram[12] <= 32'h419cf5c2;
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