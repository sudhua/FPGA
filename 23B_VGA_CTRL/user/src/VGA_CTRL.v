module VGA_CTRL(
    Clk,
    Reset_n,
    DATA,
    Data_Req,
    VGA_HS,
    VGA_VS,
    VGA_BLK,
    VGA_RGB,
    hcount,
    vcount
);
    input Clk;
    input Reset_n;
    input [23:0]DATA; //输入数据信号
    output reg Data_Req; //信号输入请求信号，目的是提前VGA_BLK一拍
    output reg VGA_HS;//行同步信号
    output reg VGA_VS;//场同步信号
    output reg VGA_BLK; //有效数据传送信号；BLK信号高电平时，为有效数据输出的时间段
    output reg [23:0]VGA_RGB; //输出数据信号
    output reg [11:0]hcount; //行数据数据点位置
    output reg [10:0]vcount; //列数据数据点位置

    `include "VGA_Resolution.v" //包含VGA_Resolution.v文件
    localparam Hsync_End = `H_Total_Time; //行同步总时间
    localparam HS_End = `H_Sync_Time; //行同步信号时间
    localparam Vsync_End = `V_Total_Time; //场同步总时间
    localparam VS_End = `V_Sync_Time; //场同步信号时间
    localparam Hdat_Begin = `H_Sync_Time + `H_Back_Porch + `H_Left_Border; //行数据传送起始时间
    localparam Hdat_End = `H_Sync_Time + `H_Back_Porch + `H_Left_Border +`H_Data_Time;//行数据传送停止时间
    localparam Vdat_Begin =  `V_Sync_Time + `V_Back_Porch + `V_Top_Border; //场数据传输起始时间
    localparam Vdat_End = `V_Sync_Time + `V_Back_Porch + `V_Top_Border + `V_Data_Time; //场数据传送停止时间

    reg [11:0] hcnt; //行时间计数器
    reg [10:0] vcnt; //场时间计数器

    //行计数器
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        hcnt <= 0;
    else if(hcnt >= Hsync_End - 1'd1)
        hcnt <= 0;
    else
        hcnt <= hcnt + 1'd1;

    //场计数器
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        vcnt <= 0;
    else if(hcnt == Hsync_End - 1'd1)begin
        if(vcnt >= Vsync_End - 1)
            vcnt <= 0;
        else
            vcnt <= vcnt + 1'd1;
    end
    else
        vcnt <= vcnt;
    //以下两种写法实现的效果是一样的，第二种写法看起来更加的简洁。
    //行同步信号
    // always@(posedge Clk or negedge Reset_n)
    // if(!Reset_n)
    //     VGA_HS <= 0;
    // else if(hcnt <= HS_End - 1'd1)
    //     VGA_HS <= 0;
    // else
    //     VGA_HS <= 1;
    //行同步信号
    always@(posedge Clk)
        VGA_HS <= (hcnt <= HS_End - 1'd1) ? 0 : 1;

    //场同步信号
    always@(posedge Clk)
        VGA_VS <= (vcnt <= VS_End - 1) ? 0 : 1;

    //BLK信号
    always@(posedge Clk)
        Data_Req <= ((hcnt >=  Hdat_Begin -1'd1) && (hcnt <=  Hdat_End - 2'd2) && (vcnt >= Vdat_Begin ) && (vcnt <= Vdat_End - 1'd1))? 1 : 0;

    always@(posedge Clk)
        VGA_BLK <= Data_Req;
    //always@(posedge Clk)
    //    VGA_BLK <= ((hcnt >=  Hdat_Begin + 1'd1) && (hcnt <=  Hdat_End) && (vcnt >= Vdat_Begin - 1) && (vcnt <= Vdat_End - 1))? 1 : 0;

    //信号传输
    always@(posedge Clk)
        VGA_RGB <= Data_Req ? DATA : 0;

    always@(posedge Clk)
        hcount <= Data_Req ? (hcnt - Hdat_Begin) : hcount;

    always@(posedge Clk)
        vcount <=  Data_Req ? (vcnt - Vdat_Begin + 2'd2) : vcount;



endmodule