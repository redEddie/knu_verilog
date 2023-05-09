module tb_testbench;

// led는 state에 비해 한 클럭 늦게 동작하는거 맞다. 어쩔 수 없음.

reg CLK, RESETB;
reg CAR0, CAR1;

wire [1:0] LED0;
wire [1:0] LED1;

traffic t1(
    .clk(CLK),
    .resetb(RESETB),
    .car0(CAR0),
    .car1(CAR1),
    .led0(LED0),
    .led1(LED1)
);

initial begin
    CLK     = 1'b0;
    RESETB  = 1'b0;
    CAR0 = 1'b0;
    CAR1 = 1'b0;

    $monitor($time, CLK,  RESETB, CAR0, LED0, CAR0, LED1);

    #`FTIME;
    $finish;
end

always begin
    #50 CLK = ~CLK; // 100ns period pulse
end

// test condition
initial begin
    #150 RESETB = 1'b1; // reset release
    CAR0 = 1'b1;
    CAR1 = 1'b0;    // S0
    
    #500;
    CAR0 = 1'b1;
    CAR1 = 1'b1;    // S0
    
    #500;
    CAR0 = 1'b0;
    CAR1 = 1'b1;    // S0 => S1 => S2

    #500;
    CAR0 = 1'b0;
    CAR1 = 1'b0;    // S2 => S3 => S0
    
    #500;
    CAR0 = 1'b0;
    CAR1 = 1'b1;    
    
    #500;
    CAR0 = 1'b0;
    CAR1 = 1'b0;    

end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);  
end


endmodule