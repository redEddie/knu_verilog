module test(output [31:0] a, b, c);
  assign a = 1000 * $ln(123);
  assign b = 1000 * $log10(123);
  assign c = 1000 * $clog2(123);

initial begin
    $dumpfile("sim2.vcd");
    $dumpvars(0, test);  
end
endmodule