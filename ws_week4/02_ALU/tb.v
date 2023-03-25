module tb;

reg [1:0] CMD;
reg [3:0] A;
reg [3:0] B;

wire [3:0] OUT;

ALU dut1(
    .cmd(CMD),
    .a(A),
    .b(B),
    .out(OUT)
);


initial begin 
    #100
    CMD = 2'b10; // cmd 4 add
    A = 4'h3;
    B = 4'h5;
    
    #100
    CMD = 2'b00;
    
    #100
    CMD = 2'b01;
    
    #100
    CMD = 2'b11;

    #100
    A = 4'hA;
    B = 4'h5;
end

initial begin
    $monitor($time, A, B); 
    #700;
    $finish;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,dut1);
end

endmodule
