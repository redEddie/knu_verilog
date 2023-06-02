module stagemanager#(
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
)(
    input wire clk,
    input wire resetb,
    input wire ignition_end,

    output reg backward,
    output reg [N-1:0] specific_impulse,
    output reg [N-1:0] initial_weight,
    output reg [N-1:0] weight_propellant,
    output reg [N-1:0] burntime,
    output reg [3:0] stage,
    output reg stage_manager
);


wire [N-1:0] weight_for_stage1;
assign weight_for_stage1 = WEIGHT_PROPELLANT_1 + WEIGHT_PROPELLANT_2 + WEIGHT_PROPELLANT_3 + WEIGHT_PROPELLANT_4 + WEIGHT_STAGE_1 + WEIGHT_STAGE_2 + WEIGHT_STAGE_3 + LM + CMSM;
wire [N-1:0] weight_for_stage2;
assign weight_for_stage2 = WEIGHT_PROPELLANT_2 + WEIGHT_PROPELLANT_3 + WEIGHT_PROPELLANT_4 + WEIGHT_STAGE_2 + WEIGHT_STAGE_3 + LM + CMSM;
wire [N-1:0] weight_for_stage3;
assign weight_for_stage3 = WEIGHT_PROPELLANT_3 + WEIGHT_PROPELLANT_4+ WEIGHT_STAGE_3 + LM + CMSM;
wire [N-1:0] weight_for_stage4;
assign weight_for_stage4 = WEIGHT_PROPELLANT_4 + WEIGHT_STAGE_3 + LM + CMSM;


initial begin
    backward = 0;
    stage = 0;
end

always @(posedge clk or negedge resetb) begin
    if ((~resetb) || (ignition_end)) begin
        stage_manager <= 1;
    end
    else if (stage_manager == 1) begin
        stage_manager <= 0;
    end
    else
        stage_manager <= stage_manager;
end

always @(negedge stage_manager) begin
    if (~resetb) begin
        stage <= 0;
        $display("");
        $display("!!! ignition and liftoff !!!");
        $display("");
    end
    else if (stage <5) begin
        stage <= stage+1;
    end
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        specific_impulse <= 0;
    end
    else if (stage == 1) begin
        specific_impulse <= SPECIFICIMPULSE_1;
    end
    else if (stage == 2) begin
        specific_impulse <= SPECIFICIMPULSE_2;
    end
    else if (stage == 3) begin
        specific_impulse <= SPECIFICIMPULSE_3;
    end
    else if (stage == 4) begin
        specific_impulse <= SPECIFICIMPULSE_3;
    end
    else
        specific_impulse <= specific_impulse;
end
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        initial_weight <= 0;
    end
    else if (stage == 1) begin
        initial_weight <= weight_for_stage1;
    end
    else if (stage == 2) begin
        initial_weight <= weight_for_stage2;
    end
    else if (stage == 3) begin
        initial_weight <= weight_for_stage3;
    end
    else if (stage == 4) begin
        initial_weight <= weight_for_stage4;
    end
    else
        initial_weight <= initial_weight;
end
always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        burntime <= 1;
    end
    else if (stage == 1) begin
        burntime <= BURNTIME_1;
    end
    else if (stage == 2) begin
        burntime <= BURNTIME_2;
    end
    else if (stage == 3) begin
        burntime <= BURNTIME_3;
    end
    else if (stage == 4) begin
        burntime <= BURNTIME_4;
    end
    else
        burntime <= burntime;
end

always @(posedge clk or negedge resetb) begin
    if (~resetb) begin
        weight_propellant <= 0;
    end
    else if (stage == 1) begin
        weight_propellant <= WEIGHT_PROPELLANT_1;
    end
    else if (stage == 2) begin
        weight_propellant <= WEIGHT_PROPELLANT_2;
    end
    else if (stage == 3) begin
        weight_propellant <= WEIGHT_PROPELLANT_3;
    end
    else if (stage == 4) begin
        weight_propellant <= WEIGHT_PROPELLANT_4;
    end
    else
        weight_propellant <= weight_propellant;
end

endmodule //stagemanager