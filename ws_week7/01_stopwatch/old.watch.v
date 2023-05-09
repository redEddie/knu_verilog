module watch(
    input       clk,
    input       reset_b,
    input       read, // !!!!!
    input       enable,
    input       capture,
    output [7:0] duration //정보받아야하는데 플로팅.
);

// counter모듈에서 받는 정보는 wire로.
wire [7:0] count;

reg [7:0] captured;
reg [7:0] duration; //reg로 만들면 플로팅 방지.

wire read_cnt;
assign read_cnt = read | capture; // 출력단의 count가 동작할 조건 변경.

counter cnt(
    .clk(clk),
    .reset_b(reset_b),
    .enable(enable),
    .read(read_cnt),
    .data(count)
);

always @(negedge reset_b or posedge clk)
    if(~reset_b)
        captured <= 0; // !!!!!
    else if(capture)
        // capture 할 때 count 값 불러오기.
        captured <= count;

always @(negedge reset_b or posedge clk)
    if(~reset_b)
        duration <= 8'b0; // !!!! 이름 안 바꿨었음. 8'b0랑 0이랑 차이없음.
    else if(read)
        // capture 할 때 count 값 불러오기.
        duration <= count - captured;
endmodule

