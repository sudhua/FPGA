module uart_clock(
    Clk,
    Reset_n,
    Baud_Set,
    uart_rx,
    DS,
    SHCP,
    STCP
);
    input Clk;
    input Reset_n;
    input [2:0]Baud_Set;
    input uart_rx;
    output DS;
    output SHCP;
    output STCP;

    wire [7:0]rx_data;
    wire rx_done;
    wire [7:0]Hour;
    wire [7:0]Minute;
    wire [7:0]Seconds;
    wire [31:0]Disp_data;
    assign Disp_data = {Hour, Minute, Seconds, 8'h00};
    wire [7:0]Sel,Seg;
    wire [15:0]Data_in;
    assign Data_in = {Seg, Sel};
    wire EN;
    assign EN = 1;
    uart_byte_rx uart_byte_rx_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .uart_rx(uart_rx),
        .baud_set(Baud_Set),
        .Data(rx_data),
        .Rx_Done(rx_done)
    );

    clock_generate clock_generate_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .Hour(Hour),
        .Minute(Minute),
        .Seconds(Seconds)
    );

    hex8 hex8_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Disp_data(Disp_data),
        .Sel(Sel),
        .Seg(Seg)
    );

    hex8_595 hex8_595_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data_in(Data_in),
        .EN(EN),
        .SHCP(SHCP), //移位时钟
        .STCP(STCP), //存储时钟
        .DS(DS)
    );

endmodule