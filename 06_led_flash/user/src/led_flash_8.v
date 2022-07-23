module led_flash_8(
Clk, 
Reset_n,
led
);
input Clk;
input Reset_n;
output reg led;
reg [24:0]counter;
parameter MCNT = 24999999;
always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
    counter <= 0;
    else if(counter == MCNT)
    counter <= 0;
    else
    counter <= counter + 1'd1;
    end
always@(posedge Clk or negedge Reset_n)begin
    if(!Reset_n)
    led <= 0;
    else if(counter == MCNT)
    led <= !led;
    end
endmodule