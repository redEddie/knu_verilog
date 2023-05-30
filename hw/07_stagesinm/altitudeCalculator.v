module altitudeCalculator #(
    parameter N = 64,
    parameter PIHALF = 1.546 * 10.0**3.0,
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter ANGLE30 = 30_000000,
    parameter TARGETALTITUDE = 188000 // 목표 높이 188km

)(
    output reg [N-1:0] fraction_Altitude,
    output reg [N-1:0] fraction_Distance,
    
    input clk,
    input resetb,
    input wire [N-1:0] noairAltitude,
    input wire [N-1:0] noairDistance,

    input wire [N-1:0] angularVelocity,
    input wire [N-1:0] height,
    input wire [N-1:0] fraction_height,
    input wire [N-1:0] current_Altitude
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

wire [7:0] index;
wire [N-1:0] angle;
reg [N-1:0] sine;
reg [N-1:0] cosine;

assign angle = (180_000*ISF*ISF - angularVelocity*SF)/2 - angle_accumulation; // 소수6자리까지
assign index = (angle*SF*SF/PIHALF)*256;

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        sine <= 0;
    end
    else if (noairAltitude> 0) begin
        sine <= SINE_ROM[index]*ISF*ISF/SINE_ROM[255]; // 사인값을 소수6자리까지 밯놘
    end
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        cosine <= 0;
    end
    else if (noairAltitude>0) begin
        cosine <= SINE_ROM[255-index]*ISF*ISF/SINE_ROM[255];
    end
end

always @(posedge clk or negedge resetb) begin
    fraction_Altitude <= fraction_height*SF*SF*sine;
    // height 소수 9자리. 사인 소수 6자리.
end
always @(posedge clk or negedge resetb) begin
    fraction_Distance <= fraction_height*SF*SF*cosine;
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