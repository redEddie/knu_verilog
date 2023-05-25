/*
1. 이 회로를 실시간 속도를 출력하도록 만든다.
2. 속도에 따라 이동거리를 출력하는 걸 만든다.
3. l = r*theta를 이용해 각속도를 실시간으로 출력하는 모듈을 만든다.
4. 일정고도가 되면 출력을 끄도록 한다.
5. 
*/

/*
1단의
비추력 : 263s
연소시간 : 168s
알파 : 1/168
초기무게 : 3,233,500kg
연료무게 : 2,077,000kg
*/




module realTimeCalculator (
    output reg [63:0] velocity,
    output reg [63:0] afterWeight,
    
    input [31:0] specificImpulse,
    input [31:0] initialWeight,
    input [31:0] propellentWeight,
    input [31:0] burntime,
    input clk,
    input resetb
);

localparam GRAVITY = 9_799;
localparam SF = 10.0**-3.0;
localparam ISF = 10.0**3.0; // 얘를 곱하면 소수 3째자리 계산하겠단 의미가 된다.


wire [31:0] propellentConsumeRatio;
wire [63:0] effectiveExhaustVelocity; // u'
wire [63:0] lnmu_f;
wire [63:0] mu_f;

assign propellentConsumeRatio = (propellentWeight/burntime)*ISF*ISF*ISF; // 소수점 9째 자리를 표현하고 있다.
assign effectiveExhaustVelocity = (GRAVITY * specificImpulse); // 소수점 3째자리까지 보고 있다.

assign mu_f = ((initialWeight - propellentWeight) / initialWeight) * ISF*ISF*ISF; // 질량비를 소수점9째까지 보겠다.
assign lnmu_f = (-1) * ($ln(mu_f) - $ln(ISF*ISF*ISF)) * SF; // 질량비의 ln을 소수점 9까지 계산했다. 다음 계산에서 소수점 6째짜리와 곱하므로 그거까지만 해준다.

always @(posedge clk or negedge resetb) begin
    // 곱해기 덕분에 소수점 6째자리를 두번 봐서 소수점 12째까지 보고 있다. 줄여줘야 한다.
    velocity <= (effectiveExhaustVelocity * lnmu_f)* SF*SF;    
    afterWeight <= initialWeight - propellentWeight;
end

initial begin
    $display("중력가속도 : %f", GRAVITY);
    $display("유효배기속도 : %f", effectiveExhaustVelocity);
    $display("최종속도 : %f", velocity);
end

endmodule //realTimeCalculator