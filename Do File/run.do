vlib work
vlog -f src_files.list  +cover -covercells  -l sim.log
vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/FIFO_top/FIFO_if/*
add wave -position insertpoint sim:/FIFO_top/FIFO_DUT/*
coverage save FIFO.ucdb -onexit 
run -all