module tb_testbench;

reg CLK, RESETB;

wire MEAL, REQUEST, BOOK;

kid k1(
    .clk     (CLK),
    .resetb  (RESETB),
    .meal    (MEAL),
    .book    (BOOK),
    .request (REQUEST)
);

parent p1(
    .clk (CLK),
    .resetb (RESETB),
    .wakeup (REQUEST), 
    .food (MEAL),
    .book (BOOK)
);


initial begin
    CLK     = 1'b0;
    RESETB  = 1'b0;

    $monitor($time, CLK, RESETB, "REQUEST : %b, MEAL : %b, BOOK : %b", REQUEST, MEAL, BOOK); 
    #`FTIME;
    $finish;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end

always begin
    #50 CLK = ~CLK; // 100ns period pulse
end

// test condition
initial begin
    #500 RESETB = 1'b1; // reset release
    #300 RESETB = 1'b0;
    #200 RESETB = 1'b1;
end


endmodule

