module uart_tx_test(
    Clk,
    Reset_n,
    uart_tx
);
    
    input Clk;
    input Reset_n;
    output uart_tx;
    
    reg [7:0]Data;
    reg send_go;
    wire uart_tx;
    wire tx_done;

uart_byte_tx uart_byte_tx_inst0(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .Data(Data),
    .baud_set(3'd4),
    .send_go(send_go),
    .uart_tx(uart_tx),
    .tx_done(tx_done)
    );
    //10ms计数器
    reg [18:0]counter;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        counter <= 0;
    else if(counter == 500000-1)
        counter <= 0;
    else
        counter <= counter + 1'd1;
        
    //10ms产生一次发送脉冲信号
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        send_go <= 0;
    else if(counter == 1)
        send_go <= 1;
    else
        send_go <= 0;
    
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Data <= 0;
    else if(tx_done)
        Data <= Data + 1'd1;

    
endmodule
