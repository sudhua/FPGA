`timescale 1ns / 1ns
module uart_tx_data_tb();

    reg Clk;
    reg Reset_n;
    reg [39:0]Data40;
    reg Trans_Go;
    wire Trans_Done;
    wire uart_tx;

uart_tx_data3 uart_tx_data_tb_inst0(
    Clk,
    Reset_n,
    Data40,
    Trans_Go,
    Trans_Done,
    uart_tx
);
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
        Reset_n = 0;
        Data40 = 0;
        Trans_Go = 0;
        #201; 
        Reset_n = 1;
        Data40 = 40'h123456789a;
        Trans_Go = 1;
        #200;
        @(posedge Trans_Done);
        Trans_Go = 0;
        #20000;
        Data40 = 40'ha987654321;
        Trans_Go = 1;
        #200;
        @(posedge Trans_Done);
        Trans_Go = 0;
        #200;
        $finish;
    end
    initial begin
        $dumpfile("wave.vcd");
        //$dumpvars(0,uart_tx_data_tb);
        $dumpvars;
    end

endmodule