module numericalIntegral #(
    parameter N = 64,
    parameter PERIOD  = 10,
    parameter SF = 10.0**-3.0
)(
    input wire clk,
    input wire resetb,
    input wire [N-1:0] signal_input,        // sampled signal this clock
    input wire start_integration,            // Start integration signal
    
    output reg [N-1:0] integral_result      // Result of the integral
);

// Internal signals and variables
reg [N-1:0] signal;
reg [N-1:0] next_signal;

// Trapezoidal Rule computation
always @(posedge clk or negedge ~resetb) begin
    next_signal <= signal_input;
    signal <= next_signal;
end

always @(posedge clk or negedge ~resetb) begin
    if (~resetb) begin
        integral_result <= 0;
    end
    else if (start_integration) begin
        // 입력신호가 소수 9자리고, 클럭이 ms니까 소수 12자리라서 보상해줘야 한다.
        integral_result <= integral_result + (PERIOD)*(signal+next_signal)*SF;
    end
end

initial
    integral_result = 0;
endmodule