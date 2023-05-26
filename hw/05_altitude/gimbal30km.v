/*
https://en.wikipedia.org/wiki/Gimbaled_thrust

이제 188km까지 갔으면 궤도를 유지하면서 속도만 늘려야 한다.
*/

module gimbal30km #(
    parameter N = 64,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0
)(
    output reg [N-1:0] angularVelocity,
    output reg [N-1:0] noairAltitude,
    output reg [N-1:0] noairDistance,

    input clk,
    input resetb,
    input wire [N-1:0] velocity,
    input wire [N-1:0] height
);

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
        얘는 순간순간의 각도이다. 각속도.. 랑 동일하네 이게...
        */
end

initial begin
    gimbalEnable = 0;
    angularVelocity = 0;

    if (height*SF*SF*SF*SF > 30) begin
        $display("saturn V reached 30km height"); 
        $display(">>> gimbal start...");

        noairAltitude = height; // 초기치는 30km 순간의 고도. 근데 소수 9자리를 곁들인.
        noairDistance = 0; // 초기치는 0. 근데 얘도 소수 9자리를 만들어주자.
    end
end

endmodule //30kmGimbal