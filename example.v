
module MyModule(input a, input b, output y);
  assign y = a & b;
endmodule

module AnotherModule(input x, output z);
  assign z = ~x;
endmodule
