// overflow test
// `timescale 1ns/1ps
// counter 2개가 1개의 data bus에 올라간걸 구현 => 다른 시간 대에 read하면 된다.

module tb;

// stimulus => 시간에 따라 바뀜 => reg로 설정
reg CLK;
reg RESET_B;
reg ENABLE1;
reg READ1;
wire [3:0] DATA;

counter cnt1(
    .clk(CLK),
    .reset_b(RESET_B),
    .enable(ENABLE1),
    .read(READ1),
    .data(DATA)
);


initial begin
    CLK     = 1'b0;
    RESET_B = 1'b0;
    ENABLE1  = 1'b0;
    READ1    = 1'b0;

    #`FTIME
    $finish;
end

// 
initial begin
    #15 RESET_B    = 1'b1; // reset release
    #10 ENABLE1     = 1'b1; // 250ns from zero time
    #40 READ1       = 1'b1;
end

always begin
    #5 CLK = ~CLK; // 100ns period pulse
end

initial begin
    $monitor("tick : %3d : reset_b : %b, enable : %b, read : %b, data : %b", $time, RESET_B, ENABLE1, READ1, DATA); 
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,tb);
end

endmodule
