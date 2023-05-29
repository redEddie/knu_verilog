module tb#(
    parameter PERIOD = 10,
    parameter N = 64,
    parameter GRAVITY = 9_799,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    // parameter SPECIFICIMPULSE_1 = 263,
    parameter SPECIFICIMPULSE_1 = 363,
    parameter SPECIFICIMPULSE_2 = 421,
    parameter SPECIFICIMPULSE_3 = 421,
    parameter WEIGHT_PROPELLANT_1 = 2077000,
    parameter WEIGHT_PROPELLANT_2 = 456100,
    parameter WEIGHT_PROPELLANT_3 = 39136, // 3단은 두번에 나눠 점화한다 => state 3, 4로 나눔.
    parameter WEIGHT_PROPELLANT_4 = 83864,
    // parameter BURNTIME_1 = 168,
    parameter BURNTIME_1 = 48,
    parameter BURNTIME_2 = 360,
    parameter BURNTIME_3 = 165,
    parameter BURNTIME_4 = 335,
    parameter WEIGHT_STAGE_1 = 137000,
    parameter WEIGHT_STAGE_2 = 40100,
    parameter WEIGHT_STAGE_3 = 15200,
    parameter LM = 15103,
    parameter CMSM = 11900 // command module and service module
);
// 어제 3 고친거처럼 angular velocity 전달하느거 다시 만듦면 된다.
// 시뮬레이션 시간단위 다르게 하면 고장난다.
getVelocity getVelocity_1(
    .velocity(DELIVER_VELOCITY),
    .afterWeight(AFTERWEIGHT),
    .specificImpulse(SPECIFICIMPULSE),   // 바뀌는 것
    .initialWeight(INITIALWEIGHT),  // 바뀌는 것
    .propellantWeight(WEIGHT_PROPELLANT), // 바뀌는 것
    .burntime(BURNTIME),    // 바뀌는 것
    .clk(CLK),
    .resetb(~STAGEMANAGER),
    .backward(BACKWARD),
    .ignition_end(DELIVER_IGNITION_END)
);
wire [63:0] AFTERWEIGHT;
wire DELIVER_IGNITION_END;
reg IGNITION_END;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        IGNITION_END <= 0;
    end
    else
        IGNITION_END <= DELIVER_IGNITION_END;
end
reg BACKWARD;
reg [63:0] SPECIFICIMPULSE;
reg [63:0] INITIALWEIGHT;
reg [63:0] WEIGHT_PROPELLANT;
reg [63:0] BURNTIME;
reg STAGEMANAGER;
reg [3:0] STAGESTATE;

wire [N-1:0] WEIGHTFORSTAGE1;
assign WEIGHTFORSTAGE1 = WEIGHT_PROPELLANT_1 + WEIGHT_PROPELLANT_2 + WEIGHT_PROPELLANT_3 + WEIGHT_PROPELLANT_4 + WEIGHT_STAGE_1 + WEIGHT_STAGE_2 + WEIGHT_STAGE_3 + LM + CMSM;
wire [N-1:0] WEIGHTFORSTAGE2;
assign WEIGHTFORSTAGE2 = WEIGHT_PROPELLANT_2 + WEIGHT_PROPELLANT_3 + WEIGHT_PROPELLANT_4 + WEIGHT_STAGE_2 + WEIGHT_STAGE_3 + LM + CMSM;
wire [N-1:0] WEIGHTFORSTAGE3;
assign WEIGHTFORSTAGE3 = WEIGHT_PROPELLANT_3 + WEIGHT_PROPELLANT_4+ WEIGHT_STAGE_3 + LM + CMSM;
wire [N-1:0] WEIGHTFORSTAGE4;
assign WEIGHTFORSTAGE4 = WEIGHT_PROPELLANT_4 + WEIGHT_STAGE_3 + LM + CMSM;

always @(posedge CLK or negedge RESETB) begin
    if ((~RESETB) || (IGNITION_END)) begin
        STAGEMANAGER <= 1;
    end
    else if (STAGEMANAGER == 1) begin
        STAGEMANAGER <= 0;
    end
    else
        STAGEMANAGER <= STAGEMANAGER;
end

always @(negedge STAGEMANAGER) begin
    if (~RESETB) begin
        STAGESTATE <= 0;
        $display("!!! ignition and liftoff !!!");
    end
    else if (STAGESTATE<3) begin
        STAGESTATE = STAGESTATE + 1;
    end
    else begin
        STAGESTATE <= STAGESTATE;
    end
end

always @(posedge CLK or negedge RESETB) begin
    if ((~RESETB) || (STAGEMANAGER)) begin
        IGNITION_END <= 0;
    end
end

always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        SPECIFICIMPULSE <= 0;
    end
    else if (STAGESTATE == 1) begin
        SPECIFICIMPULSE <= SPECIFICIMPULSE_1;
    end
    else if (STAGESTATE == 2) begin
        SPECIFICIMPULSE <= SPECIFICIMPULSE_2;
    end
    else if (STAGESTATE == 3) begin
        SPECIFICIMPULSE <= SPECIFICIMPULSE_3;
    end
    else if (STAGESTATE == 4) begin
        SPECIFICIMPULSE <= SPECIFICIMPULSE_3;
    end
    else
        SPECIFICIMPULSE <= SPECIFICIMPULSE;
end
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        INITIALWEIGHT <= 0;
    end
    else if (STAGESTATE == 1) begin
        INITIALWEIGHT <= WEIGHTFORSTAGE1;
    end
    else if (STAGESTATE == 2) begin
        INITIALWEIGHT <= WEIGHTFORSTAGE2;
    end
    else if (STAGESTATE == 3) begin
        INITIALWEIGHT <= WEIGHTFORSTAGE3;
    end
    else if (STAGESTATE == 4) begin
        INITIALWEIGHT <= WEIGHTFORSTAGE4;
    end
    else
        INITIALWEIGHT <= INITIALWEIGHT;
end
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        BURNTIME <= 1;
    end
    else if (STAGESTATE == 1) begin
        BURNTIME <= BURNTIME_1;
    end
    else if (STAGESTATE == 2) begin
        BURNTIME <= BURNTIME_2;
    end
    else if (STAGESTATE == 3) begin
        BURNTIME <= BURNTIME_3;
    end
    else if (STAGESTATE == 4) begin
        BURNTIME <= BURNTIME_4;
    end
    else
        BURNTIME <= BURNTIME;
end

always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        WEIGHT_PROPELLANT <= 0;
    end
    else if (STAGESTATE == 1) begin
        WEIGHT_PROPELLANT <= WEIGHT_PROPELLANT_1;
    end
    else if (STAGESTATE == 2) begin
        WEIGHT_PROPELLANT <= WEIGHT_PROPELLANT_2;
    end
    else if (STAGESTATE == 3) begin
        WEIGHT_PROPELLANT <= WEIGHT_PROPELLANT_3;
    end
    else if (STAGESTATE == 4) begin
        WEIGHT_PROPELLANT <= WEIGHT_PROPELLANT_4;
    end
    else
        WEIGHT_PROPELLANT <= WEIGHT_PROPELLANT;
end

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
    if (~RESETB) begin
        VELOCITY <= 0;
    end
    else begin
        VELOCITY <= DELIVER_VELOCITY;
    end
end

gimbal30km gimbal_1(
    .clk(CLK),
    .resetb(RESETB),
    .velocity(VELOCITY),
    .height(HEIGHT),
    .angularVelocity(DELIVER_ANGULER_VELOCITY),
    .noairAltitude(DELIVER_NOAIR_ALTITUDE),
    .noairDistance(DELIVER_NOAIR_DISTANCE),
    .gimbalEnable(GIMBALENABLE),
    .currentAltitude(CURRENTALTITUDE)
);
wire [N-1:0] DELIVER_NOAIR_ALTITUDE;
reg [N-1:0] NOAIR_ALTITUDE;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        NOAIR_ALTITUDE <= 0;
    end
    else begin
        NOAIR_ALTITUDE <= DELIVER_NOAIR_ALTITUDE;
    end
end
wire [N-1:0] DELIVER_NOAIR_DISTANCE;
reg [N-1:0] NOAIR_DISTANCE;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        NOAIR_ALTITUDE <= 0;
    end
    else begin
        NOAIR_DISTANCE <= DELIVER_NOAIR_DISTANCE;
    end
end

altitudeCalculator altitude_1(
    .altitude(ADDITIONALALTITUDE),
    .distance(DISTANCE),
    
    .clk(CLK),
    .resetb(RESETB),
    .noairAltitude(NOAIR_ALTITUDE),
    .noairDistance(NOAIR_DISTANCE),
    .angularVelocity(ANGULER_VELOCITY),
    .height(HEIGHT),
    .currentAltitude(CURRENTALTITUDE)
);

// velocity 관련 메모리


wire GIMBALENABLE;
reg CLK;
reg RESETB;

wire [N-1:0] DELIVER_ANGULER_VELOCITY;
reg [N-1:0] ANGULER_VELOCITY;
always @(posedge CLK or negedge RESETB) begin
    ANGULER_VELOCITY <= DELIVER_ANGULER_VELOCITY;
end

// integration 관련 메모리
reg START_INTEGRATION;

wire [N-1:0] HEIGHT;


// altitude calculator
wire [N-1 : 0] ADDITIONALALTITUDE;
wire [N-1 : 0] DISTANCE;

initial begin
    STAGEMANAGER = 0;
    BACKWARD = 0;

    RESETB = 0;
    CLK = 0;

    START_INTEGRATION = 0;
end

initial begin
        RESETB = 0;

    #50 RESETB = 1;
        START_INTEGRATION = 1;
end


reg [N-1:0] CURRENTALTITUDE;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        CURRENTALTITUDE <= 0;
    end
    else if (~GIMBALENABLE) begin
        CURRENTALTITUDE <= HEIGHT;
    end
    else if(NOAIR_ALTITUDE > 0) begin
        CURRENTALTITUDE <= NOAIR_ALTITUDE + ADDITIONALALTITUDE;
    end
end

reg [N-1:0] CURRENTDISTANCE;
reg [N-1:0] DISTANCEGIMBAL;
reg [N-1:0] MINUSHEIGHT;
always @(negedge GIMBALENABLE)
    DISTANCEGIMBAL <= DISTANCE;
always @(negedge GIMBALENABLE)
    MINUSHEIGHT <= HEIGHT;
always @(posedge CLK or negedge RESETB) begin
    if (MINUSHEIGHT > 0) 
        CURRENTDISTANCE <= DISTANCEGIMBAL + HEIGHT - MINUSHEIGHT;
end

// 
reg PRINT30KM;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        PRINT30KM <= 0;
    end
    else if ((~GIMBALENABLE) && (STAGESTATE == 1)) begin
        #1_000000 $display("시간 : %04ds", $time/1000000);
    end
    else if ((~PRINT30KM) && (STAGESTATE == 1)) begin
        #1_000000 $display("saturn V reached 30km height... @ %04ds", $time/1000000); 
        PRINT30KM <= 1;
        $display(">>> gimbal start...");
        $display(">>> current altitude : %f km", CURRENTALTITUDE*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF);
    end
    else if ( (STAGESTATE == 4'd1) && (IGNITION_END == 0)) begin
        #1_000000 $display("시간1 : %04ds", $time/1000000);
    end
    else if ( (STAGESTATE == 4'd1) && (IGNITION_END == 1) ) begin
        #1_000000 $display("1st stage about to detach... @ %04ds", $time/1000000);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", CURRENTALTITUDE*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF);
    end
    else begin
        #1_000000 $display("시간2 : %04ds", $time/1000000);
    end
end

initial begin
    #10_000000
    #48_000000
    // #168_000000 // 1st
    // #360_000000 // 2nd
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