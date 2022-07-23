module hex8(
    Clk,
    Reset_n,
    Disp_data,
    Sel,
    Seg
);

    input Clk;
    input Reset_n;
    input [31:0]Disp_data;
    output reg [7:0]Sel;
    output reg [7:0]Seg;

    //时钟分频
    reg [18:0]div_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    //else if(div_cnt == 500_000 -1) //1ms
    else if(div_cnt == 500 -1) //10us
        div_cnt <= 0;
    else
        div_cnt <= div_cnt + 1'd1;

    //分频使能时钟
    reg Clk_1k;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Clk_1k <= 0;
    // else if(div_cnt == 500_000 -1)
    else if(div_cnt == 500 -1) //10us
        Clk_1k <= 1;
    else
        Clk_1k <= 0;
    
    //时钟计数
    reg [2:0]num_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        num_cnt <= 0;
    else if(Clk_1k)
        num_cnt <= num_cnt + 1'd1;

    //3-8译码器位选译码
    always@(posedge Clk)
    case(num_cnt)
        0:Sel <= 8'b0000_0001;
        1:Sel <= 8'b0000_0010;
        2:Sel <= 8'b0000_0100;
        3:Sel <= 8'b0000_1000;
        4:Sel <= 8'b0001_0000;
        5:Sel <= 8'b0010_0000;
        6:Sel <= 8'b0100_0000;
        7:Sel <= 8'b1000_0000;
    endcase
    
    //多路选择器-选择出段选码
    reg [3:0]disp_temp;
    always@(posedge Clk)
    case(num_cnt)
        7:disp_temp <= Disp_data[3:0];
        6:disp_temp <= Disp_data[7:4];
        5:disp_temp <= Disp_data[11:8];
        4:disp_temp <= Disp_data[15:12];
        3:disp_temp <= Disp_data[19:16];
        2:disp_temp <= Disp_data[23:20];
        1:disp_temp <= Disp_data[27:24];
        0:disp_temp <= Disp_data[31:28];
    endcase

    //LUT查找表 - 共阴极无小数点段选码
    always@(posedge Clk)
    case(disp_temp)
        0:Seg <= 8'h3f;
        1:Seg <= 8'h06;
        2:Seg <= 8'h5b;
        3:Seg <= 8'h4f;
        4:Seg <= 8'h66;
        5:Seg <= 8'h6d;
        6:Seg <= 8'h7d;
        7:Seg <= 8'h07;
        8:Seg <= 8'h7f;
        9:Seg <= 8'h6f;
        8'ha:Seg <= 8'h77;
        8'hb:Seg <= 8'h7c;
        8'hc:Seg <= 8'h39;
        8'hd:Seg <= 8'h5e;
        8'he:Seg <= 8'h79;
        8'hf:Seg <= 8'h71;
    endcase

endmodule