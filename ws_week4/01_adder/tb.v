// 원래 i/o 없다.
module tb;

// assign 으로 ref처럼 A를 고정할 수 도 있다.
// assign A = 4'b1111;
reg [3:0] A;
reg [3:0] B;

adder dut1(
    // i/o를 지정할 때
    // input, output을 각각 지정해도 되고,
    // .a(A) 와 같이 지정해도 된다.
    .a(A),
    .b(B),
    .cout(),
    .sum()
);

// initial 로 풀어헤치는 방법, always로 ...
// 둘 다 내부는 reg만 와야 한다.
initial begin

    #100
    A = 4'b0001; // 4'h1
    B = 4'b0010; // 4'h2

    #100
    // 입력 변환에 if()도 가능하다.
    // if()
    A = 4'b0000;
    B = 4'b0000;

    #100;
    $finish;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,dut1);
end

endmodule
