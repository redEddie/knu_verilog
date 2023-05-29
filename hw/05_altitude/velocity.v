// 클럭이 마이크로 단위이다..
/*
해야할 거. 정확도를 위해서 소수 9번째에서 계산하게 만든다. (출력속도는 소수9자리까지 무조건)
높이를 반환하도록 한다.
높이와 속도를 받아 각속도를 계산해낸다.
*/


module getVelocity #(
    parameter PERIOD = 10,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter GRAVITY = 9_799,        // 미리 3승해서 소수를 피했다.
    parameter N = 64
)(
    output reg [63:0] velocity,
    output reg [63:0] afterWeight,

    input wire [63:0] specificImpulse,
    input wire [63:0] initialWeight,
    input wire [63:0] propellentWeight,
    input wire [63:0] burntime,
    input wire clk,
    input wire resetb
);

wire [63:0] consumeRatio;
assign consumeRatio = propellentWeight/burntime; // 이 자체로는 그냥 비율(소수6째)

reg [63:0] usedPropellent;
reg [63:0] usedPropellentForCalcul;

always @(posedge clk or negedge resetb) begin
    afterWeight <= initialWeight - propellentWeight;
    usedPropellent <= usedPropellent + 2*PERIOD*consumeRatio; // 소수6째까지 계산하고 있다.
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
    velocity <= uprime * lnmu; // 소수3자리 * 소수6자리, 계산은 9자리에서 하도록 하고 얘는 무조건 9자리로 출력되도록 해야 뒤에 탈이 없다.
end

initial begin
    usedPropellent = 0;
    $display("!!! ignition and liftoff !!!");
end

endmodule //getVelocity