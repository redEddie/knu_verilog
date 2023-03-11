@REM 테스트를 어느정도 자동화해주는 파일
@REM  윈도우라서 .bat이다. (그럼 맥은?)

@REM icarus부터 , inv와 inv_tb로 .vpp파일 만드는거다
iverilog -o inv_tb.vvp inv.v inv_tb.v 
vvp inv_tb.vvp
gtkwave ./inv_tb.vcd @REM gtk실행
pause @REM 일시정지는 파형이 꺼지지마라고