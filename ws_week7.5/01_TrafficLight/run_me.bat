del *.vcd *.vvp

iverilog -o sim.vvp traffic.v config.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
