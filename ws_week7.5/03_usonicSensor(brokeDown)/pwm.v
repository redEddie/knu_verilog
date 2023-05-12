// 1. 상태를 정의함.
`define S0 0
`define S1 1
`define S2 2
// counter 수정 완.
// reset_b가 동작한 이후에 세기 시작하므로 한 클럭 느리게 동작하게 된다.

`define COUNTER 
// `if COUNTER
/*
module counter cnt(
    인풋 아웃풋 하면 되겟지.
);

*/
// `else


// 포트 인아웃 설정 및 와이어, 레지스터
module pwm (
    input clk,
    input resetb,
    input pen,
    input [3:0] duty,
    input [3:0] freq,

    output pwm
);


reg [1:0] state;
reg [1:0] next_state;

reg pwm;

reg [7:0] count;

// count 내장
always @(negedge resetb or posedge clk)
    if(~resetb)
        count <= 8'b0; 
    else if((state == `S1) || (state == `S2))
        count <= count + 1;
    else if(state == `S0)
        count <= 8'b0;

// 2. next state determination
always @(*)
    if( state == `S0)
        if (pen == 1'b1)
            next_state <= `S1;
        else
            next_state <= `S0;
    else if( state == `S1)
        if (count == duty )
            next_state <= `S2;
        else
            next_state <= `S1;
    else if( state == `S2)
        if (count == freq )
            next_state <= `S0;
        else
            next_state <= `S2;

// 3. state change
always @(negedge resetb or posedge clk) begin
    if(~resetb)    
        state <= `S0;
    else
        state <= next_state;
end

// 4. output logic
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        pwm <= 1'b0;
    else if((state == `S0)||(state == `S2))
        pwm <= 1'b0;
    else if(state == `S1)
        pwm <= 1'b1; 
end

endmodule