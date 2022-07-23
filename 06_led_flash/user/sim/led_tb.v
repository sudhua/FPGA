`timescale 1ns / 1ns 
module led_tb();

    reg Clk;
    reg Reset_n;
    wire led;
    led_flash_8 led_flash_8_isnt0(
        Clk, 
        Reset_n,
        led
    );
    defparam led_flash_8_isnt0.MCNT = 2499;//50us
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
        Reset_n = 0;
        #201;
        Reset_n = 1;
        #100_000;
        $finish();
    end
endmodule