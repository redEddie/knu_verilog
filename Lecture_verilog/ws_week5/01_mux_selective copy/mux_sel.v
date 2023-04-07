// `define COM1 
// define을 하지 않으면 else로 가게 된다.
// C언어에서와 동일하다. selective하게 설계.
// 아래와 tb.v에 모듈이름을 계속 바꿔줘야하므로 define을 사용.

`ifdef COM1 // reg
module mux_2by1(
    input a, 
    input b, 
    input sel, 
    output out
);

reg out;

always @ (*) // list에 변수 빼먹으면 결과값 달라진다.
    if (sel)
        out <= b;
    else
        out <= a;
// 4가지 넣을 수 있다. 0, 1, high-z, x(unsigned)

endmodule

`else // wire
module mux_2by1(
    input a,
    input b,
    input sel,
    output out
);

wire out;

// assign out = sel ? b : a;
assign a = 1'b1;
assign b = 1'b1;
assign sel = 1'b1;

endmodule
`endif

// 컴파일 순서도 중요하다.? tb안에 define을 넣는 경우.