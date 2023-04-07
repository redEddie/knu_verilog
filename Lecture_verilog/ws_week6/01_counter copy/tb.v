// `timescale 1ns/1ps
// counter 2개가 1개의 data bus에 올라간걸 구현 => 다른 시간 대에 read하면 된다.

module tb;

// stimulus => 시간에 따라 바뀜 => reg로 설정
reg CLK;
reg RESET_B;
reg ENABLE1;
reg ENABLE2;
reg READ1;
reg READ2;
wire [7:0] DATA;

counter cnt1(
    .clk(CLK),
    .reset_b(RESET_B),
    .enable(ENABLE1),
    .read(READ1),
    .data(DATA)
);

counter cnt2(
    .clk(CLK),
    .reset_b(RESET_B),
    .enable(ENABLE2),
    .read(READ2),
    .data(DATA)
);

initial begin
    CLK     = 1'b0;
    RESET_B = 1'b0;
    ENABLE1  = 1'b0;
    READ1    = 1'b0;
    ENABLE2  = 1'b0;
    READ2    = 1'b0;

    #`FTIME
    $finish;
end

// 
initial begin
    #150 RESET_B    = 1'b1; // reset release
    #100 ENABLE1     = 1'b1; // 250ns from zero time
    #400 READ1       = 1'b1;
    #100 READ1       = 1'b0;
    #500 READ1       = 1'b1;
    #100 READ1       = 1'b0;
end

initial begin
    #150 RESET_B    = 1'b1; // reset release
    #200 ENABLE2     = 1'b1; // 250ns from zero time
    #700 READ2       = 1'b1;
    #100 READ2       = 1'b0;
    #100 READ2       = 1'b1; // unknown-x 나도록 같은 시간대에 read하기
    #100 READ2       = 1'b0;
end

always begin
    #50 CLK = ~CLK; // 100ns period pulse
end

initial begin
    $monitor("tick : %3d : reset_b : %b, enable : %b, read : %b, data : %b", $time, RESET_B, ENABLE1, READ1, DATA); 

end

initial begin
    $dumpfile("sim.vcd");
    // dumpfile로 모듈 하나말고 tb전체 볼 수 있다.
    $dumpvars(0,tb);
end

endmodule
