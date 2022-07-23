module uart_control_led(
    Clk,
    Reset_n,
    uart_rx,
    led
);
    input Clk;
    input Reset_n;
    input uart_rx;
    output led;

    wire [7:0]rx_data;
    wire [7:0]led_ctrl;
    wire [31:0]led_time_set;
    wire rx_done;

    //例化子模块
    uart_byte_rx uart_byte_rx_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .uart_rx(uart_rx),
        .baud_set(3'd4),
        .Data(rx_data),
        .Rx_Done(rx_done)
    );

    uart_cmd uart_cmd_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .led_ctrl(led_ctrl),
        .led_time_set(led_time_set)
    );

    counter_led_4 counter_led_4_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Ctrl(led_ctrl), //LED状态控制
        .Time(led_time_set), //LED状态变化的时间
        .led(led)
    );

endmodule