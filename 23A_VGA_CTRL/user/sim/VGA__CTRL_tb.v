`timescale 1ns / 1ns
module VGA_CTRL_tb;
    reg Clk;
    reg Reset_n;
    reg [23:0]DATA; //输入数据信号
    wire Data_Req; //信号输入请求信号，目的是提前VGA_BLK一拍
    wire VGA_HS;//行同步信号
    wire VGA_VS;//场同步信号
    wire VGA_BLK; //有效数据传送信号；BLK信号高电平时，为有效数据输出的时间段
    wire [23:0]VGA_RGB; //输出数据信号

    VGA_CTRL VGA_CTRL_inst0(
        Clk,
        Reset_n,
        DATA,
        Data_Req,
        VGA_HS,
        VGA_VS,
        VGA_BLK,
        VGA_RGB
    );

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        DATA <= 0;
    else if(Data_Req)
        DATA <= DATA + 1'd1;
    else
        DATA <= DATA;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
        Reset_n = 0;
        #201;
        Reset_n = 1;
        #200_000;
        $finish();
    end
        


endmodule