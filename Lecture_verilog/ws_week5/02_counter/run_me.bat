del *.vcd *.vvp

iverilog -o sim.vvp ALU.v tb.v

vvp sim.vvp

gtkwave ./sim.vcd

pause
