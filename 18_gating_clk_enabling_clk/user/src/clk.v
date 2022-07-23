module my_clk(
    Clk,
    Reset_n,
    led_0,
    led_1
);
    input Clk;
    input Reset_n;
    output reg led_0;
    output reg led_1;

    reg [17:0]div_cnt;
    //时钟分频计数
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if (div_cnt == 25_000 -1) //1ms 1kHz
        div_cnt <= 0;
    else
        div_cnt <= div_cnt + 1'd1;
    
    //门控时钟
    reg dri_clk_1k;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        dri_clk_1k <= 0;
    else if (div_cnt == 25_000 -1)
        dri_clk_1k <= ~dri_clk_1k;

    always@(posedge dri_clk_1k or negedge Reset_n)
    if(!Reset_n)
        led_0 <= 0;
    else
        led_0 <= ~led_0;

    //使能时钟
    reg clk_1k;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        clk_1k <= 0;
    else if (div_cnt == 25_000 -1)
        clk_1k <= 1;
    else
        clk_1k <= 0;

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        led_1 <= 0;
    else if(clk_1k)
        led_1 <= ~led_1;

endmodule