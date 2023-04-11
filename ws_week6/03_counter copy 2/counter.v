/* 
수업시간 칠판
https://docs.google.com/document/d/1pqUUXyV-446H0wwRoOOWJEajvgDLcEONUzW6a7cfHFk/edit
*/
module counter(
    input clk,
    input reset_b,
    input enable,
    input read,
    output [3:0] data
);

reg [3:0] count;
// wire [7:0] data;

assign data = read ? count : 8'bz; // floating 상태로 만들어야 신호를 왜곡없이 입력해줄 수 있다.

// FF으로 설계된.(negedge, posedge)
always @(negedge reset_b or posedge clk) // negative edge에서~
    if(~reset_b)
        // 실제로는 8bits의 flip-flop이 전체적으로 초기화 되기 충분한 시간이 필요하다. setup margin, setup violation(불완전한 데이터가 전달되는 것)
        count <= 8'b0; // 0을 7개 채우면 부족해서 error인건 알겠는데, 0말고 11넣으면 3으로 보는지 11로 볼지.
    else if(enable)
        count <= count + 1;
    // else 없어도 된다.
endmodule

// <= nonblocking : 동시에 출발한다
// = blocking : 차례대로 출발한다
// 시간에 따라 바꿔나가는 회로 = sequiential circuit