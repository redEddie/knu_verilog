/*
지금 integration 신호가 0us에서부터 1임. 고치고,
근데 이게 fraction 정보가 gimbal enable 이전까지 0이라서 신호는 정상적으로 나온다.
    => noairaltitude 가 enable을 설정해야하는데 input으로 받아오는거라 tb에서 문제인듯
    => gimbal 쪽에서 initial하지 않아 문제 발생하였다. initial에 추가함으로써 해결함.

이거 고치고나면
각속도 계산을 제대로 하자. 33도 정도 미리 더해야함.
    => angle부분. 역시 여기서 이상했군. 소수점 밑6개를 버린다는게 비트6개를 버려서 문제가 발생했다. [:] 대신 SF를 쓴다.
아ㅏ.. 각도계산 만들기 고통스러워
*/

module altitudeCalculator #(
    parameter N = 64,
    parameter PERIOD = 10,
    parameter PIHALF = 1.546 * 10.0**3.0,
    parameter BIG_RADIAN = 400,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter ANGLE30 = 37_228841880,
    parameter TARGETALTITUDE = 188000 // 목표 높이 188km

)(
    output reg [N-1:0] altitude,
    output reg [N-1:0] distance,
    
    input clk,
    input resetb,
    input wire [N-1:0] noairAltitude,
    input wire [N-1:0] noairDistance,
    input wire [N-1:0] angularVelocity,
    input wire [N-1:0] velocity,
    input wire [N-1:0] currentAltitude
);

reg [N-1:0] minusvelocity;
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        minusvelocity <= 0;
    end
    else begin
        minusvelocity <= velocity;
    end
end
reg [N-1:0] fractiontraveled;
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        fractiontraveled <= 0;
    end
    else begin
        fractiontraveled <= (PERIOD+PERIOD)*(velocity+minusvelocity)*0.5;
    end
end
numericalIntegral cal_alt(
    .clk(clk),
    .resetb(resetb),
    .signal_input(fractionAltitude), // 64비트 크기로 줘야한다. 
    .start_integration(altitude_enable),
    .integral_result(deliver_altitude) // 얘도 64비트로 받아야 한다.
);
wire [N-1:0] deliver_altitude;
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        altitude <= 0;
    end
    if (altitude_enable)
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
    if (~resetb) begin
        distance <= 0;
    end
    else if (distance_enable)
        distance <= deliver_distance;
end

reg [15:0] SINE_ROM [0:255];
// 그냥 sine 소수4자리까지 0~1을 반환하므로 8비트이다.
// 얘가 잘 이해가 안 된다.
reg [15:0] ISINE_ROM [0:255];
// sine inverse는 소수 4자리까지 pi/2를 가져옴.
// 필요한건 더적은데 예쁜건 16이니까.



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
reg [15:0] angle_now;
always @(posedge clk or negedge resetb) begin
    angle_now <= angularVelocity*SF*SF;
    // 역시 여기서 이상했군. 소수점 밑6개를 버린다는게 비트로 해버려서 문제가 발생했으니.
    // SF를 사용해 소수점을 버리자. 총 소수3자리까지 반환.
end

reg [15:0] angle_accumulation;
always @(posedge clk or negedge resetb) begin
    if (altitude_enable) begin
        angle_accumulation <= angle_accumulation + angularVelocity;
        // angularVelocity는 소수9자리까지 반환하고 있으므로 이를 맞추자. initial에서 했음.
    end
end


// 이제 받은 각도를 최소단위각도로 나누고 256을 곱하면! 0~255 중 하나로 줄꺼야. 아마도...
wire [7:0] index;
wire [15:0] angle;
assign angle = (180_000 - angle_now)/2 - angle_accumulation*SF*SF;
// assign index = 255;
assign index = (angle/PIHALF)*256;

// 이렇게 인덱스가 완성되었다. 256곱하기 전 계산이 나머지를 날려먹으니까 angle안에 최소단위가 몇개 들어있는지 반환할거야 거기 256을 곱했으니 잘 되겠지.
// 소수점 때문에 이상하게 돌아가는 거 같아. 
// for altitude
reg [N-1:0] sine;
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        sine <= 0;
    end
    else if (altitude_enable) begin
        sine <= SINE_ROM[index]*ISF*ISF/SINE_ROM[255]; // 사인값을 소수6자리까지 밯놘
    end
end

reg [N-1:0] cosine;
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        cosine <= 0;
    end
    else if (distance_enable) begin
        cosine <= SINE_ROM[255-index]*ISF*ISF/SINE_ROM[255];
    end
end
// 코사인은 반대론데... 256에서 빼면 되나? 그러겠지머.

reg [N-1:0] fractionAltitude;
always @(posedge clk or negedge resetb) begin
    fractionAltitude <= fractiontraveled*sine*SF**SF;
    // sine : 소수 6째자리, height : 소수 9째자리 => 곱했을 때 15자리. 근데 9자리 원하니까 뒷 6자리 날려야함.
end

reg [N-1:0] fractionDistance;
always @(posedge clk or negedge resetb) begin
    fractionDistance <= fractiontraveled*cosine*SF*SF;
end

reg altitude_enable;
reg distance_enable;
always @(posedge clk or negedge resetb) begin
    if (noairAltitude == 0) begin
        altitude_enable <= 0;
    end
    else if (currentAltitude < TARGETALTITUDE*ISF*ISF*ISF ) begin
        altitude_enable <= 1;
    end
    else 
        altitude_enable <= 0;
end

always @(posedge clk or negedge resetb) begin
    if ((noairAltitude == 0)) begin
        distance_enable <= 0;
    end
    else if (currentAltitude < TARGETALTITUDE*ISF*ISF*ISF ) begin
        distance_enable <= 1;
    end
    else
        distance_enable <= 0;
end

initial begin
    angle_accumulation = ANGLE30;
    altitude_enable = 0;
    distance_enable = 0;
    $display("Loading rom.");
    $readmemh("sine_table_256x16.mem", SINE_ROM);
    if (SINE_ROM[0] != 0) begin
       $display("Loaded sine table");
    end
    $readmemh("isine_table_256x16.mem", ISINE_ROM);
end

endmodule