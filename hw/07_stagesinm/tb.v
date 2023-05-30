module tb#(
    parameter TARGETALTITUDE = 188, // 원랜 188인데 도달하기 불가능
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
// 어제 3 고친거처럼 angular velocity 전달하느거 다시 만듦면 된다.
// 시뮬레이션 시간단위 다르게 하면 고장난다.
getVelocity getVelocity_1(
    .velocity(DELIVER_VELOCITY), // m/s로 소수 9자리
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
    else begin
        STAGESTATE <= STAGESTATE+1;
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

    .integral_result(HEIGHT),                   // m단위로 소수 9자리
    .fraction_result(FRACTION_HEIGHT)
);
reg START_INTEGRATION;

wire [N-1:0] HEIGHT;
wire [N-1:0] FRACTION_HEIGHT;
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
    .fraction_height(FRACTION_HEIGHT),
    .current_Altitude(CURRENT_ALTITUDE),

    .angularVelocity(DELIVER_ANGULER_VELOCITY),
    .noairAltitude(DELIVER_NOAIR_ALTITUDE),
    .noairDistance(DELIVER_NOAIR_DISTANCE),
    .gimbalEnable(GIMBALENABLE)
);
wire GIMBALENABLE;
wire [N-1:0] DELIVER_NOAIR_ALTITUDE;
wire [N-1:0] DELIVER_NOAIR_DISTANCE;
reg [N-1:0] NOAIR_ALTITUDE;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        NOAIR_ALTITUDE <= 0;
    end
    else begin
        NOAIR_ALTITUDE <= DELIVER_NOAIR_ALTITUDE;
    end
end
reg [N-1:0] NOAIR_DISTANCE;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        NOAIR_ALTITUDE <= 0;
    end
    else begin
        NOAIR_DISTANCE <= DELIVER_NOAIR_DISTANCE;
    end
end
wire [N-1:0] DELIVER_ANGULER_VELOCITY;
reg [N-1:0] ANGULER_VELOCITY;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB)
        ANGULER_VELOCITY <= 0;
    else
        ANGULER_VELOCITY <= DELIVER_ANGULER_VELOCITY;
end

altitudeCalculator altitude_1(
    .fraction_Altitude(FRACTION_ALTITUDE),
    .fraction_Distance(FRACTION_DISTANCE),
    
    .clk(CLK),
    .resetb(RESETB),
    .noairAltitude(NOAIR_ALTITUDE),
    .noairDistance(NOAIR_DISTANCE),

    .angularVelocity(ANGULER_VELOCITY),
    .height(HEIGHT),
    .fraction_height(FRACTION_HEIGHT),
    .current_Altitude(CURRENT_ALTITUDE)
);
wire [N-1:0] FRACTION_ALTITUDE;
wire [N-1:0] FRACTION_DISTANCE;
reg [N-1:0] DELIVER_FRACTION_ALTITUDE;
reg [N-1:0] DELIVER_FRACTION_DISTACNCE;
always @(posedge CLK or negedge RESETB) begin
    DELIVER_FRACTION_ALTITUDE <= FRACTION_ALTITUDE;
    DELIVER_FRACTION_DISTACNCE <= FRACTION_DISTANCE;
end
// 각도 계산기 소수 6자리인데, 적분기계에는 소수 9자리넣어야함.시발 이걸 몰랐다니
numericalIntegral cal_alt(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(DELIVER_FRACTION_ALTITUDE), // 64비트 크기로 줘야한다. 
    .start_integration(1'b1),

    .integral_result(ALTITUDE_GIMBAL) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] ALTITUDE_GIMBAL;

numericalIntegral cal_dist(
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(DELIVER_FRACTION_DISTACNCE), // 64비트 크기로 줘야한다. 
    .start_integration(1'b1),

    .integral_result(DISTNACE_GIMBAL) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] DISTNACE_GIMBAL;

reg [N-1:0] CURRENT_ALTITUDE;
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        CURRENT_ALTITUDE <= 0;
    end
    else if (NOAIR_ALTITUDE == 0) begin
        CURRENT_ALTITUDE <= HEIGHT;
    end
    else if((NOAIR_ALTITUDE > 0)&&(~PRINT188KM)) begin
        CURRENT_ALTITUDE <= NOAIR_ALTITUDE + ALTITUDE_GIMBAL;
    end
    else if(PRINT188KM)
        CURRENT_ALTITUDE <= NOAIR_ALTITUDE + ALTITUDE_GIMBAL;
end

reg [N-1:0] CURRENTDISTANCE;
reg [N-1:0] HEIGHT188;
always @(posedge PRINT188KM)begin
    HEIGHT188 <= HEIGHT;
end
always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        CURRENTDISTANCE <= 0;
    end
    else if (NOAIR_ALTITUDE > 0) begin
        CURRENTDISTANCE <= DISTNACE_GIMBAL;
    end
    else if (HEIGHT188 > 0) 
        CURRENTDISTANCE <= DISTNACE_GIMBAL + HEIGHT - HEIGHT188;
end


reg CLK;
reg RESETB;
// 
reg PRINT30KM;
reg PRINT188KM;
reg STAGESEPARATE_1;
reg STAGESEPARATE_2;
reg STAGESEPARATE_3;
reg STAGESEPARATE_4;

always @(posedge CLK or negedge RESETB) begin
    if (~RESETB) begin
        PRINT188KM <= 0;
        PRINT30KM <= 0;
        STAGESEPARATE_1 <= 0;
        STAGESEPARATE_2 <= 0;
        STAGESEPARATE_3 <= 0;
        STAGESEPARATE_4 <= 0;
    end
    else if ((CURRENT_ALTITUDE > TARGETALTITUDE*ISF*ISF*ISF*ISF)&&(~PRINT188KM)) begin
        $display("saturn V reached 188km height... @ %04ds", $time/SCALE); 
        $display(">>> current altitude : %f km", CURRENT_ALTITUDE*SF*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF*SF);
        PRINT188KM <= 1;
        #1_000;
    end
        
    else if ((~GIMBALENABLE) && (STAGESTATE == 4'd1)) begin
        $display("시간 : %04ds", $time/SCALE);
        #1_000; 
    end
    else if ((~PRINT30KM) && (STAGESTATE == 4'd1)) begin
        $display("saturn V reached 30km height... @ %04ds", $time/SCALE); 
        PRINT30KM <= 1;
        $display(">>> gimbal start...");
        $display(">>> current altitude : %f km", CURRENT_ALTITUDE*SF*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF*SF);
        #1_000;
    end

    // 와... 이거 초랑 같이 나타내는거 어렵네 안 해야지
    else if ( (~STAGESEPARATE_1) && (STAGESTATE == 4'd1) && (IGNITION_END) ) begin
        $display("1st stage about to detach... @ %04ds", $time/SCALE);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", CURRENT_ALTITUDE*SF*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF*SF);
        STAGESEPARATE_1 <= 1;
    end
    else if ( (~STAGESEPARATE_2) && (STAGESTATE == 4'd2) && (IGNITION_END) ) begin
        $display("2nd stage about to detach... @ %04ds", $time/SCALE);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", CURRENT_ALTITUDE*SF*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF*SF);
        STAGESEPARATE_2 <= 1;
    end
    else if ( (~STAGESEPARATE_3) && (STAGESTATE == 4'd3) && (IGNITION_END) ) begin
        $display("reached at LEO... @ %04ds", $time/SCALE);
        $display(">>> current altitude : %f km", CURRENT_ALTITUDE*SF*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF*SF);
        STAGESEPARATE_3 <= 1;
    end
    else if ( (~STAGESEPARATE_4) && (STAGESTATE == 4'd4) && (IGNITION_END) ) begin
        $display("3rd stage about to detach... @ %04ds", $time/SCALE);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", CURRENT_ALTITUDE*SF*SF*SF*SF);
        $display(">>> current distance : %f km", CURRENTDISTANCE*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", VELOCITY*SF*SF*SF*SF);
        STAGESEPARATE_4 <= 1;
    end
end

initial begin
    // #10_000
    // #48_000
    #168_000 // 1st
    #360_000 // 2nd
    #165_000 // 3rd
    #335_000 // 3rd final
    #100_000
    $finish;
end

initial begin
    STAGEMANAGER = 0;
    BACKWARD = 0;

    RESETB = 0;
    CLK = 0;

    START_INTEGRATION = 0;
    HEIGHT188 = 0;
    RESETB = 0;

    #50 RESETB = 1;
        START_INTEGRATION = 1;
end

always begin
    #10 CLK <= ~CLK;
end

initial begin
    $dumpfile("output1.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb