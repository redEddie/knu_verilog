module tb_testbench;

reg CLK, RESETB;
wire OUT;

LFSR t1(
    .clk(CLK),
    .resetb(RESETB),
    .out(OUT)
);


initial begin // 초기화 구문
    CLK     = 1'b0;
    RESETB  = 1'b0;

    #`FTIME;
    $finish;
end

always begin // 100ns period pulse
    #50 CLK = ~CLK; 
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end

initial begin // test condition

    #100 RESETB = 1'b1; // reset release

end




endmodule