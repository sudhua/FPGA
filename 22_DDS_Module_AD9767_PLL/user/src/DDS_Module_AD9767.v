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
	input [3:0]Key; //按键输入调整频率控制字或相位控制字
	input [1:0]Module_Sel1; //拨码开关波形选择
	input [1:0]Module_Sel2; //拨码开关波形选择
	output [13:0]Data1; //DDS输出通道1
	output [13:0]Data2; //DDS输出通道2
	output  CLK1; //AD9767通道1时钟
	output  CLK2; //AD9767通道2时钟
	output  WRT1; //AD9767通道1写信号
	output  WRT2; //AD9767通道2写信号

	//PLL产生125M时钟，供AD9767使用
	//FPGA板子上的时钟为50M，无法产生高频率时钟
	//借助IP核产生125MHz时钟
	wire CLK_125M;
	MMCM MMCM(
		.clk_out1(CLK_125M),    
		.resetn(Reset_n), 
		.locked(),       
		.clk_in1(Clk)
	);     
	//AD9767的时钟信号和写信号最高为125MHz
	//详细直接参考AD9767数据手册
	assign CLK1 = CLK_125M;
	assign CLK2 = CLK_125M;
	assign WRT1 = CLK1;
	assign WRT2 = CLK2;

	//DDS_Module_1
	//当按下相位的按键时将DDS模块复位，目的是让相位归零按我们设置的相位运行。
	reg [31:0]Fword1;
	reg [11:0]Pword1;
	DSS_Module DSS_Module_inst1(
		.Clk(CLK_125M),
		.Reset_n(key_state[1] && key_state[3]),
		.Module_Sel(Module_Sel1),
		.Fword(Fword1),
		.Pword(Pword1),
		.Data(Data1)
	);
	//DDS_Module_1
	reg [31:0]Fword2;
	reg [11:0]Pword2;
	DSS_Module DSS_Module_inst2(
		.Clk(CLK_125M),
		.Reset_n(key_state[1] && key_state[3]),
		.Module_Sel(Module_Sel2),
		.Fword(Fword2),
		.Pword(Pword2),
		.Data(Data2)
	);

	wire [3:0]Key_flag;
	wire [3:0]key_state;
    key_filter key_filter_inst1(
        .Clk(CLK_125M),
        .Reset_n(Reset_n),
        .key(Key[0]),
        .key_flag(Key_flag[0]),
		.key_state(key_state[0])
    );
    key_filter key_filter_inst2(
        .Clk(CLK_125M),
        .Reset_n(Reset_n),
        .key(Key[1]),
        .key_flag(Key_flag[1]),
		.key_state(key_state[1])
    );
    key_filter key_filter_inst3(
        .Clk(CLK_125M),
        .Reset_n(Reset_n),
        .key(Key[2]),
        .key_flag(Key_flag[2]),
		.key_state(key_state[2])
    );
    key_filter key_filter_inst4(
        .Clk(CLK_125M),
        .Reset_n(Reset_n),
        .key(Key[3]),
        .key_flag(Key_flag[3]),
		.key_state(key_state[3])
    );

	// key[0] ---> Fword1
	// key[1] ---> Pword1
	// key[2] ---> Fword2
	// key[3] ---> Pword2
	//K0控制DDS_Module_1的频率控制字
	reg [3:0]count0;
	always@(posedge CLK_125M or negedge Reset_n)
	if(!Reset_n)
		count0 <= 0;
	else if (!key_state[0] && Key_flag[0])
		count0 <= count0 + 1;

	//2**32超出了Fword1的范围，溢出，会导致仿真结果为0，所以都计算出来了。
	//并不是vivado不支持【**】运算
	always@(posedge CLK_125M)
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
	//K1控制DDS_Module_1的相位控制字
	reg [3:0]count1;
	always@(posedge CLK_125M or negedge Reset_n)
	if(!Reset_n)
		count1 <= 0;
	else if (!key_state[1] && Key_flag[1])
		count1 <= count1 + 1;
	
	always@(posedge CLK_125M)
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
	//K2控制DDS_Module_2的频率控制字
	reg [3:0]count2;
	always@(posedge CLK_125M or negedge Reset_n)
	if(!Reset_n)
		count2 <= 0;
	else if (!key_state[2] && Key_flag[2])
		count2 <= count2 + 1;
	
	always@(posedge CLK_125M)
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
	//K3控制DDS_Module_2的相位控制字
	reg [3:0]count3;
	always@(posedge CLK_125M or negedge Reset_n)
	if(!Reset_n)
		count3 <= 0;
	else if (!key_state[3] && Key_flag[3])
		count3 <= count3 + 1;
	
	always@(posedge CLK_125M)
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