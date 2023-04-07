// `define set 1
`define reset 0

module tb();

reg A;
wire Out;

give_a dut1(
    .a(A),
    .out(OUT)
);


initial begin

    A = `reset;
    #10
    A = `set;

    #10
    A = `reset;

    #10
    A = `set; 
    
    #20
    A = 1'b0;
    
    #10
    $finish;
end

initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,dut1);
end

endmodule