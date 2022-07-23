module uart_tx_data(
    Clk,
    Reset_n,
    Data40,
    Trans_Go,
    Trans_Done,
    uart_tx
);
    input Clk;
    input Reset_n;
    input  [39:0]Data40;
    input  Trans_Go;
    output reg Trans_Done;
    output  uart_tx;
    
    reg [7:0]Data;
    reg send_go;
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

    reg [2:0]sate;
    always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)begin
        Trans_Done <= 0;
        Data <= 0;
        send_go <= 0;
        sate <= 0;
    end
    else if(sate == 0)
        if(Trans_Go)begin
            //Trans_Go <= 0;
            Data <= Data40[7:0];
            send_go <= 1;
            sate <= 1;
        end
        else begin
            Trans_Done <= 0;
            Data <= Data;
            send_go <= 0;
            sate <= 0;
        end
    else if (sate == 1)
        if(tx_done)begin
            Data <= Data40[15:8];
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
            Data <= Data40[23:16];
            send_go <= 1;
            sate <= 3;
        end
        else begin
            Data <= Data;
            send_go <= 0;
            sate <= 2;
        end
    else if (sate == 3)
        if(tx_done)begin
            Data <= Data40[31:24];
            send_go <= 1;
            sate <= 4;
        end
        else begin
            Data <= Data;
            send_go <= 0;
            sate <= 3;
        end
    else if (sate == 4)
        if(tx_done)begin
            Data <= Data40[39:32];
            send_go <= 1;
            sate <= 5;
        end
        else begin
            Data <= Data;
            send_go <= 0;
            sate <= 4;
        end
    else if (sate == 5)
        if(tx_done)begin
            Trans_Done <= 1;
            sate <= 0;
        end
        else begin
            Data <= Data;
            send_go <= 0;
            sate <= 5;
        end
    end
endmodule