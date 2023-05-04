// 1. 상태를 정의함.
`define S0 0
`define S1 1
`define S2 2

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

reg [3:0] pduty;

reg pwm;

reg [7:0] count;

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
        if (count == pduty ) // error fixed.
            next_state <= `S2;
        else
            next_state <= `S1;
    else if( state == `S2)
        if (count == freq )
            next_state <= `S0;
        else
            next_state <= `S2;
    // else
    //     next_state <= state;

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

// for error fixing. 하나의 freq가 끝나기 전에 duty가 바뀌지 않도록 만듬.
always @(negedge resetb or posedge clk) begin
    if (~resetb)
        pduty <= 4'b0;
    else if (state == `S0)
        pduty <= duty;
end

endmodule

