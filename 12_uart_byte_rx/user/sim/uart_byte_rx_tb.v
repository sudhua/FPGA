`timescale 1ns / 1ns
module uart_byte_rx_tb();

    reg Clk;
    reg Reset_n;
    reg uart_rx;
    wire [2:0]baud_set;
    wire [7:0]Data;
    wire Rx_Done;

    uart_byte_rx uart_byte_rx_inst0(
        Clk,
        Reset_n,
        uart_rx,
        baud_set,
        Data,
        Rx_Done
    );

    assign baud_set = 4;
    initial Clk = 1;
    always #10 Clk =~ Clk;
    initial begin
    Reset_n = 0;
    uart_rx = 1;
    //uart_rx = 0;
    #201;
    Reset_n = 1;
    #200;
    uart_byte_tx(8'h5a);
    #200000;
    uart_byte_tx(8'h43);
    #200000;
    uart_byte_tx(8'h78);
    #200000;
    $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        //$dumpvars(0,uart_tx_data_tb);
        $dumpvars;
    end


    task uart_byte_tx;
        input [7:0] tx_data; 
        begin
            uart_rx = 1;
            #200;
            uart_rx = 0;
            #8680;
            uart_rx = tx_data[0];
            #8680;
            uart_rx = tx_data[1];
            #8680;
            uart_rx = tx_data[2];
            #8680;
            uart_rx = tx_data[3];
            #8680;
            uart_rx = tx_data[4];
            #8680;
            uart_rx = tx_data[5];
            #8680;
            uart_rx = tx_data[6];
            #8680;
            uart_rx = tx_data[7];
            #8680;
            uart_rx = 1;
            #8680;
        end
    endtask //automatic
    


endmodule