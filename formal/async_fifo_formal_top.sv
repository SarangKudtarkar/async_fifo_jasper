
module async_fifo_formal_top #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2
)(
    input logic wr_clk,
    input logic rd_clk,
    input logic rst_n,

    input logic wr_en,
    input logic rd_en,

    input logic [DATA_WIDTH-1:0] wr_data,

    output logic full,
    output logic empty,
    output logic [DATA_WIDTH-1:0] rd_data
);

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst_n(rst_n),

        .wr_en(wr_en),
        .wr_data(wr_data),
        .full(full),

        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty)
    );

endmodule

