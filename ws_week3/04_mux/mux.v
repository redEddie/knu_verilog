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
module mux_2by1 (
    input a, input b, input sel, output out
);

// 출력이 wire인 이유는 굉장히 passive한 성격을 가져야 하므로    
wire out;

// assign out = 1'b1; // (비트수)'(binary)(값)
assign out = sel ? b : a;

endmodule