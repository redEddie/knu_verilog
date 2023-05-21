`define N 64
`define CLOCK 5                             // 클럭 10ns 라고 생각하자. 계산이므로 샘플링을 많이 할수록 정확하다.

module numericalIntegral (
    input wire [3:0] test,
    input wire clk,
    input wire resetb,
    input wire [`N-1:0] signal_input,        // sampled signal this clock
    input wire start_integration,            // Start integration signal
    output reg [`N-1:0] integral_result      // Result of the integral
);

// Internal signals and variables
reg [`N-1:0] signal;
reg [`N-1:0] next_signal;

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
        integral_result <= integral_result + (`CLOCK+`CLOCK)*(signal+next_signal)*0.5;
    end
end



endmodule