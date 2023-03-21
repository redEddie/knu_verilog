
// 원래 i/o 없다.
module tb_testbench;

reg A, B, SEL;
wire OUT;

mux_2by1_reg dut1(
    .a(A),
    .b(B),
    .sel(SEL),
    .out(OUT)
);

// check design function
initial begin

    #100
    A = 1'b1;
    B = 1'b0;
    SEL = 1'b0; //select a

    // A, B 는 유지된다. =continuous하다.
    #100
    SEL = 1'b1; //select b
    
    #100
    A = 1'b0; 
    SEL = 1'b0;
    
    #20
    A = 1'b1; //continuously affect to a node
    
    #100
    $finish;
end

initial begin
    $dumpfile("tb_test_out.vcd");
    $dumpvars(0,dut1);
end

endmodule
