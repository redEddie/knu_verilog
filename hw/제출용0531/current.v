module current_cal #(
    parameter N  = 64
)(
    input wire clk,
    input wire resetb,

    input wire [N-1:0] height,
    input wire [N-1:0] noair_altitude,
    input wire [N-1:0] altitude_gimbal,
    input wire [N-1:0] distance_gimbal,
    input wire print188km,
    
    output reg [N-1:0] current_altitude,
    output reg [N-1:0] current_distance
);
    
reg [N-1:0] height188;

initial begin
    height188 = 0;
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        current_altitude <= 0;
    end
    else if (noair_altitude == 0) begin
        current_altitude <= height;
    end
    else if((noair_altitude > 0)&&(~print188km)) begin
        current_altitude <= noair_altitude + altitude_gimbal;
    end
        // noair altitude 는 소수 9자리다
        // altitude gimbal 도 소수 9자린데 뭐가 문제지
end

always @(posedge print188km)begin
    height188 <= height;
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        current_distance <= 0;
    end
    else if ((noair_altitude > 0)&&(~print188km)) begin
        current_distance <= distance_gimbal;
    end
    else if (print188km) 
        current_distance <= distance_gimbal + height - height188;
end


endmodule