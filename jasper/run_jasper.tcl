
puts "=========================================="
puts " Cadence JasperGold Async FIFO FPV"
puts "=========================================="

clear -all

# Analyze RTL and formal sources
analyze -sv \
    rtl/async_fifo.sv \
    formal/async_fifo_sva.sv \
    formal/async_fifo_bind.sv \
    formal/async_fifo_formal_top.sv

# Elaborate formal top
elaborate -top async_fifo_formal_top

# Configure independent clock domains
clock wr_clk
clock rd_clk

# Common asynchronous active-low reset
reset -expression {!rst_n}

# Run formal property verification
prove -all

puts "=========================================="
puts " JasperGold FPV run completed"
puts "=========================================="

