/*
하려는 거

int mux_2by1(int a , int b, int c){
    if(c==1)
        return a;
    else
        return b;
}
*/

// C와 다른 점은 병렬적으로 코드 진행이 이루어진다는 점이다. 진짜 회로처럼.
// assign out = sel ? b : a; 에서 b나 a에 변화가 있으면 sel이 변한다. sensitive의 측면. 
// 다시, 함수가 읽힐 코드의 타이밍이 아니어도 실행이 된다. (이건.. 컴파일 언어라서 그런거 아닌가..? 암튼 이거도 하드웨어의 특징임. sensitive.)
module mux_2by1_wire(
    input a,
    input b,
    input sel,
    output out
);

// 출력이 wire인 이유는 굉장히 passive한 성격을 가져야 하므로.
// 이를 hard-wired 되었다고 한다.   
wire out;

// assign out = 1'b1; // (비트수)'(binary)(값)
// registor transfer level : 레지스터에서 정보가 전달이 되는 걸 표현한 코드ㄴ
assign out = sel ? b : a;

endmodule