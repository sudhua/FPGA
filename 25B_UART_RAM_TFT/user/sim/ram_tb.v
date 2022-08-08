module ram_tb;
    reg clka;
    reg ena;
    reg [0 : 0] wea;
    reg [15 : 0] addra;
    reg [15 : 0] dina;
    reg clkb;
    reg enb;
    reg [15 : 0] addrb;
    wire [15 : 0] doutb;
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

    initial clka = 1;
    always #10 clka = ~clka;

    initial clkb = 1;
    always #10 clkb = ~clkb;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial begin
        ena = 0;
        wea = 0;
        addra = 0;
        dina = 0;
        enb = 0;
        addrb = 0;
        #201;
        repeat(65536) begin
            ena = 1;
            wea = 1;
            #20; 
            addra = addra + 1'd1;
            dina = dina + 1'd1;
        end
        ena = 0;
        wea = 0;
        #20_000;

        repeat(65536) begin
            enb = 1;
            #20; 
            addrb = addrb + 1'd1;
        end
        #200;
        enb = 0;
        #20_000;
        $finish();
    end

endmodule
