

module stack #(
	parameter DATA_WIDTH = 32,
	parameter DEPTH = 32)

	(
	input logic clock,
	input logic clock_mem,
	input logic reset,
	input logic [DATA_WIDTH-1:0] inp_data,
	input logic push,
	input logic pop,

	output logic [DATA_WIDTH-1:0] out_data,
	output logic stack_empty,
	output logic stack_full);

localparam POINTER_WIDTH = $clog2(DEPTH);

logic [POINTER_WIDTH-1:0] stack_pointer;

logic [DATA_WIDTH-1:0] mem_stack_data_in;
logic [POINTER_WIDTH-1:0] mem_stack_addr_write;
logic mem_stack_write_en;

logic [POINTER_WIDTH-1:0] mem_stack_addr_read;
logic [DATA_WIDTH-1:0] mem_stack_data_out;

assign mem_stack_addr_read = stack_pointer;
assign mem_stack_addr_write = stack_pointer + 1;

assign stack_empty = ~|stack_pointer;
assign stack_full = &stack_pointer;

logic [POINTER_WIDTH-1:0] mem_stack_addr;

always @(*) begin
    case(mem_stack_write_en)
        1'b0:mem_stack_addr <= mem_stack_addr_read;
        1'b1:mem_stack_addr <= mem_stack_addr_write;
        endcase
    end

always @(posedge clock) begin

	if (reset) begin
		stack_pointer <= 0;
		out_data <= 0;
		mem_stack_data_in <= inp_data;
		mem_stack_write_en <= 1'b0;
	end 

	else begin
		case({pop, push})

			2'b10 : begin
				stack_pointer <= stack_pointer - 1;
				out_data <= mem_stack_data_out;
				mem_stack_data_in <= inp_data;
				mem_stack_write_en <= 1'b0;
				end

			2'b01 : begin
				stack_pointer <= stack_pointer + 1;
				out_data <= mem_stack_data_out;
				mem_stack_data_in <= inp_data;
				mem_stack_write_en <= 1'b1;
				end

			default : begin
				stack_pointer <= stack_pointer;
				out_data <= mem_stack_data_out;
				mem_stack_data_in <= inp_data;
				mem_stack_write_en <= 1'b0;
				end
			endcase
		end
	end

rams_sp_rf_rst #(
    .MEM_WIDTH(DATA_WIDTH),
    .MEM_DEPTH(DEPTH))    stack_mem
    
    (
    .clock(clock_mem),
    .enable(1),
    .write_en(mem_stack_write_en),
    .reset(reset),
    .address(mem_stack_addr),
    .data_in(mem_stack_data_in),
    .data_out(mem_stack_data_out));

endmodule
