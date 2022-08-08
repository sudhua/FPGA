module UART_RAM_TFT(

);

ram ram (
        .clka(clka),    // input wire clka
        .ena(ena),      // input wire ena
        .wea(wea),      // input wire [0 : 0] wea
        .addra(addra),  // input wire [15 : 0] addra
        .dina(dina),    // input wire [15 : 0] dina
        .clkb(clkb),    // input wire clkb
        .enb(enb),      // input wire enb
        .addrb(addrb),  // input wire [15 : 0] addrb
        .doutb(doutb)  // output wire [15 : 0] doutb
    );
endmodule