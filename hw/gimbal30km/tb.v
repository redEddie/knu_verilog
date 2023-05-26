module tb#(
    parameter PERIOD = 10,
    parameter N = 64
);

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
    .height(INTEGRAL_RESULT)
    // .angularVelocity(ANGULER_VELOCITY),
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
reg [63:0] ANGULER_VELOCITY;
reg CLK;
reg RESETB;

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
    #1000000 $display("시간 : %f", elapsed);
end
/*
always @(*) begin
    $display("현재 속도 : %f", VELOCITY*SF*SF*SF);
    $display("현재 높이 : %f", INTEGRAL_RESULT);
end
*/
initial begin
    // #10_000000 $finish;
    #168_000000 $finish;
end

always begin
    #10 CLK <= ~CLK;
end

initial begin
    $dumpfile("output.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb