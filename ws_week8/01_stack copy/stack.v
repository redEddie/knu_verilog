/*
STACK : buffer에 PUSH를 주면 데이터가 하나씩 쌓이고, POP을 주면 마지막 데이터 나온다. LIFO
QUEUE : FIFO
*/

module stack (
    input       clk,
    input       resetb,

    input [7:0] datain,
    input       push, // 데이터 입력을 위한 push 명령어

    output [7:0] dataout,
    input        pop,

    // 스택의 상태를 알려주는 역할
    output       full,
    output       empty
);
reg [7:0] dataout;

// stack pointer를 만듬. 
reg [4:0] sp;          // 현재 buffer가 어디에 왔는지. 8개 버퍼이니 3비트.

// assign 사용을 위해 wire로 만듬.
wire full;
assign full = (sp == 8) ? 1'b1 : 1'b0; // 아래 참고.
// full 과 비슷하게 만들면 됨.
wire empty;
assign empty = (sp == 0) ? 1'b1 : 1'b0; // 8개까지 왔다면 버퍼7번이다. (0부터 있음)


/*
// 버퍼를 만듬과 버퍼의 크기를 설정
reg [7:0] buffer[0:7]; // 8비트가 0~7까지 8개 있다 = 버퍼가 8개다.
위험한? 코드니까 아래처럼 하라고 하네.
*/
reg [7:0] buffer0;
reg [7:0] buffer1;
reg [7:0] buffer2;
reg [7:0] buffer3;
reg [7:0] buffer4;
reg [7:0] buffer5;
reg [7:0] buffer6;
reg [7:0] buffer7;

// always 안에서 계산하지 말자. 조건은 밖에서 처리하도록.
wire writeen;
wire outputen;
assign writeen = push & !full;
assign outputen = pop & !empty;

// stack pointer의 동작
always @(posedge clk or negedge resetb ) begin
    if(~resetb)
        sp <= 0;
    else if(writeen)
        sp <= sp + 1;
    else if(outputen)
        sp <= sp - 1;
end




/*
// push 동작
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer[sp] <= 0;
    else if(writeen)
        buffer[sp] <= datain;
end
*/
wire buffer0_en;
assign buffer0_en = (sp == 0) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer0 <= 0;
    else if(buffer0_en)
        buffer0 <= datain;
end
wire buffer1_en;
assign buffer1_en = (sp == 1) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer1 <= 0;
    else if(buffer1_en)
        buffer1 <= datain;
end
wire buffer2_en;
assign buffer2_en = (sp == 2) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer2 <= 0;
    else if(buffer2_en)
        buffer2 <= datain;
end
wire buffer3_en;
assign buffer3_en = (sp == 3) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer3 <= 0;
    else if(buffer3_en)
        buffer3 <= datain;
end
wire buffer4_en;
assign buffer4_en = (sp == 4) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer4 <= 0;
    else if(buffer4_en)
        buffer4 <= datain;
end
wire buffer5_en;
assign buffer5_en = (sp == 5) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer5 <= 0;
    else if(buffer5_en)
        buffer5 <= datain;
end
wire buffer6_en;
assign buffer6_en = (sp == 6) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer6 <= 0;
    else if(buffer6_en)
        buffer6 <= datain;
end
wire buffer7_en;
assign buffer7_en = (sp == 7) & writeen;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        buffer7 <= 0;
    else if(buffer7_en)
        buffer7 <= datain;
end




/*
// pop 동작
always @(posedge clk or negedge resetb) begin
    if( ~resetb)
        dataout <= 0;
    else if(outputen)
        dataout <= buffer[sp];
end
*/
wire out0_en;
assign out0_en = (sp == 1) & outputen;

// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer0 <= 0;
//     else if(buffer7_en)
//         buffer0 <= datain;
// end
wire out1_en;
assign out1_en = (sp == 2) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer1 <= 0;
//     else if(buffer1_en)
//         buffer1 <= datain;
// end
wire out2_en;
assign out2_en = (sp == 3) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer2 <= 0;
//     else if(buffer2_en)
//         buffer2 <= datain;
// end
wire out3_en;
assign out3_en = (sp == 4) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer3 <= 0;
//     else if(buffer3_en)
//         buffer3 <= datain;
// end
wire out4_en;
assign out4_en = (sp == 5) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer4 <= 0;
//     else if(buffer4_en)
//         buffer4 <= datain;
// end
wire out5_en;
assign out5_en = (sp == 6) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer5 <= 0;
//     else if(buffer5_en)
//         buffer5 <= datain;
// end
wire out6_en;
assign out6_en = (sp == 7) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer6 <= 0;
//     else if(buffer7_en)
//         buffer6 <= datain;
// end
wire out7_en;
assign out7_en = (sp == 8) & outputen;
// always @(posedge clk or negedge resetb) begin
//     if(~resetb)
//         buffer7 <= 0;
//     else if(buffer7_en)
//         buffer7 <= datain;
// end

always@(negedge resetb or posedge clk)
    if(~resetb)
        dataout <= 0;
    else if(out0_en)
        dataout <= buffer0;
    else if(out1_en)
        dataout <= buffer1;
    else if(out2_en)
        dataout <= buffer2;
    else if(out3_en)
        dataout <= buffer3;
    else if(out4_en)
        dataout <= buffer4;
    else if(out5_en)
        dataout <= buffer5;
    else if(out6_en)
        dataout <= buffer6;
    else if(out7_en)
        dataout <= buffer7;


/*
assign dataout = (out0_en) ? buffer0 :
                 (out1_en) ? buffer1 :
                 (out2_en) ? buffer2 :
                 (out3_en) ? buffer3 :
                 (out4_en) ? buffer4 :
                 (out5_en) ? buffer5 :
                 (out6_en) ? buffer6 :
                 (out7_en) ? buffer7 : 0; */

/*
동작조건 이상하게 하지말자..
always @(posedge clk & negedge resetb) begin
    => always @(posedge clk or negedge resetb) begin
*/


endmodule


/*
sp는 데이터 넣고 +1 되므로 버퍼7번까지 데이터 8개 넣으면 얘는 8이 되어있다. 
따라서 7인줄 알았는데 8이고, 따라서 4비트가 필요하다.
*/