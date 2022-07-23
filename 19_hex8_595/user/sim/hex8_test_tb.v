`timescale 1ns /1ns
module hex8_test_tb();
    reg Clk;
    reg Reset_n;
    reg [31:0]Disp_data;
    wire DS;
    wire SHCP;
    wire STCP;
    hex8_test hex8_test_inst0(
        Clk,
        Reset_n,
        Disp_data,
        DS,
        SHCP,
        STCP
    );
    initial Clk = 1;
    always #10 Clk =~ Clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial begin
        Reset_n = 0;
        Disp_data = 0;
        #201;
        Reset_n = 1;
        #20_000;
        Disp_data = 32'h12345678;
        #100_000_000;
        $finish(1);
    end

endmodule