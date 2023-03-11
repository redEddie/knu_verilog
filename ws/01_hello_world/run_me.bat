del tb_test_out.vcd tb_test_out.vvp
iverilog -o tb_test_out.vvp or_gate.v or_test.v tb_testbench.v
vvp tb_test_out.vvp
gtkwave ./tb_test_out.vcd
pause
