`timescale 1ns / 1ns
module DDS_Module_AD9767_tb();
    reg Clk;
    reg Reset_n;
    reg [3:0]Key;
    reg [1:0]Module_Sel1;
    reg [1:0]Module_Sel2;
    wire [13:0]Data1;
    wire [13:0]Data2;
    wire CLK1;
    wire CLK2;
    wire WRT1;
    wire WRT2;

    parameter Timer1 = 10_000;
    DDS_Module_AD9767 DDS_Module_AD9767_inst0(
            Clk,
            Reset_n,
            Key,
            Module_Sel1,
            Module_Sel2,
            Data1,
            Data2,
            CLK1,
            CLK2,
            WRT1,
            WRT2
        );
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
        Reset_n = 0;
        Module_Sel1 = 0;
        Module_Sel2 = 0;
        Key = 0;
        #201;
        Reset_n = 1;
        #2000;
        Module_Sel1 = 1;
        Module_Sel2 = 2;
        key1_press(4);
        key2_press(5);
        key3_press(6);
        key4_press(7);
        #2_000_000;
        $finish();
    end 
    task key1_press;
        input [3:0] cnt;
        begin
            repeat(cnt)
            begin
                Key[0] = 1;
                #5_000;
                Key[0] = 0;
                #30_000;
                Key[0] = 1;
                #10_000;
            end
        end
    endtask

    task key2_press;
        input [3:0] cnt2;
        begin
            repeat(cnt2)
            begin
                Key[1] = 1;
                #5_000;
                Key[1] = 0;
                #30_000;
                Key[1] = 1;
                #10_000;
            end
        end
    endtask

    task key3_press;
        input [3:0] cnt3;
        begin
            repeat(cnt3)
            begin
                Key[2] = 1;
                #5_000;
                Key[2] = 0;
                #30_000;
                Key[2] = 1;
                #10_000;
            end
        end
    endtask

    task key4_press;
        input [3:0] cnt4;
        begin
            repeat(cnt4)
            begin
                Key[3] = 1;
                #5_000;
                Key[3] = 0;
                #30_000;
                Key[3] = 1;
                #10_000;
            end
        end
    endtask
endmodule