module test(output [31:0] a, b, c);
  assign a = 1000 * $ln(123);
  assign b = 1000 * $log10(123);
  assign c = 1000 * $clog2(123);

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,test);
end
endmodule


function bit [31:0] log_base_2 (bit [31:0] log_input);
  bit [31:0] input_copy;
  bit [31:0] log_out = 0;
  input_copy = log_input;

  while(input_copy > 0)begin
    input_copy = input_copy >> 1;
    log_out = log_out + 1;
  end
  log_out = log_out - 1;

  if(log_input != (1 << log_out))
    log_out = log_out + 1;

  return log_out;
endfunction