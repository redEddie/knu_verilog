module tb#(
    parameter SCALE = 1000,
    parameter PERIOD = 10,
    parameter N = 64,
    parameter GRAVITY = 9_799,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter SPECIFICIMPULSE_1 = 263,
    parameter SPECIFICIMPULSE_2 = 421,
    parameter SPECIFICIMPULSE_3 = 421,
    parameter WEIGHT_PROPELLANT_1 = 2077000,
    parameter WEIGHT_PROPELLANT_2 = 456100,
    parameter WEIGHT_PROPELLANT_3 = 39136, // 3단은 두번에 나눠 점화한다 => state 3, 4로 나눔.
    parameter WEIGHT_PROPELLANT_4 = 83864,
    parameter BURNTIME_1 = 168,
    parameter BURNTIME_2 = 360,
    parameter BURNTIME_3 = 165,
    parameter BURNTIME_4 = 335,
    parameter WEIGHT_STAGE_1 = 137000,
    parameter WEIGHT_STAGE_2 = 40100,
    parameter WEIGHT_STAGE_3 = 15200,
    parameter LM = 15103,
    parameter CMSM = 11900 // command module and service module
);


stagemanager stagemanager(
    .clk(CLK),
    .resetb(RESETB),
    .ignition_end(IGNITION_END),
    
    .backward(BACKWARD),
    .specific_impulse(SPECIFICIMPULSE),
    .initial_weight(INITIALWEIGHT),
    .weight_propellant(WEIGHT_PROPELLANT),
    .burntime(BURNTIME),
    .stage(STAGESTATE),
    .stage_manager(STAGEMANAGER)
);
wire BACKWARD;
wire [63:0] SPECIFICIMPULSE;
wire [63:0] INITIALWEIGHT;
wire [63:0] WEIGHT_PROPELLANT;
wire [63:0] BURNTIME;
wire [3:0] STAGESTATE;
wire STAGEMANAGER;

getVelocity getVelocity_1(
    .specificImpulse(SPECIFICIMPULSE),   // 바뀌는 것
    .initialWeight(INITIALWEIGHT),  // 바뀌는 것
    .propellantWeight(WEIGHT_PROPELLANT), // 바뀌는 것
    .burntime(BURNTIME),    // 바뀌는 것
    .clk(CLK),
    .resetb(~STAGEMANAGER),
    .backward(BACKWARD),

    .afterWeight(AFTERWEIGHT),
    .velocity(VELOCITY), // m/s로 소수 9자리
    .ignition_end(IGNITION_END)
);
wire [63:0] AFTERWEIGHT;
wire [N-1:0] VELOCITY;
wire IGNITION_END;

numericalIntegral height_calculator(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(VELOCITY),
    .start_integration(RESETB),

    .integral_result(HEIGHT)              // m단위로 소수 9자리
);
wire [N-1:0] HEIGHT;

gimbal30km gimbal_1(
    .clk(CLK),
    .resetb(RESETB),
    .velocity(VELOCITY),
    .height(HEIGHT),

    .angularVelocity(ANGULER_VELOCITY),
    .noairAltitude(NOAIR_ALTITUDE),
    .noairDistance(NOAIR_DISTANCE),
    .gimbalEnable(GIMBALENABLE)
);
wire [N-1:0] ANGULER_VELOCITY;
wire [N-1:0] NOAIR_ALTITUDE;
wire [N-1:0] NOAIR_DISTANCE;
wire GIMBALENABLE;


altitudeCalculator altitude_1(
    .fraction_Altitude(FRACTION_ALTITUDE),
    .fraction_Distance(FRACTION_DISTANCE),
    
    .clk(CLK),
    .resetb(RESETB),
    .noairAltitude(NOAIR_ALTITUDE),
    .noairDistance(NOAIR_DISTANCE),

    .velocity(VELOCITY),
    .angularVelocity(ANGULER_VELOCITY),
    .height(HEIGHT),
    .current_altitude(CURRENT_ALTITUDE)
);
wire [N-1:0] FRACTION_ALTITUDE;
wire [N-1:0] FRACTION_DISTANCE;

numericalIntegral cal_alt(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(FRACTION_ALTITUDE), // 64비트 크기로 줘야한다. 
    .start_integration(~PRINT188KM),

    .integral_result(ALTITUDE_GIMBAL) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] ALTITUDE_GIMBAL;

numericalIntegral cal_dist(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(FRACTION_DISTANCE), // 64비트 크기로 줘야한다. 
    .start_integration(~PRINT188KM),

    .integral_result(DISTANCE_GIMBAL) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] DISTANCE_GIMBAL;

print printer(
    .clk(CLK),
    .resetb(RESETB),
    .current_altitude(CURRENT_ALTITUDE),
    .current_distance(CURRENT_DISTANCE),
    .velocity(VELOCITY),
    .ignition_end(IGNITION_END),
    .height(HEIGHT),
    .noair_altitude(NOAIR_ALTITUDE),
    .stage_state(STAGESTATE),

    .print188km(PRINT188KM)
);

current_cal current_cal(
    .clk(CLK),
    .resetb(RESETB),
    .height(HEIGHT),
    .noair_altitude(NOAIR_ALTITUDE),
    .altitude_gimbal(ALTITUDE_GIMBAL),
    .distance_gimbal(DISTANCE_GIMBAL),
    .print188km(PRINT188KM),

    .current_altitude(CURRENT_ALTITUDE),
    .current_distance(CURRENT_DISTANCE)
);
wire [N-1:0] CURRENT_ALTITUDE;
wire [N-1:0] CURRENT_DISTANCE;

reg CLK;
reg RESETB;

initial begin
    CLK = 0;
    RESETB = 0;

    #50 RESETB = 1;

    #168_000 // 1st
    #360_000 // 2nd
    #165_000 // 3rd
    #335_000 // 3rd final
    #100_000
    $finish;
end

always begin
    #10 CLK <= ~CLK;
end

initial begin
    $dumpfile("output1.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb