del *.vcd *.vvp

iverilog -o sim.vvp config.v LFSR.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
