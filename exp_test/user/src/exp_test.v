module exp_test(
    Clk,
    Reset_n,
    a,
    b
);
    input Clk;
    input Reset_n;
    input [33:0]a;
    output reg [40:0]b;
    parameter Power = 2**32;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        b <= 0;
    else begin
        //b <= 2**32 + a + 4;
        b <= 100 * 2**32 / 50_000_000;
    end

endmodule