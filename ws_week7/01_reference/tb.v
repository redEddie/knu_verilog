module tb_testbench;


reg CLK, RESETB, ENABLE, CAPTURE, READ;
wire [7:0] DURATION;
watch wt(
    .clk     (CLK),
    .resetb  (RESETB),
    .enable  (ENABLE),
    .read    (READ),
    .capture (CAPTURE),
    .duration(DURATION)
);


initial begin
    CLK     = 1'b0;
    RESETB  = 1'b0;
    ENABLE  = 1'b0;
    READ    = 1'b0;
    CAPTURE = 1’b0;


    $monitor($time, CLK,  RESETB, ENABLE, READ);
    #`FTIME;
    $finish;
end


// test condition
initial begin
    #150 RESETB = 1'b1; // reset release
    #100 ENABLE = 1'b1; // 250ns from zero time


    #410 CAPTURE   = 1'b1;
    #110 CAPTURE   = 1'b0;


    #410 READ   = 1'b1;
    #110 READ   = 1'b0;


    #410 CAPTURE   = 1'b1;
    #110 CAPTURE   = 1'b0;


    #200;


    #410 READ   = 1'b1;
    #110 READ   = 1'b0;


end


always begin
    #50 CLK = ~CLK; // 100ns period pulse
end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end


endmodule
