module key_filter(
    Clk,
    Reset_n,
    key,
    key_flag,
    key_state
);
    input Clk;
    input Reset_n;
    input key; 
    output reg key_flag;
    output reg key_state;
    //为了加快仿真时间，对消抖时间进行调整，调整为20us。
    parameter Timer0 = 1_000; //20us
    //边沿检测，上下两种写法是一样的效果。
    reg [1:0]r_key;
    always@(posedge Clk)
        r_key <= {r_key[0], key};

    // always@(posedge Clk)begin
    //     r_key[0] <= key;
    //     r_key[1] <= r_key[0];
    // end

    wire key_negedge, key_posedge;
    assign  key_negedge = (r_key == 2'b10);
    assign key_posedge = (r_key == 2'b01);

    reg key_flag_negedge, key_flag_posedge;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        key_flag <= 0;
    else if(key_flag_negedge || key_flag_posedge)
        key_flag <= 1;
    else
        key_flag <= 0;

    reg [1:0]state;
    reg [19:0]key_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        state <= 0;
        key_state <= 1;
        key_cnt <= 0;
        key_flag_negedge <= 0;
        key_flag_posedge <= 0;
    end
    else case (state)
        0:  begin  
                key_flag_posedge <= 0;
                if(key_negedge)begin
                    state <= 1;  
                end
                else begin
                    state <= 0;
                end
            end
        1:
            if(key_cnt >= Timer0 -1)begin
                state <= 2;
                key_cnt <= 0;
                key_flag_negedge <= 1;
                key_state <= 0;
            end
            else if (key_posedge && (key_cnt < (Timer0 -1)))begin
                state <= 0;
                key_cnt <= 0;
            end
            else begin
                key_cnt <= key_cnt + 1'd1;
                state <= 1;
            end
        2:  begin
                key_flag_negedge <= 0;
                if(key_posedge)begin
                    state <= 3;
                
                end
                else begin
                    state <= 2;
                end
            end
        3:
            if(key_cnt >= Timer0 -1)begin
                key_cnt <= 0;
                state <= 0;
                key_flag_posedge <= 1;
                key_state <= 1;
            end
            else if (key_negedge && (key_cnt < (Timer0 -1)))begin
                state <= 2;
                key_cnt <= 0;
            end
            else begin
                key_cnt <= key_cnt + 1'd1;
                state <= 3;
            end
    endcase

endmodule