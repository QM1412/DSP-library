module dds_gen(
    input clk,
    input rst,
    input key,

    output [13:0] dout
);

wire [31 : 0] sin_500K_t;
wire [31 : 0] sin_3M_t;

dds_compiler_0 dds_500K (
  .aclk(clk),           
  .aresetn(rst),                          // input wire aclk
  .s_axis_config_tvalid(1'b1),  // input wire s_axis_config_tvalid
  .s_axis_config_tdata(16'd655),    // input wire [15 : 0] s_axis_config_tdata 16'd655 16'd2621
  .m_axis_data_tvalid(),      // output wire m_axis_data_tvalid
  .m_axis_data_tdata(sin_500K_t)        // output wire [31 : 0] m_axis_data_tdata
);

dds_compiler_0 dds_3M (
  .aclk(clk),           
  .aresetn(rst),                          // input wire aclk
  .s_axis_config_tvalid(1'b1),  // input wire s_axis_config_tvalid
  .s_axis_config_tdata(16'd5242),    // input wire [15 : 0] s_axis_config_tdata 16'd3932 16'd15728
  .m_axis_data_tvalid(),      // output wire m_axis_data_tvalid
  .m_axis_data_tdata(sin_3M_t)        // output wire [31 : 0] m_axis_data_tdata
);

assign dout = (key)?sin_500K_t[29:16]:{sin_500K_t[29],sin_500K_t[29:17]}+{sin_3M_t[29],sin_3M_t[29:17]};

endmodule

