`timescale 1ns / 1ns
module exp_test_tb();
    reg Clk;
    reg Reset_n;
    reg [31:0]a;
    wire [40:0]b;
     exp_test exp_test_inst0(
        Clk,
        Reset_n,
        a,
        b
    );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
    Reset_n = 0;
    a = 1;
    #201;
    Reset_n = 1;
    #2000;
    a = 5;
    #200;
    $finish();
    end
endmodule