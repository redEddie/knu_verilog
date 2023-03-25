module tb;

reg [1:0] CMD;
reg [3:0] A;
reg [3:0] B;

wire [3:0] OUT;

ALU dut1(
    .cmd(),
    .a(A),
    .b(B),
    .out()
);


initial begin 

    #100
    A = 4'b0001; 
    B = 4'b0010; 

    #100
    A = 4'b0000;
    B = 4'b0000;
end

initial begin
    #150;
    A = 4'b0101;
    B = 4'b1010;
end

initial begin
    $monitor($time, A, B); 
    #500;
    $finish;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,dut1);
end

endmodule
