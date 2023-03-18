module mux_2by1 (
    input a, input b, input sel, output out
);

reg out;

// 아래 코드는 algorithmic description 라고 한다.
// sensitive 와 살짝 다르다. 코드와 닮게 조금 sequiential 하다.
// 그래서 always 구문을 써서 sensitive하게 만들어준다.
always @ (*)
    if (sel)
        out <= b;
    else
        out <= a;


endmodule