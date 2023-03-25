del *.vcd *.vvp

iverilog -o sim.vvp adder.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
