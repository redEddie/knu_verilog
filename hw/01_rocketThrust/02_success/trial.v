module trial (
    output reg [63:0] velocity,
    output reg [63:0] afterWeight,

    input wire [31:0] specificImpulse,
    input wire [31:0] initialWeight,
    input wire [31:0] propellentWeight,
    input wire [31:0] burntime,
    input wire clk,
    input wire resetb
);

parameter SF = 10.0**-3.0;
parameter ISF = 10.0**3.0;
parameter GRAVITY = 9_799; // 미리 3승해서 소수를 피했다.

always @(posedge clk or negedge resetb) begin
    afterWeight <= initialWeight - propellentWeight;
end 

wire [31:0] mu;
assign mu = (initialWeight - propellentWeight)* ISF*ISF*ISF / initialWeight; // 소수 9자리까지

wire [63:0] lnmu;
assign lnmu = (-1)*($ln(mu) - $ln(ISF*ISF*ISF))*ISF*ISF*ISF; // 소수 9자리에 대한 mu의 ln 절댓값이다.

wire [63:0] uprime; // effective exhaust velocity
assign uprime = GRAVITY * specificImpulse;

always @(posedge clk or negedge resetb) begin
    velocity <= uprime * lnmu; // 얘는 지금 소수점 9자리 + 3자리 해서 12자리 보고 있다.
end

initial begin
    #10
    $display("연소 후 무게 : %f", afterWeight);
    $display("질량비 : %f", mu);
    $display("절댓값 ln 질량비 : %f", lnmu*SF*SF*SF);
    $display("유효배기속도 : %f", uprime*SF);
    $display("최종속도 : %f", velocity);
    $display("최종속도 : %f", (velocity*SF*SF*SF*SF));
end

endmodule //trial