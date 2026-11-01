
bind async_fifo async_fifo_sva #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .PTR_WIDTH(PTR_WIDTH)
) u_async_fifo_sva (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst_n(rst_n),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .full(full),
    .empty(empty),

    .wbin(wbin),
    .rbin(rbin),

    .wgray(wgray),
    .rgray(rgray),

    .rgray_wsync2(rgray_wsync2),
    .wgray_rsync2(wgray_rsync2),

    .wr_fire(wr_fire),
    .rd_fire(rd_fire)
);

