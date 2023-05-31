module print #(
    parameter SF = 10.0**-3.0,
    parameter ISF = 10.0**3.0,
    parameter SCALE = 1000,
    parameter TARGETALTITUDE = 188,
    parameter N = 64
)(
    input wire clk,
    input wire resetb,

    input wire [N-1:0] current_altitude,
    input wire [N-1:0] current_distance,
    input wire [N-1:0] velocity,
    input wire ignition_end,
    input wire [N-1:0] height,
    input wire [N-1:0] noair_altitude,
    input wire [3:0] stage_state,

    output reg print188km
);
    
reg print30km;
reg stage_separate_1;
reg stage_separate_2;
reg stage_separate_3;
reg stage_separate_4;

initial begin
    print188km = 0;
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        print188km <= 0;
        print30km <= 0;
        stage_separate_1 <= 0;
        stage_separate_2 <= 0;
        stage_separate_3 <= 0;
        stage_separate_4 <= 0;
    end
    else if ((current_altitude > TARGETALTITUDE*ISF*ISF*ISF*ISF)&&(~print188km)) begin
        $display("saturn V reached 188km height... @ %04ds", $time/SCALE); 
        $display(">>> current altitude : %f km", current_altitude*SF*SF*SF*SF);
        $display(">>> current distance : %f km", current_distance*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", velocity*SF*SF*SF*SF);
        $display("");
        print188km <= 1;
        #1_000;
    end
    else if ((~print30km) && (noair_altitude > 5)) begin
        $display("saturn V reached 30km height... @ %04ds", $time/SCALE); 
        $display(">>> gimbal start...");
        $display(">>> current altitude : %f km", current_altitude*SF*SF*SF*SF);
        $display(">>> current distance : %f km", current_distance*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", velocity*SF*SF*SF*SF);
        $display("");
        print30km <= 1;
        #1_000;
    end
    else if ( (~stage_separate_1) && (stage_state == 4'd1) && (ignition_end) ) begin
        $display("1st stage about to detach... @ %04ds", $time/SCALE);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", current_altitude*SF*SF*SF*SF);
        $display(">>> current distance : %f km", current_distance*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", velocity*SF*SF*SF*SF);
        stage_separate_1 <= 1;
        $display("");

    end
    else if ( (~stage_separate_2) && (stage_state == 4'd2) && (ignition_end) ) begin
        $display("2nd stage about to detach... @ %04ds", $time/SCALE);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", current_altitude*SF*SF*SF*SF);
        $display(">>> current distance : %f km", current_distance*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", velocity*SF*SF*SF*SF);
        stage_separate_2 <= 1;
        $display("");

    end
    else if ( (~stage_separate_3) && (stage_state == 4'd3) && (ignition_end) ) begin
        $display("reached at LEO... @ %04ds", $time/SCALE);
        $display(">>> current altitude : %f km", current_altitude*SF*SF*SF*SF);
        $display(">>> current distance : %f km", current_distance*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", velocity*SF*SF*SF*SF);
        stage_separate_3 <= 1;
        $display("");

    end
    else if ( (~stage_separate_4) && (stage_state == 4'd4) && (ignition_end) ) begin
        $display("3rd stage about to detach... @ %04ds", $time/SCALE);
        $display(">>> detachment start...");
        $display(">>> current altitude : %f km", current_altitude*SF*SF*SF*SF);
        $display(">>> current distance : %f km", current_distance*SF*SF*SF*SF);
        $display(">>> current velocity : %f km/s", velocity*SF*SF*SF*SF);
        $display("");
        $display("trajectory length : %f km", height*SF*SF*SF*SF);
        stage_separate_4 <= 1;
        $display("");
    end
end
endmodule