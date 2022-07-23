module clock_generate(
    Clk,
    Reset_n,
    rx_data,
    rx_done,
    Hour,
    Minute,
    Seconds,
    uart_tx_flag
);
    input Clk;
    input Reset_n;
    input [7:0]rx_data;
    input rx_done;
    output reg [7:0]Hour;
    output reg [7:0]Minute;
    output reg [7:0]Seconds;
    output reg uart_tx_flag;

    reg r_rx_done0;
    reg r_rx_done;
    always@(posedge Clk)begin
        r_rx_done0 <= rx_done;
        r_rx_done <= r_rx_done0;
    end

    //串口数据接收
    reg [7:0]uart_data[5:0];
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n) begin
        uart_data[0] <= 0;
        uart_data[1] <= 0;
        uart_data[2] <= 0;
        uart_data[3] <= 0;
        uart_data[4] <= 0;
        uart_data[5] <= 0;
    end
    else if(r_rx_done0) begin
        uart_data[5] <= rx_data;
        uart_data[4] <= uart_data[5];
        uart_data[3] <= uart_data[4];
        uart_data[2] <= uart_data[3];
        uart_data[1] <= uart_data[2];
        uart_data[0] <= uart_data[1];
    end
    
    reg counter_flag;
    //串口数据解码
    //bit0:8'hff bit1:8'ha5 bit7:8'hf0
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        Hour <= 0;
        Minute <= 0;
        Seconds <= 0;
        counter_flag <= 0;
    end
    else if(r_rx_done)begin
        if((uart_data[0] == 8'hff) && (uart_data[1] == 8'ha5) && (uart_data[5] == 8'hf0)) begin
            Hour <= uart_data[2];
            Minute <= uart_data[3];
            Seconds <= uart_data[4];
            counter_flag <= 1;
        end
        else
            counter_flag <= 0;
    end

    //时钟计数产生
    reg [25:0]counter;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        counter <= 0;
    end
    else if(counter_flag == 1) begin
        if (counter == 50_000 -1)
            counter <= 0;
        else
            counter <= counter + +1'd1;
    end
    else 
        counter <= 0;
    //秒
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        Seconds <= 0;
    end
    //else if(counter == 50_000_000 -1) begin //1s 计时
    else if(counter == 50_000 -1) begin //1ms 计时

        if(Seconds >= 60)
            Seconds <= 0;
        else
            Seconds <= Seconds + 1'd1;
    end

    //分
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        Minute <= 0;
    end
    else if((counter == 50_000 -1) && (Seconds >= 60))begin
        if(Minute >= 60)
            Minute <= 0;
        else
            Minute <= Minute + 1'd1;
    end

    //时
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        Hour <= 0;
    end
    else if((counter == 50_000 -1) && (Minute >= 60) && (Seconds >= 60))begin
        if(Hour >= 24)
            Hour <= 0;
        else
            Hour <= Hour + 1'd1;
    end


    //reg uart_tx_flag;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        uart_tx_flag <= 0;
    //else if(counter == 50_000_000 -1) begin //1s 计时
    else if(counter == 50_000 -1)//1ms 计时
        uart_tx_flag <= 1;
    else 
        uart_tx_flag <= 0;

endmodule