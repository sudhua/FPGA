//*****************************
//不使用状态机实现的方法
//*****************************

module uart_tx_data4(
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

    uart_byte_tx uart_byte_tx_inst2(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data(Data),
        .baud_set(3'd4),
        .send_go(send_go),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
        );

    reg [2:0]state;
    reg [2:0]counter;
    reg counter2;

    always@(negedge Reset_n)
    if(!Reset_n)
        counter2 <= 0;    
   

    always@(posedge tx_done or negedge Reset_n)
    if(!Reset_n)
        counter <= 0;    
    else 
        counter <= counter + 1'd1;

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        Trans_Done <= 0;
        Data <= 0;
        send_go <= 0;
        state <= 0;
    end
    // else 
    // case(state) 
    //     0:
    //         if(Trans_Go)begin
    //             Data <= Data40[7:0];
    //             send_go <= 1;
    //             state <= 1;
    //         end
    //         else begin
    //             Trans_Done <= 0;
    //             Data <= Data;
    //             send_go <= 0;
    //             state <= 0;
    //             counter <= 0;    
    //         end
           
    //     1:
    //         if(tx_done)begin
    //             if(counter == 1)begin
    //                 Data <= Data40[15:8];
    //                 send_go <= 1;
    //             end
    //             else if (counter == 2)begin
    //                 Data <= Data40[23:16];
    //                 send_go <= 1;
    //             end
    //             else if (counter == 3)begin
    //                 Data <= Data40[31:24];
    //                 send_go <= 1;
    //             end
    //             else if (counter == 4)begin
    //                 Data <= Data40[39:32];
    //                 send_go <= 1;
    //                 state <= 2;
    //                 end
                
    //         end
    //         else begin
    //             Data <= Data;
    //             send_go <= 0;
    //             state <= 1;
    //         end
           
    //     2:
    //         if(tx_done)begin
    //             Trans_Done <= 1;
    //             state <= 0;
    //         end
    //         else begin
    //             Data <= Data;
    //             send_go <= 0;
    //             state <= 2;
    //         end
    // endcase

    else if(Trans_Go)begin
        if((counter == 0)&&(counter2 == 0))begin
            Data <= Data40[7:0];
            send_go <= 1;
            counter2 <= counter2 + 1'd1;
        end
        else begin
            Data <= Data;
            send_go <= 0;
        end
        if(tx_done)begin
                if(counter == 1)begin
                    Data <= Data40[15:8];
                    send_go <= 1;
                end
                else if (counter == 2)begin
                    Data <= Data40[23:16];
                    send_go <= 1;
                end
                else if (counter == 3)begin
                    Data <= Data40[31:24];
                    send_go <= 1;
                end
                else if (counter == 4)begin
                    Data <= Data40[39:32];
                    send_go <= 1;
                end
                
        end
        else begin
            Data <= Data;
            send_go <= 0;
        end

    end
    else begin
        Trans_Done <= 0;
        Data <= Data;
        send_go <= 0;
        counter <= 0;    
    end
    
endmodule