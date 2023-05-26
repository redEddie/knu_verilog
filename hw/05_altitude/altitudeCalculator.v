module altitudeCalculator #(
    parameter N = 64,
    parameter PERIOD = 10,
    parameter PIHALF = 1.546 * 10.0**3.0,
    parameter BIG_RADIAN = 400,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0
)(
    output reg [N-1:0] altitude,
    output reg [N-1:0] distance,
    
    input clk,
    input resetb,
    input wire [N-1:0] noairAltitude,
    input wire [N-1:0] noairDistance,
    input wire [N-1:0] angularVelocity
);

numericalIntegral cal_alt(
    .clk(clk),
    .resetb(resetb),
    .signal_input(fractionAltitude), // 64비트 크기로 줘야한다. 
    .start_integration(altitude_enable),
    .integral_result(deliver_altitude) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] deliver_altitude;
always @(posedge clk or negedge resetb) begin
    altitude <= deliver_altitude;
end

numericalIntegral cal_dist(
    .clk(clk),
    .resetb(resetb),
    .signal_input(fractionDistance), // 64비트 크기로 줘야한다. 
    .start_integration(distance_enable),
    .integral_result(deliver_distance) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] deliver_distance;
always @(posedge clk or negedge resetb) begin
    distance <= deliver_distance;
end

reg [15:0] SINE_ROM [0:255];
// 그냥 sine 소수4자리까지 0~1을 반환하므로 8비트이다.
// 얘가 잘 이해가 안 된다.
reg [15:0] ISINE_ROM [0:255];
// sine inverse는 소수 4자리까지 pi/2를 가져옴.
// 필요한건 더적은데 예쁜건 16이니까.

initial begin
    $display("Loading rom.");
    $readmemh("sine_table_256x16.mem", SINE_ROM);
    $readmemh("isine_table_256x16.mem", ISINE_ROM);
end

localparam targetAltitude = 188000; // 목표 높이 188km

// 30km에서 각도를 대충 37.228이라고 하자.


// 받아온 각속도는 64비트에 소수9자리까지 표시되어있다. 이제보니 새삼 복잡하네.
/* 
이런 각에 맞는 sin, cos을 찾아서 고도와 이동거리를 계산하려면
    1. 주어진 각을 어케 찾음?
        주어진 각을 잘 트림해서 0~255 사이의 숫자로 반환해야 한다.
        파이썬 코드에서 256숫자와 각도를 1대1 매칭했다.
        그걸 반대로 계산하는 회로를 짜야한다.
            수식적으로 보면 
    2. 불러온거에 l을 곱해(사실상 velocity*clock) 지금 클럭만큼 이동한 거리를 구한다.
*/
// 먼저 각속도를 trim하자. 지금 구한거는 소수9자리라서 lookup table 규격에 맞지 않을 뿐더러 너무 비트를 많이 차지한다.
reg [15:0] angle;
always @(posedge clk or negedge resetb) begin
    angle <= angularVelocity[28:6];
end

// 이제 받은 각도를 최소단위각도로 나누고 256을 곱하면! 0~255 중 하나로 줄꺼야. 아마도...
wire [7:0] index;
assign index = (angle/PIHALF)*256;

// 이렇게 인덱스가 완성되었다. 256곱하기 전 계산이 나머지를 날려먹으니까 angle안에 최소단위가 몇개 들어있는지 반환할거야 거기 256을 곱했으니 잘 되겠지.
// for altitude

reg [15:0] sine;
always @(posedge clk or negedge resetb) begin
    sine <= SINE_ROM[index];
end

reg [N-1:0] fractionAltitude;
always @(posedge clk or negedge resetb) begin
    fractionAltitude <= noairAltitude + BIG_RADIAN*sine*ISF*ISF*(10.0**2.0);
    // BIG_RADIAN이 10^3 배되어 있고, sine이 소수 4째자리까지 표현되어있으니까. 최종적으로 소수1자린데, noair~가 소수9자리니까..
    // 모자란 소수가 총 8자리니까 SF SF 하고 2승 더 해주면 되겠다.
    // 최종적으로 소수9자리까지 표시하는 고도가 완성되었다.
end

reg [15:0] cosine;
always @(posedge clk or negedge resetb) begin
    cosine <= SINE_ROM[255-index];
end
// 코사인은 반대론데... 256에서 빼면 되나? 그러겠지머.

reg [N-1:0] fractionDistance;
always @(posedge clk or negedge resetb) begin
    // distance <= noairDistance + BIG_RADIAN*cosine*ISF*ISF*(10.0**2.0);
    // 어차피 noairDis~가 0이잖아. 왜 더해주냐.
    fractionDistance <= BIG_RADIAN*cosine*ISF*ISF*(10.0**2.0);
end

reg altitude_enable;
reg distance_enable;
always @(posedge clk or negedge resetb) begin
    if (noairAltitude > 0) begin
        altitude_enable <= 1;
        distance_enable <= 1;
    end
end
endmodule