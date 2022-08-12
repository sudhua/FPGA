module uart_byte_rx(
    Clk,
    Reset_n,
    uart_rx,
    baud_set,
    Data,
    Rx_Done
);

    input Clk;
    input Reset_n;
    input uart_rx;
    input [2:0]baud_set;
    output reg [7:0]Data;
    output reg Rx_Done;

    //检测起始位
    reg [1:0]uart_rx_r;

    always@(posedge Clk or negedge Reset_n) 
    if(!Reset_n)
        uart_rx_r <= 0;
    else begin
        uart_rx_r[0] <= uart_rx;
        uart_rx_r[1] <= uart_rx_r[0];
    end

    //下降沿信号
    wire negedge_uart_rx;

    assign negedge_uart_rx = ((uart_rx_r == 2'b10) ? 1:0);

    //波特率设定
    reg [8:0]bps_DR;

    always@(*) begin
        case(baud_set)
            0: bps_DR = 1000_000_000/9600/20/16-1;
            1: bps_DR = 1000_000_000/19200/20/16-1;
            2: bps_DR = 1000_000_000/38400/20/16-1;
            3: bps_DR = 1000_000_000/57600/20/16-1;
            4: bps_DR = 1000_000_000/115200/20/16-1;
        endcase
    end

    //开启传送
    reg RX_EN;
    reg [2:0]sta_bit;

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        RX_EN <= 0;
    else if(negedge_uart_rx)
        RX_EN <= 1;
    //else if(Rx_Done | (sta_bit >= 4))
    else if(Rx_Done || (sta_bit >= 4))
        RX_EN <= 0;

    //16分频时钟产生
    reg [8:0]div_cnt;
    //wire [8:0]bps_clk_16x;
    wire bps_clk_16x;
    //assign bps_clk_16x = (bps_DR / 2);

    assign bps_clk_16x = (div_cnt == bps_DR / 2);
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if(RX_EN)begin
        //if(div_cnt == bps_clk_16x)
        if(div_cnt == bps_DR)
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1'd1;
    end
    else
        div_cnt <= 0;

    
    //时钟计数产生
    reg [7:0]bps_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        bps_cnt <= 0;
    else if(RX_EN) begin
        //if(bps_cnt == 160 -1)
        if(bps_clk_16x) begin
            //if(bps_cnt == 160 -1)
            if(bps_cnt == 160)
                bps_cnt <= 0;
            else
                bps_cnt <= bps_cnt + 1'd1;
        end
        else
            bps_cnt <= bps_cnt;
    end
    else
        bps_cnt <= 0;
    
    //信号采样
    reg [2:0]r_data[7:0];
    reg [2:0]sto_bit;
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        sta_bit <= 0;
        r_data[0] <= 0;
        r_data[1] <= 0;
        r_data[2] <= 0;
        r_data[3] <= 0;
        r_data[4] <= 0;
        r_data[5] <= 0;
        r_data[6] <= 0;
        r_data[7] <= 0;
        sto_bit <= 0;
    end
    //else if(RX_EN) begin
    else if(bps_clk_16x) begin 
        case(bps_cnt)
            0:begin
                sta_bit <= 0;
                r_data[0] <= 0;
                r_data[1] <= 0;
                r_data[2] <= 0;
                r_data[3] <= 0;
                r_data[4] <= 0;
                r_data[5] <= 0;
                r_data[6] <= 0;
                r_data[7] <= 0;
                sto_bit <= 0;
                //Rx_Done <= 0;  //发送完成标志清零
            end
            5,6,7,8,9,10,11:             sta_bit <= sta_bit + uart_rx;
            21,22,23,24,25,26,27:        r_data[0] <= r_data[0] + uart_rx;
            37,38,39,40,41,42,43:        r_data[1] <= r_data[1] + uart_rx;
            53,54,55,56,57,58,59:        r_data[2] <= r_data[2] + uart_rx;
            69,70,71,72,73,74,75:        r_data[3] <= r_data[3] + uart_rx;
            85,86,87,88,89,90,91:        r_data[4] <= r_data[4] + uart_rx;
            101,102,103,104,105,106,107: r_data[5] <= r_data[5] + uart_rx;
            117,118,119,120,121,122,123: r_data[6] <= r_data[6] + uart_rx;
            133,134,135,136,137,138,139: r_data[7] <= r_data[7] + uart_rx;
            149,150,151,152,153,154,155: sto_bit <= sto_bit + uart_rx;
        endcase

    end
    
    //传送完成信号
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Rx_Done <= 0;
    //else if((div_cnt == bps_DR / 2) && (bps_cnt == 160 -1))
    
    //else if((div_cnt == bps_DR / 2) && (bps_cnt == 160))
    //因RAM写入时序更改
    else if((div_cnt == bps_DR / 2) && (bps_cnt == 160))
        Rx_Done <= 1;
    else
        Rx_Done <= 0;

    //数据解码存储
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        Rx_Done <= 0;
        Data <= 0;
    end
    //else if(Rx_Done == 1) begin
    //因RAM写入时序更改
    else if((div_cnt == bps_DR / 2) && (bps_cnt == 159)) begin
        Data[0] <= (r_data[0] >= 4)?1:0;
        Data[1] <= (r_data[1] >= 4)?1:0;
        Data[2] <= (r_data[2] >= 4)?1:0;
        Data[3] <= (r_data[3] >= 4)?1:0;
        Data[4] <= (r_data[4] >= 4)?1:0;
        Data[5] <= (r_data[5] >= 4)?1:0;
        Data[6] <= (r_data[6] >= 4)?1:0;
        Data[7] <= (r_data[7] >= 4)?1:0;
    end
    else
        Data <= Data;
        
endmodule