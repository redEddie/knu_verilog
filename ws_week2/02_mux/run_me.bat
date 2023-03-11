@REM iverilog 명령어는 맨첨에 만들 파일명, 뒤에는 입력할 파일 주루룩

iverilog -o mux_tb.vvp mux.v mux_test.v mux_tb.v

vvp mux_tb.vvp

@REM gtk는 dump를 실행시키는 것, dump 는 v 파일의 파형을 저장해 놓은 것
gtkwave ./mux_dump.vcd

pause
