module key_filter(
    Clk,
    Reset_n,
    key,
    key_flag
);
    input Clk;
    input Reset_n;
    input key; 
    output reg key_flag;

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

    reg [1:0]key_state;
    reg [19:0]key_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        key_state <= 0;
        key_cnt <= 0;
        key_flag_negedge <= 0;
        key_flag_posedge <= 0;
    end
    else case (key_state)
        0:  begin  
                key_flag_posedge <= 0;
                if(key_negedge)begin
                    key_state <= 1;  
                end
                else begin
                    key_state <= 0;
                end
            end
        1:
            if(key_cnt >= 1_000_000 -1)begin
                key_state <= 2;
                key_cnt <= 0;
                key_flag_negedge <= 1;
            end
            else if (key_posedge && (key_cnt < (1_000_000 -1)))begin
                key_state <= 0;
                key_cnt <= 0;
            end
            else begin
                key_cnt <= key_cnt + 1'd1;
                key_state <= 1;
            end
        2:  begin
                key_flag_negedge <= 0;
                if(key_posedge)begin
                    key_state <= 3;
                
                end
                else begin
                    key_state <= 2;
                end
            end
        3:
            if(key_cnt >= 1_000_000 -1)begin
                key_cnt <= 0;
                key_state <= 0;
                key_flag_posedge <= 1;
            end
            else if (key_negedge && (key_cnt < (1_000_000 -1)))begin
                key_state <= 2;
                key_cnt <= 0;
            end
            else begin
                key_cnt <= key_cnt + 1'd1;
                key_state <= 3;
            end
    endcase

endmodule