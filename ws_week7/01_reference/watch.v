module watch(
    input           clk,
    input           resetb,
    input           enable,
    input           read,
    input           capture,
    output  [7:0]   duration
);


wire [7:0] count;
reg  [7:0] captured;
reg  [7:0] duration;


wire read_cnt;
assign read_cnt = read | capture;
counter cnt(
    .clk(clk),
    .resetb(resetb),
    .enable(enable),
    .read(read_cnt),
    .data(count)
);


always @ (negedge resetb or posedge clk)
    if(~resetb)
        captured <= 0;
    else if(capture)
        captured <= count;


always @ (negedge resetb or posedge clk)
    if(~resetb)
        duration <= 0;
    else if(read)
        duration <= count - captured;


endmodule
