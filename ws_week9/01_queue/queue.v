/*
STACK : buffer에 PUSH를 주면 데이터가 하나씩 쌓이고, POP을 주면 마지막 데이터 나온다. LIFO
QUEUE : FIFO

queue의 포인터
    front, rear 두 개 있음.
        rear는 push에 데이터 어디까지 들어갔다고 표시해줌.
        front는 pop할 때 데이터 어디까지 없다고 표시해줌.
    front와 rear가 같이 있으면 비어있다고 알 수 있다. => empty
    rear가 데이터를 다 채우고 다시 돌아왔으면 front랑 같이 있게 된다.???????????? 박사 당황쓰
    rear가 데이터를 다 채우고 다시 돌아갈려는데 front가 있으면????  front랑 같이 있게 된다.
*/

module queue (
    input       clk,
    input       resetb,

    input [7:0] datain,
    input       push,

    output [7:0] dataout,
    input        pop,

    output       full,
    output       empty
);

reg [7:0] dataout;

// 입력과 읽을 때의 조건
wire wen;
wire ren;

assign  wen = push & !full;
assign ren = pop & !empty;

// full과 empty의 조건
wire full;
wire empty;

reg [2:0] pfront;
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        pfront <= 3'b111;
    else if(ren)
        pfront <= pfront +1;
    else
        pfront <= pfront;
end

assign empty = (front == rear) ? 1'b1 : 1'b0;
/*
여기서 rear+1이 0이면 좋겠는데 8로 인식되니 문제
이렇게 해도 8이 되기전에 full이 되서 문제가 생김
모르겠다~    
assign full = (front == (rear + 1)) ? 1'b1 : ((front - 1) == rear) ? 1'b1 : 1'b0;
*/
assign full = (pfront == rear) ? 1'b1 : 1'b0;


reg [7:0] QUEUE[7:0];
reg [2:0] front;
reg [2:0] rear;

// rear 증가 조건
always @ (negedge resetb or posedge clk)
    if(~resetb)
        rear <= 0;
    else if(wen)
        rear <= rear + 1; // 알아서 overflow나서 돌아감.
    else
        rear <= rear;

// front 증가 조건
always @ (negedge resetb or posedge clk)
    if(~resetb)
        front <= 0;
    else if(ren)
        front <= front + 1; // 알아서 overflow나서 돌아감.
    else
        front <= front;

// 데이터 입력 로직
always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[0] <= 0;
    else if ((rear == 0) & wen)
        QUEUE[0] <= datain;
    else
        QUEUE[0] <= QUEUE[0];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[1] <= 0;
    else if ((rear == 1) & wen)
        QUEUE[1] <= datain;
    else
        QUEUE[1] <= QUEUE[1];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[2] <= 0;
    else if ((rear == 2) & wen)
        QUEUE[2] <= datain;
    else
        QUEUE[2] <= QUEUE[2];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[3] <= 0;
    else if ((rear == 3) & wen)
        QUEUE[3] <= datain;
    else
        QUEUE[3] <= QUEUE[3];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[4] <= 0;
    else if ((rear == 4) & wen)
        QUEUE[4] <= datain;
    else
        QUEUE[4] <= QUEUE[4];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[5] <= 0;
    else if ((rear == 5) & wen)
        QUEUE[5] <= datain;
    else
        QUEUE[5] <= QUEUE[5];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[6] <= 0;
    else if ((rear == 6) & wen)
        QUEUE[6] <= datain;
    else
        QUEUE[6] <= QUEUE[6];
end

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        QUEUE[7] <= 0;
    else if ((rear == 7) & wen)
        QUEUE[7] <= datain;
    else
        QUEUE[7] <= QUEUE[7];
end

wire q0_ren;
wire q1_ren;
wire q2_ren;
wire q3_ren;
wire q4_ren;
wire q5_ren;
wire q6_ren;
wire q7_ren;

assign q0_ren = (front == 0) & ren;
assign q1_ren = (front == 1) & ren;
assign q2_ren = (front == 2) & ren;
assign q3_ren = (front == 3) & ren;
assign q4_ren = (front == 4) & ren;
assign q5_ren = (front == 5) & ren;
assign q6_ren = (front == 6) & ren;
assign q7_ren = (front == 7) & ren;

always @(posedge clk or negedge resetb) begin
    if(~resetb)
        dataout <= 0;
    else if (q0_ren)
        dataout <= QUEUE[0];
    else if (q1_ren)
        dataout <= QUEUE[1];
    else if (q2_ren)
        dataout <= QUEUE[2];
    else if (q3_ren)
        dataout <= QUEUE[3];
    else if (q4_ren)
        dataout <= QUEUE[4];
    else if (q5_ren)
        dataout <= QUEUE[5];
    else if (q6_ren)
        dataout <= QUEUE[6];
    else if (q7_ren)
        dataout <= QUEUE[7];
    else
        dataout <= dataout;
end

endmodule
