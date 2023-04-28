module tb_testbench;

reg CLK, RESETB;

wire MEAL, REQUEST;

kid k1(
    .clk     (CLK),
    .resetb  (RESETB),
    .meal    (MEAL),
    .request (REQUEST)
);

parent p1(
    .clk (CLK),
    .resetb (RESETB),
    .wakeup (REQUEST), // !!!!
    .food (MEAL) // !!!!
);


initial begin
    CLK     = 1'b0;
    RESETB  = 1'b0;
    // MEAL = 1'b0; 얘네는 설정하면 안 된담. wire라서
    // REQUEST = 1'b0;

    $monitor($time, CLK,  RESETB, MEAL, REQUEST);
    #`FTIME;
    $finish;
end


// test condition
initial begin
    #150 RESETB = 1'b1; // reset release
end


always begin
    #50 CLK = ~CLK; // 100ns period pulse
end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end


endmodule

