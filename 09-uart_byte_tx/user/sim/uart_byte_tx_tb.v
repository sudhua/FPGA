`timescale 1ns / 1ns
module uart_byte_tx_tb;
    reg Clk;
    reg Reset_n;
    reg [7:0]Data;
    reg [2:0]baud_set;
    reg send_en;
    wire uart_tx;
    wire tx_done;
uart_byte_tx uart_byte_tx_inst0(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .Data(Data),
    .baud_set(baud_set),
    .send_en(send_en),
    .uart_tx(uart_tx),
    .tx_done(tx_done)
    );
    //生成vcd格式文件，可以用于支持vcd观察波形的软件查看。
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,uart_byte_tx_tb);
    end

    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
    Reset_n = 0;
    Data = 0;
    baud_set = 4;
    send_en = 0;
    #201;
    Reset_n = 1;
    #20000;
    Data = 8'b1010_1011;
    send_en = 1;
    #20;
    @(posedge tx_done);//阻塞等待tx_done上升沿来临，
    send_en = 0;
    #20000;
    Data = 8'b0010_1110;
    send_en = 1;
    #20;
    @(posedge tx_done);
    send_en = 0;
    $finish;
    end
endmodule
