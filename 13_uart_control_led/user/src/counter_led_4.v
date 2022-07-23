module counter_led_4(
    Clk,
    Reset_n,
    Ctrl, //LED״̬����
    Time, //LED״̬�仯��ʱ��
    led
);
    input Clk;
    input Reset_n;
    input [7:0]Ctrl;
    input [31:0]Time;
    reg EN;
    output reg led;
    
    reg [18:0]counter0;//EN�źŶ�ʱ
    reg [31:0]counter;
    reg [2:0]counter2;
    //EN�ź�10ms���ڶ�ʱ
    always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
        counter0 <= 0;
    else if(counter0 == 5000000-1) //10ms����
        counter0 <= 0;
    else
        counter0 <= counter0 + 1'd1;
    end
   //EN�߼����ܣ�EN���ָߵ�ƽʱLED������     
   always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
        EN <= 0;
    else if(counter0 == 0)
        EN <= 1;
    //else if(counter2 == 7) //�������д��
    else if((counter2 == 7)&&(counter >= Time -1))
        EN <= 0;
    end
    //LED״̬�仯��ʱ�䣬����10us�ı�һ��״̬��
    //tb�и���Time��ֵ��ʵ�֡�
    always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
        counter <= 0;
    else if(EN)begin
        if(counter >= Time -1) //10us��ʱ
            counter <= 0;
        else
            counter <= counter + 1'd1;
        end
    else
        counter <= 0; //����EN�ź���Ч��ƽ���ߵ�ƽ���ڼ䣬����ֵһ�����㡣
    end
    //ÿ��10us ����LED��ͬ��ֵ   
    always@(posedge Clk or negedge Reset_n)begin
        if(!Reset_n)
            counter2 <= 0;
        else if(EN)begin
            if(counter >= Time -1)//��ʱ10usled�����źŵ�ֵ+1��
                counter2 <= counter2 + 1'd1;
            end
        else
            counter2 <= 0;//����EN�ź���Ч��ƽ���ߵ�ƽ���ڼ䣬����ֵһ�����㡣
        end
    //ÿ��10us ����LED��ͬ��ֵ   
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