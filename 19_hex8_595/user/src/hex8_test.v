module hex8_test(
    Clk,
    Reset_n,
    Disp_data,
    DS,
    SHCP,
    STCP
);
    input Clk;
    input Reset_n;
    input [31:0]Disp_data;
    output DS;
    output SHCP;
    output STCP;

    wire [7:0]Sel,Seg;
    wire [15:0]Data_in;
    assign Data_in = {Seg, Sel};
    hex8 he8_inst1(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Disp_data(Disp_data),
        .Sel(Sel),
        .Seg(Seg)
    );
    hex8_595 hex8_595_inst1(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .Data_in(Data_in),
        .EN(1'b1),
        .SHCP(SHCP), //移位时钟
        .STCP(STCP), //存储时钟
        .DS(DS)
    );

endmodule