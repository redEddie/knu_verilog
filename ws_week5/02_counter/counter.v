module counter(
    input clk,
    input reset_b,
    input enable,
    input read,
    output [7:0] data,
);

reg [7:0] count;
// FF으로 설계된.(negedge, posedge)
always @(negedge reset_b or posedge clk) // negative edge에서~
    if(~reset_b)
        count <= 8'b0; // 0을 7개 채우면 부족해서 error인건 알겠는데, 0말고 11넣으면 3으로 보는지 11로 볼지.
    else if(a == 1)
        count <= count + 1;
endmodule
// 다음시간에 이어서.