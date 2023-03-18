@REM del은 이전의 결과를 제거하는 명령어다.
del tb_test_out.vcd tb_test_out.vvp

iverilog -o tb_test_out.vvp adder.v adder_test.v adder_tb.v

vvp tb_test_out.vvp

gtkwave ./tb_test_out.vcd

pause
