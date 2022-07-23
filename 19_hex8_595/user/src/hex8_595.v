module hex8_595(
    Clk,
    Reset_n,
    Data_in,
    EN,
    SHCP, //移位时钟
    STCP, //存储时钟
    DS
);

    input Clk;
    input Reset_n;
    input [15:0]Data_in;
    input EN;
    output reg SHCP;
    output reg STCP;
    output reg DS;

    reg [15:0]r_data;
    always@(posedge Clk or Reset_n)
    if(!Reset_n)
        r_data <= 0;
    else if (EN)
        r_data <= Data_in;
    else 
        r_data <= r_data;

    //分频计数 12.5M
    parameter DIV_MAX = 4;
    reg [2:0]div_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if (div_cnt == (DIV_MAX - 1))
        div_cnt <= 0;
    else
        div_cnt <= div_cnt + 1'd1;
    
    //6.25M的【使能时钟】产生
    reg Clk_plus;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Clk_plus <= 0;
    else if(div_cnt == 1)
        Clk_plus <= 1;
    else 
        Clk_plus <= 0;

    //595时序输出
    reg [5:0]counter;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        counter <= 0;
    else if (Clk_plus)begin
        if(counter == 32)
            counter <= 0;
        else 
            counter <= counter + 1'd1;
    end

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        SHCP <= 0; 
        DS <= 0; 
        STCP <= 0;
    end
    else if(Clk_plus)
        case (counter)
            0:begin SHCP <= 0; DS <= r_data[15]; STCP <= 0;end 
            1:SHCP <= 1;
            2:begin SHCP <= 0; DS <= r_data[14]; end 
            3:SHCP <= 1;
            4:begin SHCP <= 0; DS <= r_data[13]; end 
            5:SHCP <= 1;
            6:begin SHCP <= 0; DS <= r_data[12]; end 
            7:SHCP <= 1;
            8:begin SHCP <= 0; DS <= r_data[11]; end 
            9:SHCP <= 1;
            10:begin SHCP <= 0; DS <= r_data[10]; end 
            11:SHCP <= 1;
            12:begin SHCP <= 0; DS <= r_data[9]; end 
            13:SHCP <= 1;
            14:begin SHCP <= 0; DS <= r_data[8]; end 
            15:SHCP <= 1;
            16:begin SHCP <= 0; DS <= r_data[7]; end 
            17:SHCP <= 1;
            18:begin SHCP <= 0; DS <= r_data[6]; end 
            19:SHCP <= 1;
            20:begin SHCP <= 0; DS <= r_data[5]; end 
            21:SHCP <= 1;
            22:begin SHCP <= 0; DS <= r_data[4]; end 
            23:SHCP <= 1;
            24:begin SHCP <= 0; DS <= r_data[3]; end 
            25:SHCP <= 1;
            26:begin SHCP <= 0; DS <= r_data[2]; end 
            27:SHCP <= 1;
            28:begin SHCP <= 0; DS <= r_data[1]; end 
            29:SHCP <= 1;
            30:begin SHCP <= 0; DS <= r_data[0]; end 
            31:SHCP <= 1;
            32:STCP <= 1;
            default: begin SHCP <= 0; DS <= 0; STCP <= 0;end
        endcase

    

    




endmodule