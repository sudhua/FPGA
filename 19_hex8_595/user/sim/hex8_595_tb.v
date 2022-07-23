`timescale 1ns / 1ns

module hex8_595_tb();
    reg Clk;
    reg Reset_n;
    reg [15:0]Data_in;
    reg EN;
    wire SHCP; //移位时钟
    wire STCP;//存储时钟
    wire DS;
    hex8_595 hex8_595_inst0(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data_in(Data_in),
        .EN(EN),
        .SHCP(SHCP), //移位时钟
        .STCP(STCP), //存储时钟
        .DS(DS)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial Clk = 1;
    always #10 Clk =~ Clk;
    initial begin
        Reset_n = 0;
        Data_in = 0;
        EN = 0;
        #201;
        Reset_n = 1;
        #2000;
        EN = 1;
        Data_in = 16'h1234;
        #20_000;
        Data_in = 16'h5678;
        #20_000;
        $finish();
        

    end


endmodule