`timescale 1ns / 1ns
module uart_clock_tb();
    reg Clk;
    reg Reset_n;
    reg [2:0]Baud_Set;
    reg uart_rx;
    wire DS;
    wire SHCP;
    wire STCP;
    uart_clock uart_clock_inst0(
        Clk,
        Reset_n,
        Baud_Set,
        uart_rx,
        DS,
        SHCP,
        STCP
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial Clk = 1;
    
    always #10 Clk =~ Clk;
    
    initial begin
        Reset_n = 0;
        Baud_Set = 4;
        uart_rx = 0;
        #201;
        Reset_n = 1;
        uart_byte_tx(8'hff);
        #20;
        uart_byte_tx(8'ha5);
        #20;
        uart_byte_tx(8'h12);
        #20;
        uart_byte_tx(8'h34);
        #20;
        uart_byte_tx(8'h21);
        #20;
        uart_byte_tx(8'hf0);
        #20;
        #50_000_000;
        uart_byte_tx(8'hff);
        #20;
        uart_byte_tx(8'ha5);
        #20;
        uart_byte_tx(8'h14);
        #20;
        uart_byte_tx(8'h13);
        #20;
        uart_byte_tx(8'h17);
        #20;
        uart_byte_tx(8'hf0);
        #20;
        #50_000_000;
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
    endtask
endmodule