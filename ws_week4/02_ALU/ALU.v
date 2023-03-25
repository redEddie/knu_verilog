module ALU(
    input [1:0] cmd,
    input [3:0] a,
    input [3:0] b,
    output [3:0] out
);

// add의 결과.
wire [3:0] RESADD; 
wire COUT;

// and의 결과.
wire [3:0] RESAND; 

wire [3:0] RESOR;

wire [3:0] RESSUB; 

// cout 과 RESADD 에 a+b를 할당.
assign {COUT, RESADD} = a+b;
// RESAND에 a and b 할당.
assign RESAND = a&b;

assign RESOR = a&b;

assign RESSUB = a&b;

// 삼항연산자 : (out) = (조건) ? (참일때출력) : (거짓일때출력);
assign out = 
    (cmd == 2'b00) ? RESAND : 
    (cmd == 2'b01) ? RESOR : 
    (cmd == 2'b10) ? RESADD :
    (cmd == 2'b11) ? RESSUB : 4'b0000;

endmodule