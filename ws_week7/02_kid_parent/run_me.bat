del *.vcd *.vvp

iverilog -o sim.vvp kid.v parent.v config.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
