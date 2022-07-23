`timescale 1ns / 1ns
module led_tb;
reg s_Clk;
reg s_Reset_n;
wire [1:0]s_led;
led_test led_test(
    .xClk(s_Clk), 
    .yReset_n(s_Reset_n),
    .led(s_led)
);
initial s_Clk = 1;
always #10 s_Clk = ~s_Clk;
initial begin
    s_Reset_n = 0;
    #201;
    s_Reset_n = 1;
    #200000000;
    end 

endmodule