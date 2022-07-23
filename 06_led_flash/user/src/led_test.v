module led_test(
    xClk, 
    yReset_n,
    led
);
input xClk;
input yReset_n;
output [1:0]led;

led_flash_8 led_flash_inst0(
    .Clk(xClk), 
    .Reset_n(yReset_n),
    .led(led[0])
);
defparam led_flash_inst0.MCNT = 2499;//50us

led_flash_8 led_flash_inst1(
    .Clk(xClk), 
    .Reset_n(yReset_n),
    .led(led[1])
);
defparam led_flash_inst1.MCNT = 24999;//500us

endmodule