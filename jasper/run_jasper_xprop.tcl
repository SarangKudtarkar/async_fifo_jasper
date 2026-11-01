puts "======================================"
puts " ASYNC FIFO XPROP FORMAL VERIFICATION"
puts "======================================"

clear -all

analyze -sv \
    rtl/async_fifo.sv \
    formal/async_fifo_formal_top.sv \
    formal/async_fifo_xprop_sva.sv \
    formal/async_fifo_functional_sva.sv \
    formal/async_fifo_functional_bind.sv \
    formal/async_fifo_xprop_bind.sv

elaborate -top async_fifo_formal_top

clock wr_clk
clock rd_clk

reset -expression {!rst_n}

prove -all

puts "======================================"
puts " XPROP CHECK COMPLETED"
puts "======================================"

exit
