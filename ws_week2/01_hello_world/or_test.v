module or_test (t1, t2, p);

output t1, t2;
input  p;

reg     t1, t2;
wire    p;

initial begin
    t1 <= 1'b0;
    t2 <= 1'b0;

    #100;
    t1 <= 1'b0;
    t2 <= 1'b1;

    #100;
    t1 <= 1'b1;
    t2 <= 1'b0;

    #100;
    t1 <= 1'b1;
    t2 <= 1'b1;

    #100
    $finish;
end


always @ ( t1, t2, p )
begin
    $display("%b %b %b", t1, t2, p); 
end

endmodule


