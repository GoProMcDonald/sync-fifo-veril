module sync_fifo#(
    parameter ADDR_WIDTH=4,
    parameter DATA_WIDTH=8
)(
    input logic clk,
    input logic rst,
    input logic wr_en,
    input logic rd_en,
    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);

localparam DEPTH= 1 << ADDR_WIDTH; // 这句在干啥？太扯了，1<<ADDR_WIDTH> 是 2 的 ADDR_WIDTH 次方，表示 FIFO 
logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
logic [ADDR_WIDTH:0] wr_ptr, rd_ptr;//这里为什么不减一？ 为了实现 full 检测所需的 “多一位”写法！


// WRITE
always_ff@(posedge clk or posedge rst) begin
    if (rst) begin
       wr_ptr<=0;
    end else if (wr_en && !full) begin
        mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;
        wr_ptr <= wr_ptr + 1;
    end
end

// WRITE
always_ff@(posedge clk or posedge rst) begin
    if (rst) begin
        rd_ptr <= 0;
    end else if (rd_en && !empty) begin
        dout <= mem[rd_ptr[ADDR_WIDTH-1:0]];
        rd_ptr <= rd_ptr + 1;
    end
end

// FULL and EMPTY
assign full = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);
assign empty = (wr_ptr == rd_ptr);
endmodule