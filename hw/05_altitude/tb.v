module tb#(
    parameter PERIOD = 10,
    parameter N = 64,
    parameter GRAVITY = 9_799,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0 // 얘를 곱하면 소수 3째자리 계산하겠단 의미가 된다.
);
// 어제 3 고친거처럼 angular velocity 전달하느거 다시 만듦면 된다.
// 시뮬레이션 시간단위 다르게 하면 고장난다.
getVelocity getVelocity_1(
    .velocity(DELIVER_VELOCITY),
    .afterWeight(AFTERWEIGHT),
    .specificImpulse(SPECIFICIMPULSE),
    .initialWeight(INITIALWEIGHT),
    .propellentWeight(PROPELLENTWEIGHT),
    .burntime(BURNTIME),
    .clk(CLK),
    .resetb(RESETB)
);

numericalIntegral height_calculator(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(VELOCITY),
    .start_integration(START_INTEGRATION),
    .integral_result(HEIGHT)
);
wire [N-1:0] DELIVER_VELOCITY;
reg [N-1:0] VELOCITY;
always @(posedge CLK or negedge RESETB) begin
    VELOCITY <= DELIVER_VELOCITY;
end

gimbal30km gimbal_1(
    .clk(CLK),
    .resetb(RESETB),
    .velocity(VELOCITY),
    .height(HEIGHT),
    .angularVelocity(DELIVER_ANGULER_VELOCITY),
    .noairAltitude(DELIVER_NOAIR_ALTITUDE),
    .noairDistance(DELIVER_NOAIR_DISTANCE),
    .gimbalEnable(GIMBALENABLE)
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

initial begin
    NOAIR_ALTITUDE = 0;
    NOAIR_DISTANCE = 0;
end

altitudeCalculator altitude_1(
    .altitude(ADDITIONALALTITUDE),
    .distance(DISTANCE),
    
    .clk(CLK),
    .resetb(RESETB),
    .noairAltitude(NOAIR_ALTITUDE),
    .noairDistance(NOAIR_DISTANCE),
    .angularVelocity(ANGULER_VELOCITY),
    .height(HEIGHT)
);

// velocity 관련 메모리
wire [63:0] AFTERWEIGHT;

wire GIMBALENABLE;
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

wire [N-1:0] HEIGHT;

reg [63:0] elapsed;

// altitude calculator
wire [N-1 : 0] ADDITIONALALTITUDE;
wire [N-1 : 0] DISTANCE;

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

reg print30km;
initial begin
    print30km = 0;
end

reg [N-1:0] currentHeight;
always @(posedge CLK or negedge RESETB) begin
    if (~GIMBALENABLE) begin
        currentHeight <= HEIGHT;
    end
    else if(GIMBALENABLE) begin
        currentHeight <= NOAIR_ALTITUDE + ADDITIONALALTITUDE;
    end
end

always @(posedge CLK or negedge RESETB) begin
    if (~GIMBALENABLE) begin
        elapsed <= elapsed + 1;
        #1_000000 $display("시간 : %04d", elapsed);
    end
    else if (~print30km) begin
        elapsed <= elapsed +1;
        #1_000000 $display("saturn V reached 30km height @ %04d", elapsed); 
        print30km <= 1;
        $display(">>> gimbal start...");
        $display(">>> current altitude : %f km", currentHeight*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF);
    end
    else begin
        elapsed <= elapsed +1;
        #1_000000 $display("시간 : %04d", elapsed);
    end
end

initial begin
    #10_000000 $finish;
    // #68_000000 $finish;
    // #168_000000 $finish;
end

always begin
    #10 CLK <= ~CLK;
end

initial begin
    $dumpfile("output.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb