module tb_testbench;


reg CLK, RESET_B, ENABLE, CAPTURE, READ;
wire [7:0] DURATION;
watch wt(
    .clk     (CLK),
    .reset_b  (RESET_B),
    .enable  (ENABLE),
    .read    (READ),
    .capture (CAPTURE),
    .duration(DURATION)
);


initial begin
    CLK     = 1'b0;
    RESET_B  = 1'b0;
    ENABLE  = 1'b0;
    READ    = 1'b0;
    CAPTURE = 1'b0; // !!!! 초기화해야 정보를 잘 받는다.

    $monitor($time, CLK,  RESET_B, ENABLE, READ);
    #`FTIME;
    $finish;
end


// test condition
initial begin
    #150 RESET_B = 1'b1; // reset release
    #100 ENABLE = 1'b1; // 250ns from zero time

    #100 CAPTURE = 1'b1;

    #410 READ   = 1'b1;
    #410 READ   = 1'b0;
    #410 READ   = 1'b1;
    #110 READ   = 1'b0;
    
    #100

    #410 CAPTURE   = 1'b1;
    #410 CAPTURE   = 1'b0;

    #200

    #410 READ   = 1'b1;
    #110 READ   = 1'b0;

/*
setup margin, hold margin이 없으면 violation 발생.
근데 이러면 40ns밀리는거 아닌가...?
    #400 READ   = 1'b1;
    #400 READ   = 1'b0;
    #400 READ   = 1'b1;
    #100 READ   = 1'b0;
*/
end


always begin
    #50 CLK = ~CLK; // 100ns period pulse
end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end


endmodule

