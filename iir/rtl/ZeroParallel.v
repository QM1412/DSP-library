module ZeroParallel (
    input clk,
    input rst,

    input  [11:0] Xin,
    output [20:0] Xout // 位宽 = 输入位宽+系数量化位宽
);
reg signed [11:0] Xin_d;
reg signed [11:0] Xin_Reg [6:0];


wire signed [11:0] coe[3:0];

// 第一�?512 就不用了
// fc = 3.125M
//assign coe[0]= 9'd7 ;
//assign coe[1]= 9'd21;
//assign coe[2]= 9'd42;
//assign coe[3]= 9'd56;

// fc = 1.125M
// assign coe[0]= 9'd1 ;
// assign coe[1]= -9'd2;
// assign coe[2]= 9'd3;
// assign coe[3]= -9'd1;

// fc = 4.125M  26   129   316   478   478   316   129    26
assign coe[0]= 9'd26 ;
assign coe[1]= 9'd129;
assign coe[2]= 9'd316;
assign coe[3]= 9'd478;

// 数据寄存器移�?
always @(posedge clk or posedge rst) begin:yiwei
    integer i,j;
    if(rst) begin
        Xin_d <= 'd0;
        for(i = 0;i<7;i=i+1 ) begin
            Xin_Reg[i] <= 'd0;
        end
    end
    else begin
        Xin_d <= Xin;               // 打了�?�?
        for(j = 0;j<6;j=j+1)begin
            Xin_Reg[j+1] <= Xin_Reg[j];
        end
        Xin_Reg[0] <= Xin_d;
    end
end

// 对于对称信号进行相加
wire signed [12:0]Add_Reg [3:0];
assign Add_Reg[0]  = {Xin_d[11],Xin_d}+{Xin_Reg[6][11],Xin_Reg[6]};
assign Add_Reg[1]  = {Xin_Reg[0][11],Xin_Reg[0]}+{Xin_Reg[5][11],Xin_Reg[5]};
assign Add_Reg[2]  = {Xin_Reg[1][11],Xin_Reg[1]}+{Xin_Reg[4][11],Xin_Reg[4]};
assign Add_Reg[3]  = {Xin_Reg[2][11],Xin_Reg[2]}+{Xin_Reg[3][11],Xin_Reg[3]};

// 后面用移位替代乘�?
wire signed [20:0] Mult_Reg[3:0];
assign Mult_Reg[0] = Add_Reg[0] * coe[0]; 
assign Mult_Reg[1] = Add_Reg[1] * coe[1];
assign Mult_Reg[2] = Add_Reg[2] * coe[2];
assign Mult_Reg[3] = Add_Reg[3] * coe[3];


assign Xout = Mult_Reg[0]+Mult_Reg[1]+Mult_Reg[2]+Mult_Reg[3];


endmodule