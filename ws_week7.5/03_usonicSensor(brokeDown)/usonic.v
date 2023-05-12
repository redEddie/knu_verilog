// 1. state 정의
`define U0 0
`define U1 1
`define U2 2

module usonic (
    input       clk,
    input       resetb,
    input [7:0] range,
    output      pwm
);

reg [1:0] state;
reg [1:0] next_state;

reg       pen;
reg [3:0] duty;

// 2. next state
always @ (*)
    if (state == `U0)
        if(range<20 )
            next_state <= `U0;
        else if (range >100)
            next_state <= `U2;
        else 
            next_state <= `U1;
    else if (state == `U1)
        if(range<20 )
            next_state <= `U0;
        else if (range >100)
            next_state <= `U2;
        else 
            next_state <= `U1;
    else if (state == `U2)
        if(range<20 )
            next_state <= `U0;
        else if (range >100)
            next_state <= `U2;
        else 
            next_state <= `U1;


// 3. update state
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        state <= `U0;
    else
        state <= next_state;
end


// 4. output change (PEN, DUTY)
// PEN 출력 담당.
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        pen <= 1'b0;
    else if ((state == `U1) || (state == `U2))
        pen <= 1'b1;
    else if(state == `U0)
        pen <= 1'b0;
end

// DUTY 출력 담당.
always @(negedge resetb or posedge clk) begin
    if(~resetb)
        duty <= 4'b0;
    else if (state == `U0)
        duty <= 4'b0;
    else if (state == `U1)
        duty <= 4'd5; // decimal
    else if (state == `U2)
        duty <= 4'd10; // decimal
end


pwm p1(
    .clk(clk),
    .resetb(resetb),
    .pen(pen),
    .duty(duty),
    .freq(4'd15),
    .pwm(pwm) // 출력은 그대로 받아오는 것임.
);


endmodule