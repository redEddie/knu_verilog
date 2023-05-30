module altitudeCalculator #(
    parameter N = 64,
    parameter PIHALF = 1_546,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter ANGLE30 = 10_000000000,
    parameter TARGETALTITUDE = 188000 // 목표 높이 188km

)(
    output reg [N-1:0] fraction_Altitude,
    output reg [N-1:0] fraction_Distance,
    
    input clk,
    input resetb,
    input wire [N-1:0] noairAltitude,
    input wire [N-1:0] noairDistance,

    input wire [N-1:0] velocity,
    input wire [N-1:0] angularVelocity,
    input wire [N-1:0] height,
    input wire [N-1:0] current_Altitude 
    // 여기서 current altitude를 받아오는게 fraction height보자 작다.
    // 뭔가 소수점이 틀렸을 것 같다. fraction height까지는 소수점 9자리까지 이다. 
);
reg enable;
always @(posedge clk or negedge resetb) begin
    if (noairAltitude == 0) begin
        enable <= 0;
    end
    else if (current_Altitude < TARGETALTITUDE*ISF*ISF*ISF ) begin
        enable <= 1;
    end
    else 
        enable <= 0;
end



reg [15:0] SINE_ROM [0:255];
reg [15:0] ISINE_ROM [0:255];

reg [N-1:0] angle_accumulation;
always @(posedge clk or negedge resetb) begin
    if (enable) begin
        angle_accumulation <= angle_accumulation + angularVelocity;
        // angularVelocity는 소수9자리까지 반환하고 있으므로 이를 맞추자. initial에서 했음.
    end
end

wire [N-1:0] angle;
wire [7:0] indexforsine;
wire [7:0] indexforcosine;
reg [N-1:0] sine;
reg [N-1:0] cosine;

assign angle = (180_000000000 - angularVelocity)/2 - angle_accumulation; // 소수9자리까지
assign indexforsine = (angle*SF*SF/90_000)*256;
assign indexforcosine = ((180_000000000 - angle)*SF*SF/90_000)*256;
// 우선 두개 소수 3자리로 맞추고 계산하면 비율로 소수가 없는데
// 다시 소수 3자리까지 나타내자.

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        sine <= 0;
    end
    else if (noairAltitude> 0) begin
        sine <= SINE_ROM[indexforsine]*ISF*ISF;
    end
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        cosine <= 0;
    end
    else if (noairAltitude>0) begin
        cosine <= SINE_ROM[indexforcosine]*ISF*ISF;
    end
end

always @(posedge clk or negedge resetb) begin
    fraction_Altitude <= velocity*sine*SF*SF;
end
always @(posedge clk or negedge resetb) begin
    fraction_Distance <= velocity*cosine*SF*SF;
end


initial begin
    angle_accumulation = ANGLE30;
    $display("Loading rom.");
    $readmemh("sine_table_256x16.mem", SINE_ROM);
    if (SINE_ROM[0] != 0) begin
       $display("Loaded sine table");
    end
    $readmemh("isine_table_256x16.mem", ISINE_ROM);
end
endmodule