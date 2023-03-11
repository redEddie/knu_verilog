`timescale 1ns/1ps

module tb_testbench;
    wire n1, n2, n3;

    or_test tester  (n1, n2, n3);
    //               |   |    ^
    //               V   V    |   
    or_gate dut     (n1, n2, n3);

    initial
    begin
        $dumpfile("tb_test_out.vcd");
        $dumpvars(0,dut);  
        //$monitor("%b %b %b", n1,n2,n3);
    end

endmodule
