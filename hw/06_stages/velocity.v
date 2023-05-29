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
    output reg ignition_end,

    input wire backward,
    input wire [63:0] specificImpulse,
    input wire [63:0] initialWeight,
    input wire [63:0] propellantWeight,
    input wire [63:0] burntime,
    input wire clk,
    input wire resetb
);

wire [63:0] consumeRatio;
assign consumeRatio = propellantWeight/burntime; // 이 자체로는 그냥 비율(소수6째)

reg [63:0] usedPropellant;
reg [N-1:0] initialVelocity;

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        usedPropellant <= 0;
    end
    else if (~ignition_end) begin
        usedPropellant <= usedPropellant + 2*PERIOD*consumeRatio; // 소수6째까지 계산하고 있다.
    end
    else
        usedPropellant <= usedPropellant;
end 

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        afterWeight <= 0;
    end
    else
        afterWeight <= initialWeight - propellantWeight;
end

reg [63:0] mu;
always @(*) begin
    mu <= (initialWeight*ISF*ISF - usedPropellant) / initialWeight; // 분모가 소수6자리를 더 표현하고 있다. 소수 6자리까지
end


wire [63:0] lnmu;
assign lnmu = (-1)*($ln(mu) - $ln(ISF*ISF))*ISF*ISF; // 소수 6자리까지 표현된 mu의 ln 절댓값이다.

wire [63:0] uprime; // effective exhaust velocity
assign uprime = GRAVITY * specificImpulse;



always @(posedge clk or negedge resetb) begin
    if ((~resetb) || (usedPropellant == 0)) begin
        velocity <= initialVelocity;
        ignition_end <= 0;
    end
    else if ((usedPropellant*SF*SF < propellantWeight) && (~backward)) begin
        velocity <= initialVelocity + uprime * lnmu; // 소수3자리 * 소수6자리, 계산은 9자리에서 하도록 하고 얘는 무조건 9자리로 출력되도록 해야 뒤에 탈이 없다.
    end
    else if ((usedPropellant*SF*SF < propellantWeight) && (backward)) begin
        velocity <= initialVelocity - uprime * lnmu;
    end
    else if ((usedPropellant*SF*SF >= propellantWeight)) begin // 소수점을 자르기보다 정수를 키우는게 더 정확하다.
        initialVelocity <= velocity;
        ignition_end <= 1;
    end
    else begin
        velocity <= velocity;
        ignition_end <= 1;
    end
end

initial begin
    initialVelocity = 0;
end

endmodule //getVelocity