bind async_fifo async_fifo_functional_sva #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .PTR_WIDTH(PTR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) u_async_fifo_functional_sva (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst_n(rst_n),

    .wr_en(wr_en),
    .rd_en(rd_en),
    .wr_fire(wr_fire),
    .rd_fire(rd_fire),

    .full(full),
    .empty(empty),

    .wbin(wbin),
    .rbin(rbin),

    .wr_data(wr_data),
    .rd_data(rd_data)
);
