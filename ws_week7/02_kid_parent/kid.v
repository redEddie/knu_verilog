`define S0 0 // hungry
`define S1 1 // full
// ㄴ상태 정함.

module kid (
    input clk,
    input resetb,
    input meal,
    output request
);
    reg state; // 현재상태
    reg next_state;
    reg request; // !!! 출력은 reg로.

// next state determination
    always @(*)
        if(state == `S0) // 배가 고플 때(현재상태) => 밥을 먹고(입력) => 배가 불러짐(미래상태).
            if(meal == 1'b1)
                next_state <= `S1;
            else
                next_state <= `S0; // 밥없으면 => 여전히 배고픔.
        else if(state == `S1) // 아직 배가 고프면
            next_state <= `S0; // on elasped time, become hungry
        else
            next_state <= state;
    
// So, final state may be set a rising clock.
    always @(negedge resetb or posedge clk)
        if(~resetb)
            state <= `S0; // on birth, i am hungry
        else
            state <= next_state; //update from next_state

// given state, lets define output
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        request <= 1'b0;
    else if(state == `S0)
        request <= 1'b1; // please give me meal
    else if(state == `S1)
        request <= 1'b0; // don't feed me. im full
end

endmodule


/*
`define으로 상태 정의 (1) state space
구조가 위는 레벨트리거로 항상 상태를 바꾸고, 
아래는 엣지트리거로 상태를 샘플하는 거. (2) given condition
상태에 따라서 출력 (3) given state => out
*/