module counter_led_4(
    Clk,
    Reset_n,
    Ctrl, //LED状态控制
    Time, //LED状态变化的时间
    led
);
    input Clk;
    input Reset_n;
    input [7:0]Ctrl;
    input [31:0]Time;
    reg EN;
    output reg led;
    
    reg [18:0]counter0;//EN信号定时
    reg [31:0]counter;
    reg [2:0]counter2;
    //EN信号10ms周期定时
    always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
        counter0 <= 0;
    else if(counter0 == 5000000-1) //10ms周期
        counter0 <= 0;
    else
        counter0 <= counter0 + 1'd1;
    end
   //EN逻辑功能：EN保持高电平时LED工作。     
   always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
        EN <= 0;
    else if(counter0 == 0)
        EN <= 1;
    //else if(counter2 == 7) //有问题的写法
    else if((counter2 == 7)&&(counter >= Time -1))
        EN <= 0;
    end
    //LED状态变化的时间，例如10us改变一次状态。
    //tb中更改Time的值来实现。
    always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
        counter <= 0;
    else if(EN)begin
        if(counter >= Time -1) //10us定时
            counter <= 0;
        else
            counter <= counter + 1'd1;
        end
    else
        counter <= 0; //不在EN信号有效电平（高电平）期间，计数值一律清零。
    end
    //每隔10us 赋予LED不同的值   
    always@(posedge Clk or negedge Reset_n)begin
        if(!Reset_n)
            counter2 <= 0;
        else if(EN)begin
            if(counter >= Time -1)//计时10usled控制信号的值+1。
                counter2 <= counter2 + 1'd1;
            end
        else
            counter2 <= 0;//不在EN信号有效电平（高电平）期间，计数值一律清零。
        end
    //每隔10us 赋予LED不同的值   
    always@(posedge Clk or negedge Reset_n)begin
        if(!Reset_n)
            led <= 0;
        else (* sw *) case (counter2)
            0:led <= Ctrl[7];
            1:led <= Ctrl[6];
            2:led <= Ctrl[5];
            3:led <= Ctrl[4];
            4:led <= Ctrl[3];
            5:led <= Ctrl[2];
            6:led <= Ctrl[1];
            7:led <= Ctrl[0];
            default:led <= led;
                endcase
        end  
            
endmodule 