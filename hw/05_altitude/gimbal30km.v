/*
https://en.wikipedia.org/wiki/Gimbaled_thrust

이게 필요한 이유는 우주선이 계속해서 가속하기 때문에 
    궤도를 만들기 위한 각속도를 일정하게 유지한다면 => L=r*theta 에서 r이 계속해서 줄어들어 곧 추락한다.
    따라서 속도에 알맞는 각속도를 반환해주고, 이에 따라 엔진이 동작할 수 있어야 한다.
*/

module gimbal30km #(
    parameter N = 64,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0
)(
    output reg [N-1:0] angularVelocity,

    input clk,
    input resetb,
    input wire [N-1:0] velocity,
    input wire [N-1:0] height
);
// reg [N-1:0] angularVelocity;

localparam targetAltitude = 188000; // 목표 높이 188km

reg gimbalEnable;
always @(posedge clk or negedge resetb) begin
    // 30km이면~
    // 받아온 높이 단위가 소수9자리까지, 보고 싶은건 km 단위 따라서 11자리 부터
    if(height*SF*SF*SF*SF > 30)
        gimbalEnable <= 1;
    else if (~resetb)
        gimbalEnable <= 0;
    else
        gimbalEnable <= 0;
end

// 클럭당 속도에 클럭을 곱해서 계산하면 거리가 되고 이를 가지고 각속도를 구해보자.
parameter radianBig = 400000; // 400km라고 대충 잡자
reg [N-1:0] altitude;
always @(posedge clk or negedge resetb) begin
    if(gimbalEnable)
        angularVelocity <= height / radianBig;
        /* height는 소수9자리까지. 
        l = r*θ 이용.
        결과물은 나눠도 소수점 9자리까지이다.
        */
end

initial begin
    gimbalEnable = 0;
    angularVelocity = 0;

    if (height*SF*SF*SF*SF > 30) begin
        $display("saturn V reached 30km height"); 
        $display(">>> gimbal start...");
    end
end

endmodule //30kmGimbal