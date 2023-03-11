// testbench 코드
//timescale 할 때 작은 따옴표가 아니라 물결밑에있는거다. = `
`timescale 1ns/1ps //1ns 를 기준으로 테스트할거다

module inv_tb(); //inv와 달리 시나리오를 넣을게 없다.
reg a; //input 으로 보면된다.
wire b; //output으로 보면된다.

inv u1(a,b); //inv 모듈과 이어준다. inv를 이용하는 함수?의 이름

initial begin // 이걸로 어떻게 테스트할지 적어준다. 시간기준은 위에서 설정하였음.
    a = 0;
    #10 a = 1; // #이 시간을 뜻하는데, 시간단위는 생략가능하다.
    #20 $finish; // 여기서 멈추겠다.
end

// gtk를 이용하기 위해 코드를 추출해야한다.  (컴파일말하는듯)
initial begin
    $dumpfile("inv_tb.vcd"); //얘를 만들겠다.
    $dumpvars(0,u1); // 이름설정
end

endmodule