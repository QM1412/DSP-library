`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/09 23:09:59
// Design Name: 
// Module Name: iir_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module iir_filter(
    input clk,
    input rst,
    input signed [11:0] signal_i,
    output signed [11:0] signal_o 
    );

wire signed [11:0] Xin;  // 这里扩了两位数字
wire signed [20:0] Xout; 

assign Xin = signal_i;
ZeroParallel ZeroParallel_initial (
    .clk (clk),
    .rst (rst),
    .Xin (Xin),
    .Xout(Xout) // 位宽 = 输入位宽+系数量化位宽
);

wire signed [11:0] Yin;
wire signed [25:0] Yout;
PoleParallel PoleParallel_initial (
    .clk  (clk),
    .rst  (rst),
    .Yin  (Yin),
    .Yout (Yout) // 这里扩了两位数字
);

wire signed [25:0] Ysum;
wire signed [25:0] Ydiv;
assign Ysum = {{5{Xout[20]}},Xout}-Yout;
assign Ydiv = {{9{Ysum[25]}},Ysum[25:9]};

assign Yin = rst?12'd0:Ydiv[11:0];
assign signal_o = Yin;

endmodule


