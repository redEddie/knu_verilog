module mux_2by1_reg(
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