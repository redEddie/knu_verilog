module ALU(
    input [1:0] cmd,
    input [3:0] a,
    input [3:0] b,
    output [3:0] out
);



// add의 결과.
wire [3:0] RES_ADD; 
wire C_OUT;
wire B_OUT;



// and의 결과.
wire [3:0] RES_AND; 
// or의 결과.
wire [3:0] RES_OR;
// sub의 결과.
wire [3:0] RES_SUB; 



// C_OUT 과 RESADD 에 a+b를 할당.
assign {C_OUT, RES_ADD} = a+b;
// RESAND에 a and b 할당.
assign RES_AND = a&b;

assign RES_OR = a|b;

assign {B_OUT, RES_SUB} = a-b;



// 삼항연산자 : (out) = (조건) ? (참일때출력) : (거짓일때출력);
assign out = 
    (cmd == 2'b00) ? RES_AND : 
    (cmd == 2'b01) ? RES_OR : 
    (cmd == 2'b10) ? RES_ADD :
    (cmd == 2'b11) ? RES_SUB : 4'b0000;

endmodule