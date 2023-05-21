module testing (
    
);

wire signed [11:0] a = -64;  // 12-bit signed wire vector

initial begin
    $display("a is signed:   %d", a);
    $display("a is unsigned:  %d", a[11:0]);
    $display("a is signed:   %d", $signed(a[11:0]));
    $display("log(a):  %d", $clog2(a[11:0]));
    $display(a[11:0]);
end
endmodule //testing