module tb_testbench;

// 하나의 freq가 끝나기 전에 duty가 바뀜 => count무한 증가 => pduty 추가

reg         CLK, RESETB;
reg [7:0]   RANGE;

wire        PWM;

usonic t1(
    .clk(CLK),
    .resetb(RESETB),
    .range(RANGE),
    
    .pwm(PWM)
);


initial begin // 초기화 구문
    CLK     = 1'b0;
    RESETB  = 1'b0;
    RANGE = 8'b0;

    #`FTIME;
    $finish;
end

always begin // 100ns period pulse
    #50 CLK = ~CLK; 
end


initial begin // test condition
    #150 RESETB = 1'b1; // reset release
    #200 RANGE = 8'd50;
    #2000 RANGE = 8'd200;
    #2000 RANGE = 8'd10;
    #2000 RANGE = 8'd100;

end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end


endmodule