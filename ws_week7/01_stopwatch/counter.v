module counter(
    input clk,
    input reset_b,
    input enable,
    input read,
    output [7:0] data
);

reg [7:0] count;
reg [7:0] ref_count;

assign data = read ? count : 8'bz;


always @(negedge reset_b or posedge clk)
    if(~reset_b)
        count <= 8'b0; 
    else if(enable == 1'b1)
        count <= count + 1;

always @(negedge reset_b or posedge clk)
    if(~reset_b)
        ref_count <= 8'b0; 
    else
        ref_count <= ref_count + 1;
endmodule

