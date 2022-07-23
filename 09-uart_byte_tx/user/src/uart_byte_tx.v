module uart_byte_tx(
    Clk,
    Reset_n,
    Data,
    baud_set,
    send_en,
    uart_tx,
    tx_done
    );
    input Clk;
    input Reset_n;
    input [2:0]baud_set;
    input [7:0]Data;
    input send_en;
    output reg uart_tx;
    output reg tx_done;
    
    //波特率选择
    reg [17:0]bps_DR; 
    always@(*)
    case(baud_set)
        0:bps_DR = 1000000000/9600/20;   //5208;  9600bps
        1:bps_DR = 1000000000/119200/20; //2604;  119200bps
        2:bps_DR = 1000000000/38400/20;  //1302;  38400bps
        3:bps_DR = 1000000000/57600/20;  //868;   57600bps
        4:bps_DR = 1000000000/115200/20; //434;   115200bps
    endcase

    //产生一个波特率时钟
    reg [17:0]div_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if(send_en)begin //当有使能信号时，才开启计数，无使能信号时，一律为零
        if(div_cnt == bps_DR - 1) //当计数满波特率设定值时，计数清零
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1'd1;
    end
    else
        div_cnt <= 0;
    
    //产生一个周期波特率时钟 
    reg [3:0]bps_cnt;
    wire bps_clk;
    //当div_cnt为1时，条件成立，结果为真，bps_clk为1，其余情况都为0
    assign bps_clk =  (div_cnt == 1); 
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        bps_cnt <= 0;
    else if(send_en)begin 
        if(bps_clk)begin      //当send_en使能后，在经过一个时钟，就开始发送数据，
            if(bps_cnt == 11) //如果设置为bps_DR - 1，则需要等待较长一段时间，所以调整了比较值。
                bps_cnt <= 0; 
            else //串口发送时钟计数，第一个时钟[bps_cnt == 1]发送起始位，第二个时钟发送数据最低位，依次...
                bps_cnt <= bps_cnt + 1'd1;
        end
    end
    else 
        bps_cnt <= 0;
    
    //发送一个字节
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        uart_tx <= 1;//串口通信协议中规定起始信号为1个周期低电平，结束信号为1个周期高电平，所以空闲时串口传输拉高。
        tx_done <= 0;//1个字节数据发送完成信号，未完成时为低电平
    end
    else case(bps_cnt)
        0:tx_done <= 0;
        1:uart_tx <= 0;
        2:uart_tx <= Data[0];
        3:uart_tx <= Data[1];
        4:uart_tx <= Data[2];
        5:uart_tx <= Data[3];
        6:uart_tx <= Data[4];
        7:uart_tx <= Data[5];
        8:uart_tx <= Data[6];
        9:uart_tx <= Data[7];
        10:uart_tx <= 1;
        11:begin uart_tx <= 1;tx_done <= 1;end
        default:uart_tx <= 1;
    endcase

endmodule
