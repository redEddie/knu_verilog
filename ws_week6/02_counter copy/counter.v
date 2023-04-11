/* 
수업시간 칠판
https://docs.google.com/document/d/1pqUUXyV-446H0wwRoOOWJEajvgDLcEONUzW6a7cfHFk/edit
*/
module counter(
    input clk,
    input reset_b,
    input enable,
    input read,
    output [7:0] data
);

reg [7:0] count;
// wire [7:0] data;

assign data = read ? count : 8'bz;

// FF으로 설계된.(negedge, posedge)
always @(negedge reset_b or posedge clk)
    if(~reset_b)
        // 실제로는 8bits의 flip-flop이 전체적으로 초기화 되기 충분한 시간이 필요하다. setup margin, setup violation(불완전한 데이터가 전달되는 것)
        count <= 8'b0; 
    else if(enable)
        count <= count + 1;
endmodule

// <= nonblocking : 동시에 출발한다
// = blocking : 차례대로 출발한다
// 시간에 따라 바꿔나가는 회로 = sequiential circuit