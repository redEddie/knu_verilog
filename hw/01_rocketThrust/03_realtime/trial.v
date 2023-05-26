// 클럭이 마이크로 단위이다..
/*
해야할 거. 정확도를 위해서 소수 9번째에서 계산하게 만든다.
높이를 반환하도록 한다.
높이와 속도를 받아 각속도를 계산해낸다.
*/


module trial (
    output reg [127:0] velocity,
    output reg [127:0] afterWeight,

    input wire [63:0] specificImpulse,
    input wire [63:0] initialWeight,
    input wire [63:0] propellentWeight,
    input wire [63:0] burntime,
    input wire clk,
    input wire resetb
);

parameter SF = 10.0**-3.0;
parameter ISF = 10.0**3.0;
parameter GRAVITY = 9_799; // 미리 3승해서 소수를 피했다.

wire [63:0] consumeRatio;
assign consumeRatio = propellentWeight/burntime; // 이 자체로는 그냥 비율(소수6째)

reg [63:0] usedPropellent;
reg [63:0] usedPropellentForCalcul;

always @(posedge clk or negedge resetb) begin
    afterWeight <= initialWeight - propellentWeight;
    usedPropellent <= usedPropellent + 2*`PERIOD*consumeRatio; // 소수6째까지 계산하고 있다.
    usedPropellentForCalcul <= usedPropellent*SF; // 소수6자리까지 보기로 하자.
end 

reg [63:0] mu;
always @(*) begin
    mu <= (initialWeight*ISF*ISF - usedPropellent) / initialWeight; // 분모가 소수6자리를 더 표현하고 있다. 소수 6자리까지
end


wire [63:0] lnmu;
assign lnmu = (-1)*($ln(mu) - $ln(ISF*ISF))*ISF*ISF; // 소수 6자리까지 표현된 mu의 ln 절댓값이다.

wire [63:0] uprime; // effective exhaust velocity
assign uprime = GRAVITY * specificImpulse;

always @(posedge clk or negedge resetb) begin
    velocity <= uprime * lnmu; // 소수3자리 * 소수6자리
end

reg [63:0] elapsed;

initial begin
    usedPropellent = 0;
    elapsed = 0;
end

initial begin
    #10
    $display("시간 당 연소량 : %f", consumeRatio);
    $display("연소 후 무게 : %f", afterWeight);
    $display("질량비 : %f", mu);
    $display("절댓값 ln 질량비 : %f", lnmu);
    $display("최종속도 : %f", velocity);
    $display("최종속도 : %f", (velocity*SF*SF*SF));
end

always begin
    elapsed <= elapsed + 1;
    #1000000 $display("시간 : %f", elapsed);
end

always @(*) begin
    // $display("최종속도 : %f", velocity);

    $display("질량비 : %f", mu);
    $display("절댓값 ln 질량비 : %f", lnmu);
    $display("최종속도 : %f", (velocity*SF*SF*SF));
end

endmodule //trial