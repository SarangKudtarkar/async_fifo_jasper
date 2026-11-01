module async_fifo_xprop_sva #(
    parameter ADDR_WIDTH = 2,
    parameter PTR_WIDTH  = ADDR_WIDTH + 1,
    parameter DATA_WIDTH = 8
)(
    input logic wr_clk,
    input logic rd_clk,
    input logic rst_n,
    input logic wr_en,
    input logic rd_en,
    input logic wr_fire,
    input logic rd_fire,
    input logic full,
    input logic empty,
    input logic [PTR_WIDTH-1:0] wbin,
    input logic [PTR_WIDTH-1:0] rbin,
    input logic [PTR_WIDTH-1:0] wgray,
    input logic [PTR_WIDTH-1:0] rgray,
    input logic [PTR_WIDTH-1:0] rgray_wsync1,
    input logic [PTR_WIDTH-1:0] rgray_wsync2,
    input logic [PTR_WIDTH-1:0] wgray_rsync1,
    input logic [PTR_WIDTH-1:0] wgray_rsync2,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic [DATA_WIDTH-1:0] rd_data
);

    ap_wbin_known:
        assert property (@(posedge wr_clk)
            disable iff (!rst_n)
            !$isunknown(wbin));

    ap_wgray_known:
        assert property (@(posedge wr_clk)
            disable iff (!rst_n)
            !$isunknown(wgray));

    ap_full_known:
        assert property (@(posedge wr_clk)
            disable iff (!rst_n)
            !$isunknown(full));

    ap_write_control_known:
        assert property (@(posedge wr_clk)
            disable iff (!rst_n)
            !$isunknown({wr_en, wr_fire}));

    ap_read_sync_known:
        assert property (@(posedge wr_clk)
            disable iff (!rst_n)
            !$isunknown({rgray_wsync1, rgray_wsync2}));

    ap_rbin_known:
        assert property (@(posedge rd_clk)
            disable iff (!rst_n)
            !$isunknown(rbin));

    ap_rgray_known:
        assert property (@(posedge rd_clk)
            disable iff (!rst_n)
            !$isunknown(rgray));

    ap_empty_known:
        assert property (@(posedge rd_clk)
            disable iff (!rst_n)
            !$isunknown(empty));

    ap_read_control_known:
        assert property (@(posedge rd_clk)
            disable iff (!rst_n)
            !$isunknown({rd_en, rd_fire}));

    ap_write_sync_known:
        assert property (@(posedge rd_clk)
            disable iff (!rst_n)
            !$isunknown({wgray_rsync1, wgray_rsync2}));

    ap_read_data_known:
        assert property (@(posedge rd_clk)
            disable iff (!rst_n)
            rd_fire |-> !$isunknown(rd_data));

    cp_write:
        cover property (@(posedge wr_clk) rst_n && wr_fire);

    cp_read:
        cover property (@(posedge rd_clk) rst_n && rd_fire);

    cp_full:
        cover property (@(posedge wr_clk) rst_n && full);

    cp_empty:
        cover property (@(posedge rd_clk) rst_n && empty);

endmodule
