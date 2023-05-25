module tb;

realTimeCalculator CAL1(
    .velocity(VELOCITY),
    .afterWeight(AFTERWEIGHT),
    .specificImpulse(SPECIFICIMPULSE),
    .initialWeight(INITIALWEIGHT),
    .propellentWeight(PROPELLENTWEIGHT),
    .burntime(BURNTIME),
    .clk(CLK),
    .resetb(RESETB)
);

wire [63:0] VELOCITY;
wire [63:0] AFTERWEIGHT;
    
reg [31:0] SPECIFICIMPULSE;
reg [31:0] INITIALWEIGHT;
reg [31:0] PROPELLENTWEIGHT;
reg [31:0] BURNTIME;
reg CLK;
reg RESETB;


localparam GRAVITY = 9_799;
localparam SF = 10.0**-3.0;
localparam ISF = 10.0**3.0; // 얘를 곱하면 소수 3째자리 계산하겠단 의미가 된다.

initial begin
    #10 
    RESETB = 0;
    CLK = 0;
    #10 
    RESETB = 1;
    #10
    SPECIFICIMPULSE = 263;
    INITIALWEIGHT = 3233500;
    PROPELLENTWEIGHT = 2077000;
    BURNTIME = 168;


    // $display("질량비 : %f", mu1);
    // $display("ln질량비? : %f", lnmu);
    // $display("질량비의 ln : %f", $ln(mu1)); // 질량비가 문제다. 이거 원래 1보다 작아 음수가 나오는데
    // $display("유효배출속도의 1e6 : %f", uprime);
    // $display("유효배출속도는 : %f", uprime * SF * SF);
    $display("중력가속도 1e3 : %f", GRAVITY);
    $display("중력가속도 : %f", GRAVITY*SF);
    $display("최종속도 : %f", $itor(VELOCITY*SF*SF*SF));
    // $display("최종속도 : %f, 질량비 : %f, 중력가속도 : %f", $itor(v1*SF), mu1, $itor(gravity * 10.0 ** -3.0));
    $finish;
end

always begin
    #10 CLK <= ~CLK;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb