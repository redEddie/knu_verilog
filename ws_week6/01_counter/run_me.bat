del *.vcd *.vvp

iverilog -o sim.vvp counter.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
