module tb#(
    parameter PERIOD = 10,
    parameter N = 64
);
// 어제 3 고친거처럼 angular velocity 전달하느거 다시 만듦면 된다.
// 시뮬레이션 시간단위 다르게 하면 고장난다.
getVelocity getVelocity_1(
    .velocity(VELOCITY),
    .afterWeight(AFTERWEIGHT),
    .specificImpulse(SPECIFICIMPULSE),
    .initialWeight(INITIALWEIGHT),
    .propellentWeight(PROPELLENTWEIGHT),
    .burntime(BURNTIME),
    .clk(CLK),
    .resetb(RESETB)
);

numericalIntegral integration_1(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(VELOCITY),
    .start_integration(START_INTEGRATION),
    .integral_result(INTEGRAL_RESULT)
);

gimbal30km gimbal_1(
    .clk(CLK),
    .resetb(RESETB),
    .velocity(VELOCITY),
    .height(INTEGRAL_RESULT),
    .angularVelocity(DELIVER_ANGULER_VELOCITY),
    .noairAltitude(DELIVER_NOAIR_ALTITUDE),
    .noairDistance(DELIVER_NOAIR_DISTANCE)
);
wire [N-1:0] DELIVER_NOAIR_ALTITUDE;
reg [N-1:0] NOAIR_ALTITUDE;
always @(posedge CLK or negedge RESETB) begin
    NOAIR_ALTITUDE <= DELIVER_NOAIR_ALTITUDE;
end
wire [N-1:0] DELIVER_NOAIR_DISTANCE;
reg [N-1:0] NOAIR_DISTANCE;
always @(posedge CLK or negedge RESETB) begin
    NOAIR_DISTANCE <= DELIVER_NOAIR_DISTANCE;
end

altitudeCalculator altitude_1(
    .clk(CLK),
    .resetb(RESETB),
    .noairAltitude(NOAIR_ALTITUDE),
    .noairDistance(NOAIR_DISTANCE),
    .angularVelocity(ANGULER_VELOCITY)
);

// velocity 관련 메모리
localparam GRAVITY = 9_799;
localparam SF = 10.0**-3.0;
localparam ISF = 10.0**3.0; // 얘를 곱하면 소수 3째자리 계산하겠단 의미가 된다.

wire [63:0] VELOCITY;
wire [63:0] AFTERWEIGHT;
    
reg [63:0] SPECIFICIMPULSE;
reg [63:0] INITIALWEIGHT;
reg [63:0] PROPELLENTWEIGHT;
reg [63:0] BURNTIME;
reg CLK;
reg RESETB;

wire [N-1:0] DELIVER_ANGULER_VELOCITY;
reg [N-1:0] ANGULER_VELOCITY;
always @(posedge CLK or negedge RESETB) begin
    ANGULER_VELOCITY <= DELIVER_ANGULER_VELOCITY;
end

// integration 관련 메모리
reg [N-1:0] SIGNAL_INPUT;
reg START_INTEGRATION;

wire [N-1:0] INTEGRAL_RESULT;

reg [63:0] elapsed;

initial begin
    SPECIFICIMPULSE = 263;
    INITIALWEIGHT = 3233500;
    PROPELLENTWEIGHT = 2077000;
    BURNTIME = 168;

    RESETB = 0;
    CLK = 0;

    SIGNAL_INPUT = 0;
    START_INTEGRATION = 0;

    elapsed = 0;
end

initial begin
    #10 RESETB = 1;
        START_INTEGRATION = 1;
end

always begin
    elapsed <= elapsed + 1;
    #1000 $display("시간 : %f", elapsed);
end
/*
always @(*) begin
    $display("현재 속도 : %f", VELOCITY*SF*SF*SF);
    $display("현재 높이 : %f", INTEGRAL_RESULT);
end
*/
initial begin
    // #10_000000 $finish;
    #168_000 $finish;
end

always begin
    #10 CLK <= ~CLK;
end

initial begin
    $dumpfile("output.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb