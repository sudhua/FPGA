//****************************************************
// 设计顶层：VGA_TFT
// TFT分辨率：800 * 480 
// 数据格式：RGB565
//
//
//****************************************************
module VGA_TFT(
    Clk,
    Reset_n,
    VGA_HS,
    VGA_VS,
    VGA_BLK,
    VGA_RGB,
    TFT_BL //背光控制信号
);
    input Clk;
    input Reset_n;
    output  VGA_HS;//行同步信号
    output  VGA_VS;//场同步信号
    output  VGA_BLK; //有效数据传送信号；BLK信号高电平时，为有效数据输出的时间段
    output  [23:0]VGA_RGB; //输出数据信号 虽然使用RGB565 但是数据位数在兼容性上依然可以以RGB88配置，
                           //硬件设置端口时，多余的信号线不接就可以！
    output TFT_BL;

    wire Data_Req; //信号输入请求信号，目的是提前VGA_BLK一拍
    reg [23:0]disp_data; //输入数据信号
    wire [10:0]hcount;
    wire [10:0]vcount;
    VGA_CTRL VGA_CTRL(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .DATA(disp_data),
        .Data_Req(Data_Req),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLK(VGA_BLK),
        .VGA_RGB(VGA_RGB),
        .hcount(hcount),
        .vcount(vcount)
);

    //定义颜色编码
localparam 
    BLACK       = 24'h000000, //黑色
    BLUE        = 24'h0000FF, //蓝色
    RED         = 24'hFF0000, //红色
    PURPPLE     = 24'hFF00FF, //紫色
    GREEN       = 24'h00FF00, //绿色
    CYAN        = 24'h00FFFF, //青色
    YELLOW      = 24'hFFFF00, //黄色
    WHITE       = 24'hFFFFFF; //白色
    
//定义每个像素块的默认显示颜色值
localparam 
    R0_C0 = BLACK,  //第0行0列像素块
    R0_C1 = BLUE,   //第0行1列像素块
    R1_C0 = RED,    //第1行0列像素块
    R1_C1 = PURPPLE,//第1行1列像素块
    R2_C0 = GREEN,  //第2行0列像素块
    R2_C1 = CYAN,   //第2行1列像素块
    R3_C0 = YELLOW, //第3行0列像素块
    R3_C1 = WHITE;  //第3行1列像素块

    wire R0_act = vcount >= 0 && vcount < 120;  //正在扫描第0行
    wire R1_act = vcount >= 120 && vcount < 240;//正在扫描第1行
    wire R2_act = vcount >= 240 && vcount < 360;//正在扫描第2行
    wire R3_act = vcount >= 360 && vcount < 480;//正在扫描第3行
    
    // wire C0_act = hcount >= 0 && hcount < 320; //正在扫描第0列
    // wire C1_act = hcount >= 320 && hcount < 640;//正在扫描第1列 
    wire C0_act = hcount >= 0 && hcount < 400; //正在扫描第0列
    wire C1_act = hcount >= 400 && hcount < 800;//正在扫描第1列 
    
    wire R0_C0_act=R0_act & C0_act;//第0行0列像素块处于被扫描中标志信号
    wire R0_C1_act=R0_act & C1_act;//第0行1列像素块处于被扫描中标志信号
    wire R1_C0_act=R1_act & C0_act;//第1行0列像素块处于被扫描中标志信号
    wire R1_C1_act=R1_act & C1_act;//第1行1列像素块处于被扫描中标志信号
    wire R2_C0_act=R2_act & C0_act;//第2行0列像素块处于被扫描中标志信号
    wire R2_C1_act=R2_act & C1_act;//第2行1列像素块处于被扫描中标志信号
    wire R3_C0_act=R3_act & C0_act;//第3行0列像素块处于被扫描中标志信号
    wire R3_C1_act=R3_act & C1_act;//第3行1列像素块处于被扫描中标志信号

    always@(*)
        case({R0_C0_act,R0_C1_act,R1_C0_act,R1_C1_act,R2_C0_act,R2_C1_act,R3_C0_act,R3_C1_act})
            8'b0000_0001: disp_data = R3_C1;
            8'b0000_0010: disp_data = R3_C0;
            8'b0000_0100: disp_data = R2_C1;
            8'b0000_1000: disp_data = R2_C0;
            8'b0001_0000: disp_data = R1_C1;
            8'b0010_0000: disp_data = R1_C0;
            8'b0100_0000: disp_data = R0_C1;
            8'b1000_0000: disp_data = R0_C0;
            default :disp_data = R0_C0;
        endcase


endmodule