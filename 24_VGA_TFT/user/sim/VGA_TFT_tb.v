`timescale 1ns / 1ns
module VGA_TFT_tb;
    reg Clk;
    reg Reset_n;
    wire VGA_HS;
    wire VGA_VS;
    wire VGA_BLK;
    wire [15:0]VGA_RGB;
    wire TFT_BL;//背光控制信号

    VGA_TFT VGA_TFT_inst0(
        Clk,
        Reset_n,
        VGA_HS,
        VGA_VS,
        VGA_BLK,
        VGA_RGB,
        TFT_BL //背光控制信号
    );
    assign TFT_BL = 1;
    initial Clk = 1;
    always #10 Clk = ~Clk;

    initial begin
        Reset_n = 0;
        #201;
        Reset_n = 1;
        #200_000;
        $finish();
    end

endmodule
