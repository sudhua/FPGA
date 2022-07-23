`timescale 1ns / 1ns
module clk_tb();

    reg Clk;
    reg Reset_n;
    wire led_0;
    wire led_1;

    my_clk my_clk_inst0(
        Clk,
        Reset_n,
        led_0,
        led_1
    );

    initial begin
        $dumpfile ("wave.vcd");
        $dumpvars;
    end

    initial Clk = 1;

    always #10 Clk = ~Clk;

    initial begin
        Reset_n = 0;
        #201;
        Reset_n = 1;
        #20_000_000;
        $finish();
    end

endmodule
