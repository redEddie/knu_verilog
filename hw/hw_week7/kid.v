/*===============================*/
/*

1. define => state
2. state logic
3. next state logic
4. output logic

*/
/*================================*/

// 1. 상태를 먼저 정의
`define S0 2'b00 // hungry
`define S1 2'b01 // full
`define S2 2'b10 // study

// 포트를 정의
module kid (
    input clk,
    input resetb,
    input meal,
    input book,
    output request
);
    reg [1:0] state;
    reg [1:0] next_state;
    reg request;

// 2. state logic
    always @(negedge resetb or posedge clk)
        if(~resetb)
            state <= `S0; // reset당하면 initial state로 돌아감.
        else
            state <= next_state; // update from next_state

// 3. next state logic
    always @(*)
        if(state == `S0)                // 배고픔
            if(meal == 1'b1)
                next_state <= `S1;
            else
                next_state <= `S0;
        else if(state == `S1)           // 배부름
            if(book == 1'b1)
                next_state <= `S2;
            else
                next_state <= `S1;
        else if(state == `S2)           // 공부 중
            next_state <= `S0;
        else
            next_state <= state;        // 혹시 모를 에러에 대비. 현재 반복.
    

// 4. output logic
    always @(negedge resetb or posedge clk) begin
        if(~resetb)                 // 초기화
            request <= 1'b0;
        else if(state == `S0)       // 배고픔.
            request <= 1'b1;        // 밥 요청.
        else if(state == `S1)       // 배부름.
            request <= 1'b0;        // 밥 요청 멈춤.
    end

endmodule