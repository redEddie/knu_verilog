// 1. 상태를 정의함.
`define S0 2'b00 // 가로방향 초록불 (세로방향 빨강불)
`define S1 2'b01 // 가로방향 노랑불 (세로방향 빨강불)
`define S2 2'b10 // 가로방향 빨강불 (세로방향 초록불)
`define S3 2'b11 // 가로방향 빨강불 (세로방향 노랑불) 가로방향(L0) 세로방향(L1)

`define RED     0
`define YELLOW  1
`define GREEN   2 // Q. 이건 몇 비트임?


// 포트 인아웃 설정 및 와이어, 레지스터
module traffic (
    input clk,
    input resetb,
    input car0,
    input car1,

    output [1:0] led0, // 여기다가 비트 지정해도 되긴하지. 이게 더 편한가?
    output [1:0] led1
);
    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] led0; // Q. 왜 중복해서 비트를 정의해주지..?
    reg [1:0] led1;

// 2. next state determination
    always @(*)
        if(state == `S0)
            if(car0 == 1'b0)
                next_state <= `S1;
            else
                next_state <= `S0;
        else if(state == `S1)
            next_state <= `S2;
        else if(state == `S2)
            if(car1 == 1'b0)
                next_state <= `S3;
            else
                next_state <= `S2;
        else if(state == `S3)
            next_state <= `S0;
        else
            next_state <= state;
    
// 3. state change
    always @(negedge resetb or posedge clk)
        if(~resetb)
            state <= `S0; // initial state
        else
            state <= next_state; // update from next_state

// 4. output logic
// led0과 led1을 같이 하면 안 된다. 다른 always 구문을 이용.
// 코딩언어가 아닌 하드웨어를 기술하는 언어.
// 하나의 reg가 하나의 플립플롭.
// state에 따라 구름(always)에서 플립플롭에 신호를 넣어줌.
// 하나의 always에는 하나의 레지스터만 사용해야(건드려야)한다.
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        led0 <= 2'b0;
        // led1 <= 2'b0;
    else if(state == `S0)
        led0 <= `GREEN;
        // led1 <= `RED;
    else if(state == `S1)
        led0 <= `YELLOW;
        // led1 <= `RED;
    else if(state == `S2)
        led0 <= `RED;
        // led1 <= `GREEN;
    else if(state == `S3)
        led0 <= `RED;
        // led1 <= `YELLOW;
    else
        led0 <= 2'b0;
        // led1 <= 2'b0;
end

always @(negedge resetb or posedge clk) begin
    if(~resetb)
        led1 <= 2'b0;
    else if(state == `S0)
        led1 <= `RED;
    else if(state == `S1)
        led1 <= `RED;
    else if(state == `S2)
        led1 <= `GREEN;
    else if(state == `S3)
        led1 <= `YELLOW;
    else
        led1 <= 2'b0;
end

endmodule