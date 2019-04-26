
module float_point_divider_ip (

	input logic clock,
	input logic [31:0] dividend,
	input logic [31:0] divisor,
	input logic div_start,

	output logic [31:0] div_result,
	output logic result_ready);





floating_point_0 your_instance_name (
  .aclk(clock),                                  // input wire aclk
  .s_axis_a_tvalid(div_start),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(dividend),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(div_start),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(divisor),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(result_ready),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(div_result)    // output wire [31 : 0] m_axis_result_tdata
);

endmodule