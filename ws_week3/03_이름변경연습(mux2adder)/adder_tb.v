module adder_tb();
// 다른파일과 연결할 wire
wire [1:0] n1;
wire n2, n3;

mux_test tester(n1, n2, n3); // a랑 s 가 밑으로 전달이 됨.

mux_2_1 dut (n1, n2, n3); // 윗줄의 n1, n2는 입력으로, n3는 다시 위로 출력

initial begin
    $dumpfile("tb_test_out.vcd");
    $dumpvars(0,dut);
end

endmodule