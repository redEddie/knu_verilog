// 1. 상태를 정의한다.
// define => global variable이므로 다른 파일의 define과 겹치면 안 된다.
`define P0 2'b01 // sleep
`define P1 2'b10 // cook
`define P2 2'b11 // book

// 포트 정의
module parent (
    input clk,
    input resetb,
    input wakeup,
    output food,
    output book
);
    reg [1:0] state; 
    reg [1:0] next_state;
    reg food; 
    reg book; 

// 2. 현재 FSM 내부에서 돌아가는 logic
always @(negedge resetb or posedge clk)
    if(~resetb)
        state <= `P0; // 리셋당하면 initial state로 돌아감.
    else 
        next_state <= state;

// 3. next state logic
always @(*)
    if(state == `P0)
        if(wakeup == 1'b1)
            next_state <= `P1;
        else
            next_state = `P0;
    else if(state == `P1)
        next_state <= `P2;
    else if(state == `P2)
        next_state <= `P0;
    else
        next_state <= state;

// 4. output logic
always @(negedge resetb or posedge clk)
    if(~resetb)
        state <= `P0; // 리셋당하면 initial state로 돌아감.
        food <= 1'b0; // 밥 그만 출력. 
        book <= 1'b0; // 책 그만 출력.
    else if(state == `P1)
        food <= 1'b1; // 밥 출력.
    else if(state == `P2)
        food <= 1'b0; // 밥 그만 출력. 
        book <= 1'b1; // 책 출력. 



endmodule


/*
`define으로 상태 정의 (1) state space
구조가 위는 레벨트리거로 항상 상태를 바꾸고, 
아래는 엣지트리거로 상태를 샘플하는 거. (2) given condition
상태에 따라서 출력 (3) given state => out
*/