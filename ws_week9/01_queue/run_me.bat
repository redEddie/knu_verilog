del *.vcd *.vvp

iverilog -o sim.vvp config.v queue.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
