module async_fifo_functional_sva #(
    parameter ADDR_WIDTH = 2,
    parameter PTR_WIDTH  = ADDR_WIDTH + 1,
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = (1 << ADDR_WIDTH)
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

    input logic [DATA_WIDTH-1:0] wr_data,
    input logic [DATA_WIDTH-1:0] rd_data
);

    // TEST 1: FORWARD PROGRESS

    ap_write_forward_progress:
        assert property (
            @(posedge wr_clk)
            disable iff (!rst_n)
            wr_fire |=> wbin == ($past(wbin) + 1'b1)
        );

    ap_read_forward_progress:
        assert property (
            @(posedge rd_clk)
            disable iff (!rst_n)
            rd_fire |=> rbin == ($past(rbin) + 1'b1)
        );


    // TEST 2: SPURIOUS OPERATION DETECTION

    ap_no_spurious_write:
        assert property (
            @(posedge wr_clk)
            disable iff (!rst_n)
            (wr_en && full) |-> !wr_fire
        );

    ap_no_spurious_read:
        assert property (
            @(posedge rd_clk)
            disable iff (!rst_n)
            (rd_en && empty) |-> !rd_fire
        );


    // TEST 3: DATA INTEGRITY
    // Independent shadow memory.

    logic [DATA_WIDTH-1:0] expected_mem [0:DEPTH-1];

    always @(posedge wr_clk) begin
        if (rst_n && wr_fire) begin
            expected_mem[wbin[ADDR_WIDTH-1:0]] <= wr_data;
        end
    end

    always @(posedge rd_clk) begin
        if (rst_n && rd_fire) begin
            assert (
                rd_data === expected_mem[rbin[ADDR_WIDTH-1:0]]
            )
            else $error("FIFO DATA INTEGRITY FAILURE");
        end
    end

endmodule
