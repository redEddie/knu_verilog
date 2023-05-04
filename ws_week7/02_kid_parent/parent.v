`define P0 0 // sleep
`define P1 1 // cook
// ㄴ global variable이므로 다른 파일의 define과 겹치면 안 된다.

module parent (
    input clk,
    input resetb,
    input wakeup,
    output food
);
    reg state; 
    reg next_state;
    reg food; 


// state logic
    always @(negedge resetb or posedge clk)
        if(~resetb)
            state <= `P0; 
        else
            state <= next_state; 

// next state determination
    always @(*)
        if(state == `P0) // sleep(default)
            if(wakeup == 1'b1)
                next_state <= `P1; // cook
            else
                next_state <= `P0;
        else if(state == `P1)
            if(wakeup == 1'b1)
                next_state <= `P1; // repeat wakeup
            else
                next_state <= `P0; // stop meal, lets sleep
        else
            next_state <= state;
    
// output logic
    always @(negedge resetb or posedge clk)
        if(~resetb)
            state <= `P0;
        else if(state == `P1)
            food <= 1'b1; // eat my food
        else
            food <= 1'b0; // cut food


endmodule


/*
`define으로 상태 정의 (1) state space
구조가 위는 레벨트리거로 항상 상태를 바꾸고, 
아래는 엣지트리거로 상태를 샘플하는 거. (2) given condition
상태에 따라서 출력 (3) given state => out
*/