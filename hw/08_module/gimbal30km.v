/*
https://en.wikipedia.org/wiki/Gimbaled_thrust

이제 188km까지 갔으면 궤도를 유지하면서 속도만 늘려야 한다.
*/

module gimbal30km #(
    parameter N = 64,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter radianBig = 400_000 // 4000km
)(
    output reg [N-1:0] angularVelocity,
    output reg [N-1:0] noairAltitude,
    output reg [N-1:0] noairDistance,
    output reg gimbalEnable,

    input clk,
    input resetb,
    input wire [N-1:0] velocity,
    input wire [N-1:0] height
);


always @(posedge clk or negedge resetb) begin
    if (~resetb)
        gimbalEnable <= 0;
    else if ((height*SF*SF*SF*SF > 30) )
        gimbalEnable <= 1;
    else
        gimbalEnable <= 0;
end

initial begin
    noairAltitude = 0;
    noairDistance = 0;
end
always @(posedge gimbalEnable) begin
    if(gimbalEnable)
        noairAltitude <= height;  // 초기치는 30km 순간의 고도. 근데 소수 9자리를 곁들인.
        noairDistance <= 0;       // 초기치는 0. 근데 얘도 소수 9자리를 만들어주자.
end

always @(posedge clk or negedge resetb) begin
    if (~resetb)
        angularVelocity <= 0;
    else if(gimbalEnable)
        angularVelocity <= velocity / radianBig;
        /* height는 소수9자리까지. 
        l = r*θ 이용.
        결과물은 나눠도 소수점 9자리까지이다.
        얘는 순간순간의 각도이다. 각속도.. 랑 동일하네 이게...
        */
end

endmodule //gimbal30km
/*
30km일 때 gimbal enable을 1로 바꾸고, 각속도를 준다.
*/