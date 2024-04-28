module PoleParallel (
    input clk,
    input rst,

    input signed [11:0] Yin,
    output signed [25:0] Yout  // 这里扩了两位数字  目前修改了这个地方，输出是有符号!!!
);

wire signed [11:0] coe[6:0];
wire signed [23:0] Mult_Reg[6:0];

// 第一�?512 就不用了
// fc = 3.125M
//assign coe[0]= -12'd923;
//assign coe[1]= 12'd1164;
//assign coe[2]= -12'd811;
//assign coe[3]= 12'd412;
//assign coe[4]= -12'd122;
//assign coe[5]= 12'd24;
//assign coe[6]= -12'd2;

// fc = 3.125M   -2725        6300       -8184        6443       -3071         820         -94
// assign coe[0]= -12'd2725;
// assign coe[1]= 12'd6300;
// assign coe[2]= -12'd8184;
// assign coe[3]= 12'd6443;
// assign coe[4]= -12'd3071;
// assign coe[5]= 12'd820;
// assign coe[6]= -12'd94;

// fc = 4.125M 272   609   250   189    49    13     1
assign coe[0]= 12'd272;
assign coe[1]= 12'd609;
assign coe[2]= 12'd250;
assign coe[3]= 12'd189;
assign coe[4]= 12'd49;
assign coe[5]= 12'd13;
assign coe[6]= 12'd1;


reg signed [11:0] Yin_Reg [6:0];
always @(posedge clk or posedge rst) begin:Y_pole
    integer m,n;
    if(rst) begin
        for (m = 0; m<7; m=m+1) begin
            Yin_Reg[m] <= 'd0;
        end
    end
    else begin
        for (n = 0; n<6; n=n+1) begin
            Yin_Reg[n+1] <= Yin_Reg[n];
        end
        Yin_Reg[0] <= Yin;
    end
end

genvar h;
generate
    for (h = 0; h<7; h=h+1) begin
        mult_gen_0 u0 (
        .A(Yin_Reg[h]),  // input wire [11 : 0] A
        .B(coe[h]),  // input wire [11 : 0] B
        .P(Mult_Reg[h])  // output wire [23 : 0] P
        );
    end
endgenerate

//assign Yout = Mult_Reg[0]+Mult_Reg[1]+Mult_Reg[2]+Mult_Reg[3]+Mult_Reg[4]+Mult_Reg[5]+Mult_Reg[6];

assign Yout = {{2{Mult_Reg[0][23]}},Mult_Reg[0]} 
            + {{2{Mult_Reg[1][23]}},Mult_Reg[1]}
            + {{2{Mult_Reg[2][23]}},Mult_Reg[2]}
            + {{2{Mult_Reg[3][23]}},Mult_Reg[3]}
            + {{2{Mult_Reg[4][23]}},Mult_Reg[4]}
            + {{2{Mult_Reg[5][23]}},Mult_Reg[5]}
            + {{2{Mult_Reg[6][23]}},Mult_Reg[6]};       
endmodule