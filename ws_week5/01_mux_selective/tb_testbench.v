`define COM1 // C언어에서와 동일하다. selective하게 설계.
// 아래에 모듈이름을 계속 바꿔줘야하므로 define을 사용해서 

// 원래 i/o 없다.
module tb_testbench;

reg A, B, SEL;
wire OUT;

`ifdef COM1
mux_2by1_wire dut1( // 변수이름이 같으면 안 된다. => define 사용
    .a(A),
    .b(B),
    .sel(SEL),
    .out(OUT)
);
`else
mux_2by1_reg dut1(
    .a(A),
    .b(B),
    .sel(SEL),
    .out(OUT)
);
`endif


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
    $dumpfile("tb_test_out.vcd");
    $dumpvars(0,dut1); // 이것 또한 고쳐야한다. => define사용
end

endmodule
