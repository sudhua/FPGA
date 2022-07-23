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
    
    //������ѡ��
    reg [17:0]bps_DR; 
    always@(*)
    case(baud_set)
        0:bps_DR = 1000000000/9600/20;   //5208;  9600bps
        1:bps_DR = 1000000000/119200/20; //2604;  119200bps
        2:bps_DR = 1000000000/38400/20;  //1302;  38400bps
        3:bps_DR = 1000000000/57600/20;  //868;   57600bps
        4:bps_DR = 1000000000/115200/20; //434;   115200bps
    endcase

    //����һ��������ʱ��
    reg [17:0]div_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if(send_en)begin //����ʹ���ź�ʱ���ſ�����������ʹ���ź�ʱ��һ��Ϊ��
        if(div_cnt == bps_DR - 1) //���������������趨ֵʱ����������
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1'd1;
    end
    else
        div_cnt <= 0;
    
    //����һ�����ڲ�����ʱ�� 
    reg [3:0]bps_cnt;
    wire bps_clk;
    //��div_cntΪ1ʱ���������������Ϊ�棬bps_clkΪ1�����������Ϊ0
    assign bps_clk =  (div_cnt == 1); 
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        bps_cnt <= 0;
    else if(send_en)begin 
        if(bps_clk)begin      //��send_enʹ�ܺ��ھ���һ��ʱ�ӣ��Ϳ�ʼ�������ݣ�
            if(bps_cnt == 11) //�������Ϊbps_DR - 1������Ҫ�ȴ��ϳ�һ��ʱ�䣬���Ե����˱Ƚ�ֵ��
                bps_cnt <= 0; 
            else //���ڷ���ʱ�Ӽ�������һ��ʱ��[bps_cnt == 1]������ʼλ���ڶ���ʱ�ӷ����������λ������...
                bps_cnt <= bps_cnt + 1'd1;
        end
    end
    else 
        bps_cnt <= 0;
    
    //����һ���ֽ�
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        uart_tx <= 1;//����ͨ��Э���й涨��ʼ�ź�Ϊ1�����ڵ͵�ƽ�������ź�Ϊ1�����ڸߵ�ƽ�����Կ���ʱ���ڴ������ߡ�
        tx_done <= 0;//1���ֽ����ݷ�������źţ�δ���ʱΪ�͵�ƽ
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
