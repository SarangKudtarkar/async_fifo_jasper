bind async_fifo async_fifo_xprop_sva #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .PTR_WIDTH(PTR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
) u_async_fifo_xprop_sva (
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
    .wgray(wgray),
    .rgray(rgray),
    .rgray_wsync1(rgray_wsync1),
    .rgray_wsync2(rgray_wsync2),
    .wgray_rsync1(wgray_rsync1),
    .wgray_rsync2(wgray_rsync2),
    .wr_data(wr_data),
    .rd_data(rd_data)
);
