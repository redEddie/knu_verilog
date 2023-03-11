module mux_2_1(a,s,y); // 2 by 1 mux 이름
input [1:0] a; // 리스트로 반복시켜 a를 두개 만들었다.
input s;
output y;

assign y = s ? a[1] : a[0];

endmodule