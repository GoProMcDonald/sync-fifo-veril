`timescale 1ns/1ps

module sync_fifo_tb;
    parameter ADDR_WIDTH = 4;
    parameter DATA_WIDTH = 8;
    logic clk, rst, wr_en, rd_en;
    logic [DATA_WIDTH-1:0] din;
    logic [DATA_WIDTH-1:0] dout;
    logic full;
  	logic empty;

    sync_fifo #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
      .empty(empty)
    );

    // Clock generation、
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    initial begin
        $dumpfile("sync_fifo_wave.vcd");
        $dumpvars(0, sync_fifo_tb);
		$dumpvars(0, uut.mem); 
        rst = 1;
        wr_en = 0; 
        rd_en = 0;
        din = 0;
        #10 rst = 0; // Release reset after 10ns

        repeat (8) begin
    		wr_en = 1;
    		din = $random;
    		@(posedge clk);
		end
		wr_en = 0;
		
		#20;  // 写完后等待 FIFO 稳定

// 读取阶段
		repeat (8) begin
    		rd_en = 1;
    		@(posedge clk);
		end
		rd_en = 0;

        #200;
        $finish; // End simulation
    end
    
endmodule

