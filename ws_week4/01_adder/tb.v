// 원래 i/o 없다.
module tb;

wire [3:0] A;
// assign 으로 ref처럼 A를 고정할 수 도 있다.
assign A = 4'b1111;

adder dut1(
    // i/o를 지정할 때
    // input, output을 각각 지정해도 되고,
    // .a(A) 와 같이 지정해도 되고,
    // .a() 와 같이 지정해도 된다.
    .a(),
    .b(),
    .cout(),
    .sum()
);

initial begin

    #100
    A = 1'b1;
    B = 1'b0;
    SEL = 1'b0; //select a

    #100
    SEL = 1'b1; //select b
    
    #100
    A = 1'b0; 
    SEL = 1'b0;
    
    #20
    A = 1'b0; //continuously affect to a node
    
    #100
    $finish;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,dut1);
end

endmodule
