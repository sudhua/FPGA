module uart_byte_tx(
    Clk,
    Reset_n,
    Data,
    baud_set,
    send_go,
    uart_tx,
    tx_done
    );
    input Clk;
    input Reset_n;
    input [2:0]baud_set;
    input [7:0]Data;
    input send_go;
    output reg uart_tx;
    output reg tx_done;
    
    //波特率选择
    reg [17:0]bps_DR;
    always@(*)
    case(baud_set)
        0:bps_DR = 1000000000/9600/20; 
        1:bps_DR = 1000000000/119200/20;
        2:bps_DR = 1000000000/38400/20;
        3:bps_DR = 1000000000/57600/20;
        4:bps_DR = 1000000000/115200/20;
    endcase

    //send_en使能信号配置
    reg send_en;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        send_en <= 0;
    else if(send_go) //发送起始信号
        send_en <= 1;
    else if(tx_done) //发送完成信号
        send_en <= 0;



    //产生一个波特率时钟
    reg [17:0]div_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if(send_en)begin
        if(div_cnt == bps_DR - 1)
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1'd1;
    end
    else
        div_cnt <= 0;
    
    //产生一个周期波特率时钟 
    reg [3:0]bps_cnt;
    wire bps_clk;
    assign bps_clk = (div_cnt == 1);   
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        bps_cnt <= 0;
    else if(send_en)begin 
        if(bps_clk)begin
            if(bps_cnt == 11)
                bps_cnt <= 0;
            else
                bps_cnt <= bps_cnt + 1'd1;
        end
    end
    else 
        bps_cnt <= 0;

    //发送完成信号
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        tx_done <= 0;
    else if ((bps_clk == 1)&&(bps_cnt == 10))
        tx_done <= 1;
    else
        tx_done <= 0;

    //数据寄存，避免发送过程中，这一字节数据改变。
    reg [7:0]r_Data;
    always@(posedge Clk)
    if(send_go)
        r_Data <= Data;
    else
        r_Data <= r_Data;

    //发送一个字节
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        uart_tx <= 1; 
    end
    else case(bps_cnt)
        //0:tx_done <= 0;
        1:uart_tx <= 0;
        2:uart_tx <= r_Data[0];
        3:uart_tx <= r_Data[1];
        4:uart_tx <= r_Data[2];
        5:uart_tx <= r_Data[3];
        6:uart_tx <= r_Data[4];
        7:uart_tx <= r_Data[5];
        8:uart_tx <= r_Data[6];
        9:uart_tx <= r_Data[7];
        10:uart_tx <= 1;
        11:uart_tx <= 1;
        default:uart_tx <= 1;
    endcase

endmodule
