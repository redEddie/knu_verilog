module tb_testbench;

reg CLK, RESETB;
reg PEN;
reg [3:0] DUTY;
reg [3:0] FREQ;

wire PWM;

pwm t1(
    .clk(CLK),
    .resetb(RESETB),
    .pen(PEN),
    .duty(DUTY),
    .freq(FREQ),

    .pwm(PWM)
);


initial begin // 초기화 구문
    CLK     = 1'b0;
    RESETB  = 1'b0;
    PEN = 1'b0;
    DUTY = 4'b110;
    FREQ = 4'b1000;

    #`FTIME;
    $finish;
end

always begin // 100ns period pulse
    #50 CLK = ~CLK; 
end


initial begin // test condition
    #150 RESETB = 1'b1; // reset release
    #200 PEN = 1'b1;

end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end


endmodule