module UART_RAM_TFT(
    Clk,
    Reset_n,
    uart_rx,
    VGA_HS,
    VGA_VS,
    VGA_BLK,
    VGA_RGB,
    TFT_BL 
);
    input Clk;
    input Reset_n;
    input uart_rx;
    output VGA_HS;
    output VGA_VS;
    output VGA_BLK;
    output [15:0]VGA_RGB;
    output TFT_BL;

    wire Clk_TFT;
    wire [15:0]disp_data;
    reg [15:0]ram_rd_addr;
    wire Rx_Done;
    wire [7:0]rx_data;
    wire ram_wr_en;
    wire [15:0] ram_wr_addr;
    wire [15:0] ram_wr_data;
    wire [15:0]ram_rd_data;
    wire Data_Req;
    wire [10:0] hcount,vcount;
    wire ram_rd_en;

    uart_byte_rx uart_byte_rx(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .uart_rx(uart_rx),
        .baud_set(4),
        .Data(rx_data),
        .Rx_Done(Rx_Done)
    );

    img_rx_wr img_rx_wr(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .rx_data(rx_data),
        .Rx_Done(Rx_Done),
        .ram_wr_en(ram_wr_en),
        .ram_wr_addr(ram_wr_addr),
        .ram_wr_data(ram_wr_data)
    );
    
    ram ram (
        .clka(Clk),    // input wire clka
        .ena(1),      // input wire ena
        .wea(ram_wr_en),      // input wire [0 : 0] wea
        .addra(ram_wr_addr),  // input wire [15 : 0] addra
        .dina(ram_wr_data),    // input wire [15 : 0] dina
        .clkb(Clk_TFT),    // input wire clkb
        .enb(1),      // input wire enb
        .addrb(ram_rd_addr),  // input wire [15 : 0] addrb
        .doutb(ram_rd_data)  // output wire [15 : 0] doutb
    );


    MMCM MMCM(
        .clk_out1(Clk_TFT),
        .clk_in1(Clk)
    );
    
    VGA_CTRL VGA_CTRL(
        .Clk(Clk_TFT),
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
    
    //读取RAM中存放的图像 256 * 256
    always@(posedge Clk_TFT or negedge Reset_n)
    if(!Reset_n)
        ram_rd_addr <= 0;
    else if(ram_rd_en)
        ram_rd_addr <= ram_rd_addr + 1'd1;
    else
        ram_rd_addr <= ram_rd_addr;

    // always@(posedge Clk_TFT)
    //     ram_r_en <= Data_Req && (hcount <= 255) && (vcount <= 255);
    //打拍
    assign ram_rd_en = Data_Req && (hcount <= 257) && (vcount <= 257);
    assign disp_data = ram_rd_en ? ram_rd_data : 0;
    // always@(posedge Clk_TFT)
    //assign VGA_RGB = Data_Req ? disp_data : 0;

    // always@(posedge Clk_TFT)
    //     VGA_RGB <= Data_Req ? disp_data : 0;

    

endmodule