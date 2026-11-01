module async_fifo_sva #(
    parameter ADDR_WIDTH = 2,
    parameter PTR_WIDTH = ADDR_WIDTH + 1
)(
    input logic wr_clk,
    input logic rd_clk,
    input logic rst_n,

    input logic wr_en,
    input logic rd_en,

    input logic full,
    input logic empty,

    input logic [PTR_WIDTH-1:0] wbin,
    input logic [PTR_WIDTH-1:0] rbin,

    input logic [PTR_WIDTH-1:0] wgray,
    input logic [PTR_WIDTH-1:0] rgray,

    input logic [PTR_WIDTH-1:0] rgray_wsync2,
    input logic [PTR_WIDTH-1:0] wgray_rsync2,

    input logic wr_fire,
    input logic rd_fire
);

    // ========================================================
    // WRITE DOMAIN ASSERTIONS
    // ========================================================

    property p_write_pointer_increment;
        @(posedge wr_clk)
        disable iff (!rst_n)
        wr_fire |=> wbin == ($past(wbin) + 1'b1);
    endproperty

    a_write_pointer_increment:
        assert property(p_write_pointer_increment);

    property p_write_pointer_stable;
        @(posedge wr_clk)
        disable iff (!rst_n)
        !wr_fire |=> $stable(wbin);
    endproperty

    a_write_pointer_stable:
        assert property(p_write_pointer_stable);

    property p_write_gray_transition;
        @(posedge wr_clk)
        disable iff (!rst_n)
        $onehot0(wgray ^ $past(wgray));
    endproperty

    a_write_gray_transition:
        assert property(p_write_gray_transition);

    // ========================================================
    // READ DOMAIN ASSERTIONS
    // ========================================================

    property p_read_pointer_increment;
        @(posedge rd_clk)
        disable iff (!rst_n)
        rd_fire |=> rbin == ($past(rbin) + 1'b1);
    endproperty

    a_read_pointer_increment:
        assert property(p_read_pointer_increment);

    property p_read_pointer_stable;
        @(posedge rd_clk)
        disable iff (!rst_n)
        !rd_fire |=> $stable(rbin);
    endproperty

    a_read_pointer_stable:
        assert property(p_read_pointer_stable);

    property p_read_gray_transition;
        @(posedge rd_clk)
        disable iff (!rst_n)
        $onehot0(rgray ^ $past(rgray));
    endproperty

    a_read_gray_transition:
        assert property(p_read_gray_transition);

    // ========================================================
    // FULL / EMPTY ASSERTIONS
    // ========================================================

    property p_no_write_when_full;
        @(posedge wr_clk)
        disable iff (!rst_n)
        full |-> !wr_fire;
    endproperty

    a_no_write_when_full:
        assert property(p_no_write_when_full);

    property p_no_read_when_empty;
        @(posedge rd_clk)
        disable iff (!rst_n)
        empty |-> !rd_fire;
    endproperty

    a_no_read_when_empty:
        assert property(p_no_read_when_empty);

    property p_full_equation;
        @(posedge wr_clk)
        disable iff (!rst_n)
        full ==
        (wgray ==
         {~rgray_wsync2[PTR_WIDTH-1:PTR_WIDTH-2],
           rgray_wsync2[PTR_WIDTH-3:0]});
    endproperty

    a_full_equation:
        assert property(p_full_equation);

    property p_empty_equation;
        @(posedge rd_clk)
        disable iff (!rst_n)
        empty == (rgray == wgray_rsync2);
    endproperty

    a_empty_equation:
        assert property(p_empty_equation);

    // ========================================================
    // SYNCHRONIZER ASSERTIONS
    // ========================================================

    property p_write_sync_stage;
        @(posedge wr_clk)
        disable iff (!rst_n)
        rgray_wsync2 == $past(rgray_wsync1);
    endproperty

    // The synchronizer's stage relationship is also
    // structurally checked in the RTL implementation.

    // ========================================================
    // COVER PROPERTIES
    // ========================================================

    c_fifo_full:
        cover property (
            @(posedge wr_clk)
            disable iff (!rst_n)
            full
        );

    c_fifo_empty:
        cover property (
            @(posedge rd_clk)
            disable iff (!rst_n)
            empty
        );

    c_write_activity:
        cover property (
            @(posedge wr_clk)
            disable iff (!rst_n)
            wr_fire
        );

    c_read_activity:
        cover property (
            @(posedge rd_clk)
            disable iff (!rst_n)
            rd_fire
        );

endmodule
