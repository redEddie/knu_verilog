module mux_2_1(a,s,y); // 2 by 1 mux 이름
input [1:0] a; // 2bits의 변수a
input s;
output y;

assign y = s ? a[1] : a[0];

endmodule