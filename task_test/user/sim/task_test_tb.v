`timescale 1ns / 1ns
module task_test_tb;
    reg Clk;
    reg Reset_n;
    reg [3:0]a;
    task_test task_test_inst0(
        Clk,
        Reset_n,
        a
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
        Reset_n = 0;
        a <= 1;
        #201;
        Reset_n = 1;
        #200;
        task_one(a[0]);
        #800;
        task_one(a[3]);
        #2000;
        $finish();
    end
    task task_one;
        input   b;
        begin
        b <= 0;
        //a[0] <= 1;
        #200;
        b <= 1;
        #200;
        b <= 0;
        //a[0] <= 0;
        #200;

        end
    
    endtask
endmodule