module uart_cmd(
    Clk,
    Reset_n,
    rx_data,
    rx_done,
    led_ctrl,
    led_time_set
);
    input Clk;
    input Reset_n;
    input [7:0]rx_data;
    input rx_done;
    output reg [7:0]led_ctrl;
    output reg [31:0]led_time_set;
    
    reg r_rx_done0;
    reg r_rx_done;
    always@(posedge Clk)begin
        r_rx_done0 <= rx_done;
        r_rx_done <= r_rx_done0;
    end

    //串口数据接收
    reg [7:0]uart_data[7:0];
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n) begin
        uart_data[0] <= 0;
        uart_data[1] <= 0;
        uart_data[2] <= 0;
        uart_data[3] <= 0;
        uart_data[4] <= 0;
        uart_data[5] <= 0;
        uart_data[6] <= 0;
        uart_data[7] <= 0;
    end
    else if(r_rx_done0) begin
        uart_data[7] <= rx_data;
        uart_data[6] <= uart_data[7];
        uart_data[5] <= uart_data[6];
        uart_data[4] <= uart_data[5];
        uart_data[3] <= uart_data[4];
        uart_data[2] <= uart_data[3];
        uart_data[1] <= uart_data[2];
        uart_data[0] <= uart_data[1];
    end
    
    //串口数据解码
    //bit0:8'h55 bit1:8'ha5 bit7:8'hf0
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        led_ctrl <= 0;
        led_time_set <= 0;
    end
    else if(r_rx_done)
        if((uart_data[0] == 8'h55) && (uart_data[1] == 8'ha5) && (uart_data[7] == 8'hf0)) begin
            led_time_set[31:24] <= uart_data[2];
            led_time_set[24:16] <= uart_data[3];
            led_time_set[15:8] <= uart_data[4];
            led_time_set[7:0] <= uart_data[5];
            led_ctrl <= uart_data[6];
        end

endmodule