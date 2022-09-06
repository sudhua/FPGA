`timescale 1ns / 1ns
module fifo_tb;
    reg Clk;    
    reg Reset_n;
    reg [15:0]din;
    reg wr_en;
    reg rd_en;
    wire [7:0]dout;
    wire full;
    wire almost_full;
    wire wr_ack; 
    wire overflow;
    wire empty;
    wire almost_empty;
    wire valid;
    wire underflow;
    wire [9:0]rd_data_count;
    wire [8:0]wr_data_count;
    wire prog_full;
    wire prog_empty;

    fifo fifo (
        .clk(Clk),                      // input wire clk
        .srst(Reset_n),                 // input wire srst
        .din(din),                      // input wire [15 : 0] din
        .wr_en(wr_en),                  // input wire wr_en
        .rd_en(rd_en),                  // input wire rd_en
        .dout(dout),                    // output wire [7 : 0] dout
        .full(full),                    // output wire full
        .almost_full(almost_full),      // output wire almost_full
        .wr_ack(wr_ack),                // output wire wr_ack
        .overflow(overflow),            // output wire overflow
        .empty(empty),                  // output wire empty
        .almost_empty(almost_empty),    // output wire almost_empty
        .valid(valid),                  // output wire valid
        .underflow(underflow),          // output wire underflow
        .rd_data_count(rd_data_count),  // output wire [9 : 0] rd_data_count
        .wr_data_count(wr_data_count),  // output wire [8 : 0] wr_data_count
        .prog_full(prog_full),          // output wire prog_full
        .prog_empty(prog_empty)        // output wire prog_empty
    );
    initial Clk = 1;
    always #10 Clk = ~Clk;

    initial begin
        Reset_n = 1;
        din = 0;
        wr_en = 0;
        rd_en = 0;
        #205;
        Reset_n = 0;
        #2000;
        wr_en = 1;
        #2;
        repeat(300)begin
            din = din + 1'd1;
            #20;
        end
        #2000;
        wr_en = 0;
        #2000;
        rd_en = 1;
        #20000;
        $finish();
    end

endmodule