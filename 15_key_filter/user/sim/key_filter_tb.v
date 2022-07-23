`timescale 1ns / 1ns
module key_filter_tb();

        reg Clk;
        reg Reset_n;
        reg key;
        wire key_flag;
    key_filter key_filter_inst0(
        Clk,
        Reset_n,
        key,
        key_flag
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial Clk = 1;
    always #10 Clk =~ Clk;

    initial begin
        Reset_n = 0;
        key = 1;
        #201;
        Reset_n = 1;
        // KEY_DOWN;
        // KEY_UP;
        KEY_PRESS;
        //#20_000_000;
        $finish(1);
    end

    task KEY_PRESS;
        reg [31:0]key_rand;
        begin
        key = 1;
        #2_000_000;
        repeat(5)begin
            key_rand = {$random} % (10_000_000 - 1);
            #key_rand key =~key;
        end
        #5_000_000;
        key = 0;
        #100_000_000;
        repeat(5)begin
            key_rand = {$random} % (10_000_000 - 1);
            #key_rand key =~key;
        end
        #5_000_000;
        key = 1;
        #50_000_000;
        end
    endtask
    // task automatic KEY_DOWN;
    //     reg [31:0]key_rand;
    //     begin
    //         key = 1;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 0;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 1;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 0;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 1;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 0;
    //         #40_000_000;
    //     end
    // endtask //automatic
    // task automatic KEY_UP;
    //     reg [31:0]key_rand;
    //     begin
    //         key = 0;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 1;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 0;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 1;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 0;
    //         key_rand = {$random} % (10_000_000 - 1);
    //         #key_rand;
    //         key = 1;
    //         #40_000_000;
    //     end
    // endtask //automatic
endmodule