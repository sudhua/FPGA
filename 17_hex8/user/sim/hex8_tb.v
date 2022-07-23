`timescale 1ns /1ns
module hex8_tb();
    reg Clk;
    reg Reset_n;
    reg [31:0]Disp_data;
    wire [7:0]Sel;
    wire [7:0]Seg;
    hex8 hex8_inst0(
        Clk,
        Reset_n,
        Disp_data,
        Sel,
        Seg
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
        #10_000_000;
        $finish(1);
    end

endmodule