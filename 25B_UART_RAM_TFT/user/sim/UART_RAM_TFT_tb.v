`timescale 1ns / 1ns
module UART_RAM_TFT_tb;

    reg Clk;
    reg Reset_n;
    reg uart_rx;
    wire VGA_HS;
    wire VGA_VS;
    wire VGA_BLK;
    wire [15:0]VGA_RGB;
    wire TFT_BL;

    UART_RAM_TFT UART_RAM_TFT_inst0(
        Clk,
        Reset_n,
        uart_rx,
        VGA_HS,
        VGA_VS,
        VGA_BLK,
        VGA_RGB,
        TFT_BL 
    );
    assign TFT_BL = 1;
    initial Clk = 1;
    always #10 Clk = ~Clk;
    initial begin
        Reset_n = 0;
        uart_rx = 1;
        #201;
        Reset_n = 1;
        #2000;
        uart_byte_tx(8'h5a);
        uart_byte_tx(8'h43);
        uart_byte_tx(8'h78);
        uart_byte_tx(8'h9a);
        uart_byte_tx(8'hbc);
        uart_byte_tx(8'hde);
        #2_000_000;
        $finish();
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