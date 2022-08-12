module img_rx_wr(
    Clk,
    Reset_n,
    rx_data,
    Rx_Done,
    ram_wr_en,
    ram_wr_addr,
    ram_wr_data
);
    input Clk;
    input Reset_n;
    input [7:0]rx_data;
    input Rx_Done;
    output reg ram_wr_en;
    output reg [15:0]ram_wr_addr;
    output [15:0]ram_wr_data;
    reg [15:0]data_cnt;
    reg [15:0]rx_data_tmp;

    //接收数据个数计数
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        data_cnt <= 0;
    else if(Rx_Done)
        data_cnt <= data_cnt + 1'd1;
    else
        data_cnt <= data_cnt;

    //数据暂存，两个8位数据拼接为16位数据
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        rx_data_tmp <= 0;
    else if(Rx_Done)begin
        rx_data_tmp[7:0] <= rx_data;
        rx_data_tmp[15:8] <= rx_data_tmp[7:0];
    end
    else
        rx_data_tmp <= rx_data_tmp;

    //RAM数据写入使能
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        ram_wr_en <= 0;
    //else if((!(data_cnt / 2))&&(Rx_Done))
    else if((data_cnt[0])&&(Rx_Done))
        ram_wr_en <= 1;
    else
        ram_wr_en <= 0;

    //RAM数据写入地址
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        ram_wr_addr <= 0;
    else if((data_cnt[0])&&(Rx_Done))
        //ram_wr_addr <= ram_wr_addr + 1'd1;
        ram_wr_addr <= data_cnt[15:1];
    else
        ram_wr_addr <= ram_wr_addr;

    assign ram_wr_data = rx_data_tmp;
    // always@(posedge Clk or negedge Reset_n)
    // if(!Reset_n)
    //     ram_wr_data <= 0;
    // else if(ram_wr_en)
    //     ram_wr_data <= rx_data_tmp;
    // else
    //     ram_wr_data <= ram_wr_data;




endmodule