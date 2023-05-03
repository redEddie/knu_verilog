module counter(
    input clk,
    input reset_b,
    input enable,
    input read,
    output [7:0] data
);

reg [7:0] count;

assign data = read ? count : 8'bz;


always @(negedge reset_b or posedge clk)
    if(~reset_b)
        count <= 8'b0; 
    else if(enable)
        count <= count + 1;



// pwm에서 이미 호출했기 때문에 state를 불러오지 못 함.
//      => pwm 안에서 resetb신호를 주도록 바꿔야 함.

/*
pwm p1(
    .state(state)

);

wire state;

if(~resetb)
        count <= 8'b0; 
    else if((state == `S1) || (state == `S2))
        count <= count + 1;
    else if(state == `S0)
        count <= 8'b0;
*/


endmodule



