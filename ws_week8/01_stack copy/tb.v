module tb_testbench;

reg         CLK, RESETB;


stack t1(
    .clk(CLK),
    .resetb(RESETB),
    .datain(DATAIN),
    .push(PUSH),
    .dataout(DATAOUT),
    .pop(POP),
    .full(FULL),
    .empty(EMPTY)
);

reg [7:0] DATAIN;
reg PUSH, POP;
wire [7:0] DATAOUT;
wire FULL, EMPTY;


initial begin // 초기화 구문
    CLK     = 1'b0;
    RESETB  = 1'b0;
    DATAIN = 0; PUSH = 0; POP = 0;

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

    #100 DATAIN = 10; PUSH = 1;
    #100 DATAIN = 20;
    #100 DATAIN = 30;
    #100 DATAIN = 40;
    #100 DATAIN = 50;
    #100 DATAIN = 60;
    #100 DATAIN = 70;
    #100 DATAIN = 80;
    #100 DATAIN = 90;
    #100 PUSH = 0;
    #100 POP = 1;
    // #100 POP = 0;
end




endmodule