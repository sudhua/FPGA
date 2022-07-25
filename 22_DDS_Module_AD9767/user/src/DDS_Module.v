module DSS_Module(
    Clk,
    Reset_n,
    Module_Sel,
    Fword,
    Pword,
    Data
);
    input Clk;
    input Reset_n;
    input [1:0]Module_Sel;
    input [31:0]Fword; //频率控制字
    input [11:0]Pword; //相位控制字
    output [13:0]Data; //ROM数据表输出
    reg [31:0]Fword_ACC; //相位累加器
    reg [11:0]Rom_addr; //ROM地址
    //频率控制字同步寄存器
    reg [31:0]Fword_r;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Fword_r <= 0;
    else 
        Fword_r <= Fword;

    //相位累加器
    //reg [31:0]Fword_ACC;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Fword_ACC <= 0;
    else 
        Fword_ACC <= Fword_ACC + Fword_r;

    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Fword_ACC <= 0;
    else 
        Fword_ACC <= Fword_ACC + Fword_r;
    
    //相位控制字同步寄存器
    reg [11:0]Pword_r;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Pword_r <= 0;
    else 
        Pword_r <= Pword;
    
    //波形数据表地址产生
    //reg [11:0]Rom_addr;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        Rom_addr <= 0;
    else 
        Rom_addr <= Fword_ACC[31:20] + Pword_r;

    //Rom波形数据
    ROM_0 dds_rom_inst0(
        .clka(Clk),
        .addra(Rom_addr),
        .douta(Data)
    );

    ROM_0 dds_rom_inst1(
        .clka(Clk),
        .addra(Rom_addr),
        .douta(Data)
    );

    ROM_0 dds_rom_inst2(
        .clka(Clk),
        .addra(Rom_addr),
        .douta(Data)
    );



endmodule