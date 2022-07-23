module uart_tx_clock_to_pc(
    Clk,
    Reset_n,
    uart_tx
);

    input Clk;
    input Reset_n;
    output uart_tx;
    

    wire Hour, Minute, Seconds;
    wire [15:0]Clock_Data;
    assign Clock_Data = {4'h0, Hour, Minute, Seconds};
    wire uart_tx_flag;
    clock_generate clock_generate_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .rx_data(),
        .rx_done(),
        .Hour(Hour),
        .Minute(Minute),
        .Seconds(Seconds),
        .uart_tx_flag(uart_tx_flag)
    );

    wire tx_done;
    reg send_go;
    reg [7:0]Data;
    uart_byte_tx uart_byte_tx_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data(Data),
        .baud_set(3'd4),
        .send_go(send_go),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );

    reg [15:0]r_Data;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        r_Data <= 0;
    else if (uart_tx_flag)
        r_Data <= Clock_Data;
    else
        r_Data <= r_Data;

    reg [2:0]sate;
    always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)begin
        send_go <= 0;
        sate <= 0;
    end
    else if(sate == 0)
        if(uart_tx_flag)begin
            //Trans_Go <= 0;
            Data <= r_Data[15:8];
            send_go <= 1;
            sate <= 1;
        end
        else begin
            //Trans_Done <= 0;
            Data <= Data;
            send_go <= 0;
            sate <= 0;
        end
    else if (sate == 1)
        if(tx_done)begin
            Data <= r_Data[7:0];
            send_go <= 1;
            sate <= 2;
        end
        else begin
            Data <= Data;
            send_go <= 0;
            sate <= 1;
        end
    else if (sate == 2)
        if(tx_done)begin
            //Trans_Done <= 1;
            sate <= 0;
        end
        else begin
            Data <= Data;
            send_go <= 0;
            sate <= 2;
        end
    end



endmodule