module adder(
    input [3:0] a, // bus의 크기가 4-bits임을 의미.
    input [3:0] b,
    output cout,
    output [3:0] sum
);

wire out;

assign out = sel ? b : a;

endmodule