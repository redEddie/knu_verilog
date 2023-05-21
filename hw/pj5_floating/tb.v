module tb;

numericalIntegral inte(
    .test(TEST),
    .clk(CLK),
    .resetb(RESETB),
    .signal_input(SIGNAL_INPUT),
    .start_integration(START_INTEGRATION),
    .integral_result(INTEGRAL_RESULT)
);

reg [3:0] TEST;

reg CLK, RESETB;
reg [`N-1:0] SIGNAL_INPUT;
reg START_INTEGRATION;

wire [`N-1:0] INTEGRAL_RESULT;

initial begin
    #100 RESETB = 1'b1;
        
    #150 SIGNAL_INPUT = 2;
    #150 SIGNAL_INPUT = 4;
    #150 SIGNAL_INPUT = 6;
    #150 SIGNAL_INPUT = 8;
    #150 SIGNAL_INPUT = 10;
        
    #100 START_INTEGRATION = 1;

    #150 SIGNAL_INPUT = 2;
    #150 SIGNAL_INPUT = 4;
    #150 SIGNAL_INPUT = 6;
    #150 SIGNAL_INPUT = 8;
    #150 SIGNAL_INPUT = 10;
    #150 SIGNAL_INPUT = 10;
    #150 SIGNAL_INPUT = 10;
    #150 SIGNAL_INPUT = 10;

end

always begin
    #`CLOCK CLK = ~CLK;

end

initial begin
    CLK = 1'b0;
    RESETB  = 1'b0;
    SIGNAL_INPUT = 0;
    START_INTEGRATION = 0;

    #2000 $finish;
end

initial begin
    #10 TEST = 0;
    #10 TEST = 1;
    #10 TEST = 2;
    #10 TEST = 5;
    #10 TEST = 7;
    #10 TEST = 14;
    #10 TEST = 16;

end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb);  
end

endmodule //tb