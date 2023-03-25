module adder(
    input [3:0] a, // bus의 크기가 4-bits임을 의미.
    input [3:0] b,
    output cout,
    output [3:0] sum
);

// wire는 정의하지 않으면 default로 wire이다.
// wire cout;

// c언어는 한 번만 함수를 실행하기 때문에, 변수의 변화가 새로운 출력을 만들지 못 한다.
assign sum = a+b; // assign 은 sum과 a+b를 이어주는거

endmodule