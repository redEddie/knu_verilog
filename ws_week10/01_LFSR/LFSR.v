/*
https://ko.wikipedia.org/wiki/%EC%84%A0%ED%98%95_%EB%90%98%EB%A8%B9%EC%9E%84_%EC%8B%9C%ED%94%84%ED%8A%B8_%EB%A0%88%EC%A7%80%EC%8A%A4%ED%84%B0

Linear feedback shift register
Pseudo Random Number Generation
0과 1이 거의 랜덤으로 출력하는 회로.
난수 시드가 동일하다.
시프트 레지스터의 일종
이전 상태 값의 선형함수로 계산 <= XOR
*/

`define N 8

module LFSR (
    input clk,
    input resetb,
    output out
);
    
    reg [`N-1:0] REG;
    wire [`N-1:0] next;
    always @(posedge clk or negedge resetb) begin
        if(~resetb)
            REG <= 1; // 초기 시드를 넣는 기능
        else
            REG <= next;
    end

    // 내부 패턴 x^3 + x^2 + 1
    wire result;
    assign result = REG[3] + REG[2] + REG[0];

    assign next = {result, REG[`N-1:1]};
    assign out = REG[0];
endmodule