
module tb_testbench;

reg A, B, SEL;
wire OUT;


mux_2by1 dut1( // 변수이름이 같으면 안 된다. => define 사용
    .a(A),
    .b(B),
    .sel(SEL),
    .out(OUT)
);

initial begin

    #100
    A = 1'b1;
    B = 1'b0;
    SEL = 1'b0;

    #100
    SEL = 1'b1; 
    
    #100
    A = 1'b0; 
    SEL = 1'b0;
    
    #20
    A = 1'b1;
    
    #100
    $finish;
end

initial begin 
    $monitor("tick : %4d | A = %b B = %b SEL = %b OUT = %b", $time, A, B, SEL, OUT);
end

initial begin
    $dumpfile("tb_test_out.vcd");
    $dumpvars(0,dut1); // 이것 또한 고쳐야한다. => define사용
end

endmodule
