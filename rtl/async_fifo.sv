module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 2
)(
    input  logic                  wr_clk,
    input  logic                  rd_clk,
    input  logic                  rst_n,

    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic                  full,

    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  empty
);

    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam DEPTH     = 1 << ADDR_WIDTH;

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    logic [PTR_WIDTH-1:0] wbin, wgray;
    logic [PTR_WIDTH-1:0] rbin, rgray;

    logic [PTR_WIDTH-1:0] wbin_next, wgray_next;
    logic [PTR_WIDTH-1:0] rbin_next, rgray_next;

    logic [PTR_WIDTH-1:0] rgray_wsync1;
    logic [PTR_WIDTH-1:0] rgray_wsync2;

    logic [PTR_WIDTH-1:0] wgray_rsync1;
    logic [PTR_WIDTH-1:0] wgray_rsync2;

    logic wr_fire;
    logic rd_fire;

    assign wr_fire = wr_en && !full;
    assign rd_fire = rd_en && !empty;

    // Binary to Gray conversion
    function automatic logic [PTR_WIDTH-1:0]
        bin2gray(input logic [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Next write pointer
    always_comb begin
        wbin_next  = wbin + wr_fire;
        wgray_next = bin2gray(wbin_next);
    end

    // Next read pointer
    always_comb begin
        rbin_next  = rbin + rd_fire;
        rgray_next = bin2gray(rbin_next);
    end

    // Write pointer
    always_ff @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wbin  <= '0;
            wgray <= '0;
        end
        else begin
            wbin  <= wbin_next;
            wgray <= wgray_next;
        end
    end

    // Read pointer
    always_ff @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rbin  <= '0;
            rgray <= '0;
        end
        else begin
            rbin  <= rbin_next;
            rgray <= rgray_next;
        end
    end

    // Read pointer synchronization into write domain
    always_ff @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rgray_wsync1 <= '0;
            rgray_wsync2 <= '0;
        end
        else begin
            rgray_wsync1 <= rgray;
            rgray_wsync2 <= rgray_wsync1;
        end
    end

    // Write pointer synchronization into read domain
    always_ff @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wgray_rsync1 <= '0;
            wgray_rsync2 <= '0;
        end
        else begin
            wgray_rsync1 <= wgray;
            wgray_rsync2 <= wgray_rsync1;
        end
    end

    // Write memory
    always_ff @(posedge wr_clk) begin
        if (wr_fire)
            mem[wbin[ADDR_WIDTH-1:0]] <= wr_data;
    end

    // Asynchronous read
    assign rd_data = mem[rbin[ADDR_WIDTH-1:0]];

    // Full detection
    // Invert the two MSBs of synchronized read Gray pointer
    assign full =
        (wgray ==
         {~rgray_wsync2[PTR_WIDTH-1:PTR_WIDTH-2],
           rgray_wsync2[PTR_WIDTH-3:0]});

    // Empty detection
    assign empty = (rgray == wgray_rsync2);

endmodule
