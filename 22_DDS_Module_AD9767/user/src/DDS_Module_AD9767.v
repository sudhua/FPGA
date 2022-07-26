module DDS_Module_AD9767(
	Clk,
	Reset_n,
	Key,
	Module_Sel1,
	Module_Sel2,
	Data1,
	Data2,
	CLK1,
	CLK2,
	WRT1,
	WRT2
);
	input Clk;
	input Reset_n;
	input [3:0]Key;
	input [1:0]Module_Sel1;
	input [1:0]Module_Sel2;
	output [13:0]Data1;
	output [13:0]Data2;
	output  CLK1;
	output  CLK2;
	output  WRT1;
	output  WRT2;

	assign CLK1 = Clk;
	assign CLK2 = Clk;
	assign WRT1 = Clk;
	assign WRT2 = Clk;
	
	reg [31:0]Fword1;
	reg [11:0]Pword1;
	DSS_Module DSS_Module_inst1(
		.Clk(Clk),
		.Reset_n(Reset_n),
		.Module_Sel(Module_Sel1),
		.Fword(Fword1),
		.Pword(Pword1),
		.Data(Data1)
	);
	reg [31:0]Fword2;
	reg [11:0]Pword2;
	DSS_Module DSS_Module_inst2(
		.Clk(Clk),
		.Reset_n(Reset_n),
		.Module_Sel(Module_Sel2),
		.Fword(Fword2),
		.Pword(Pword2),
		.Data(Data2)
	);

	wire [3:0]Key_flag;
    key_filter key_filter_inst1(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .key(Key[0]),
        .key_flag(Key_flag[0])
    );
    key_filter key_filter_inst2(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .key(Key[1]),
        .key_flag(Key_flag[1])
    );
    key_filter key_filter_inst3(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .key(Key[2]),
        .key_flag(Key_flag[2])
    );
    key_filter key_filter_inst4(
        .Clk(Clk),
        .Reset_n(Reset_n),
        .key(Key[3]),
        .key_flag(Key_flag[3])
    );

	// key[0] ---> Fword1
	// key[1] ---> Pword1
	// key[2] ---> Fword2
	// key[3] ---> Pword2
	reg [3:0]count0;
	always@(posedge Clk or negedge Reset_n)
	if(!Reset_n)
		count0 <= 0;
	else if (!Key[0] && Key_flag[0])
		count0 <= count0 + 1;
	//2**32超出了Fword1的范围，溢出，会导致结果错误，所以都计算出来了。
	always@(posedge Clk)
		case(count0)
			0: Fword1 <= 8589;//100 * 2**32 / 50_000_000; //100hz
			1: Fword1 <= 85899;//1_000 * 2**32 / 50_000_000; //1Khz
			2: Fword1 <= 171798;//2_000 * 2**32 / 50_000_000; //2Khz
			3: Fword1 <= 858993;//10_000 * 2**32 / 50_000_000; //10Khz
			4: Fword1 <= 1717987;//20_000 * 2**32 / 50_000_000; //20Khz
			5: Fword1 <= 8589935;//100_000 * 2**32 / 50_000_000; //100Khz
			6: Fword1 <= 85899346;//1_000_000 * 2**32 / 50_000_000; //1MKhz
			7: Fword1 <= 429496730;//5_000_000 * 2**32 / 50_000_000; //5Mhz
		endcase

	reg [3:0]count1;
	always@(posedge Clk or negedge Reset_n)
	if(!Reset_n)
		count1 <= 0;
	else if (!Key[1] && Key_flag[1])
		count1 <= count1 + 1;
	
	always@(posedge Clk)
		case(count1)
			0: Pword1 <= 0;
			1: Pword1 <= 512; 
			2: Pword1 <= 1024;
			3: Pword1 <= 1536;
			4: Pword1 <= 2048;
			5: Pword1 <= 2560;
			6: Pword1 <= 3072;
			7: Pword1 <= 3584;
		endcase

	reg [3:0]count2;
	always@(posedge Clk or negedge Reset_n)
	if(!Reset_n)
		count2 <= 0;
	else if (!Key[2] && Key_flag[2])
		count2 <= count2 + 1;
	
	always@(posedge Clk)
		case(count2)
			0: Fword2 <= 8589;//100 * 2**32 / 50_000_000; //100hz
			1: Fword2 <= 85899;//1_000 * 2**32 / 50_000_000; //1Khz
			2: Fword2 <= 171798;//2_000 * 2**32 / 50_000_000; //2Khz
			3: Fword2 <= 858993;//10_000 * 2**32 / 50_000_000; //10Khz
			4: Fword2 <= 1717987;//20_000 * 2**32 / 50_000_000; //20Khz
			5: Fword2 <= 8589935;//100_000 * 2**32 / 50_000_000; //100Khz
			6: Fword2 <= 85899346;//1_000_000 * 2**32 / 50_000_000; //1MKhz
			7: Fword2 <= 429496730;//5_000_000 * 2**32 / 50_000_000; //5Mhz
		endcase

	reg [3:0]count3;
	always@(posedge Clk or negedge Reset_n)
	if(!Reset_n)
		count3 <= 0;
	else if (!Key[3] && Key_flag[3])
		count3 <= count3 + 1;
	
	always@(posedge Clk)
		case(count3)
			0: Pword2 <= 0;
			1: Pword2 <= 512; 
			2: Pword2 <= 1024;
			3: Pword2 <= 1536;
			4: Pword2 <= 2048;
			5: Pword2 <= 2560;
			6: Pword2 <= 3072;
			7: Pword2 <= 3584;
		endcase

endmodule