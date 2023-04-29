/*===============================*/
/*

1. 상태를 먼저 정의
2. 현재 FSM 내부에서 돌아가는 로직(status register)
3. next state logic
4. output logic

*/
/*================================*/

// 1. 상태를 먼저 정의
`define S0 2'b01 // hungry
`define S1 2'b10 // full
`define S2 2'b11 // study

// 포트를 정의
module kid (
    input clk,
    input resetb,
    input meal,
    input book,
    output request
);
    reg [1:0] state; // 현재상태
    reg [1:0] next_state;
    reg request; // !!! 출력은 reg로.

// 2. 현재 FSM 내부에서 돌아가는 로직
always @(negedge resetb or posedge clk)
    if(~resetb)
        state <= `S0; // reset당하면 initial state로 돌아감.
    else
        state <= next_state; //update from next_state

// 3. next state logic
// 입력이 2개가 있고(meal, book), 입력이 있어야 바뀌는 상태 2개 입력없어도 시간에 따라 바뀔 상태 1개.
always @(*)
    if(state == `S0) // 배가 고플 때(현재상태) => 밥을 먹고(입력) => 배가 불러짐(미래상태).
        if(meal == 1'b1)
            next_state <= `S1;
        else
            next_state <= `S0; // 밥없으면 => 여전히 배고픔.
    if(state == `S1) // 배가 부르면 => 책을 먹고 => 배가 고파짐.
        if(book == 1'b1)
            next_state <= `S2;
        else
            next_state <= `S1; // 공부 안 하면 계속 배부름.
    else if(state == `S2) // 배가 고프면
        next_state <= `S0; // 시간 지남에 따라 배가 고파짐.
    else
        next_state <= state; // 혹시 모를 에러에 대비. 현재 반복.
    

// 4. output logic
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        request <= 1'b0;
    else if(state == `S0) // 배고픈 상태.
        request <= 1'b1; // 밥 줘.
    else if(state == `S1) // 배부른 상태.
        request <= 1'b0; // 밥ㄴㄴ.
end

endmodule