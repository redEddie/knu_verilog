module mux_test(a,s,y);
output [1:0] a; // output 부터해야 잘 됨. 연결할 때 수월하게 하기 위해 이렇게 함.
output s;
input y;

// input 과 실행파일과 output을 이어주는 것들
reg [1:0] a; // 리스트로 2bits 변수를 선언
reg s;
wire y;

initial begin
    a[0] = 1'b0; // b stands for binary , 1 stands for 1-bit
    a[1] = 1'b0;
    s = 1'b0;
    #100 $finish; // 100ns에 끝난다.
end

always #40 a[0] =~ a[0]; // 무조건 40ns마다 다음 명령어 시행
always #20 a[1] =~ a[1];
always #10 s = ~s;

endmodule